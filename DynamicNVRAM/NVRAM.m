//
//  NVRAM.m
//  DynamicNVRAM
//
//  Created by Perceval FARAMAZ on 18/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import "NVRAM.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

@implementation NVRAM
-(id) init {
	self = [super init];
	if (self) {
		BOOL dumpResult = [self NVRAMDump];
		properties = [NSMutableArray.alloc init];
		[nvram enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			class_addMethod([self class], NSSelectorFromString(key), (IMP)newMethod, "v@:");
			objc_setAssociatedObject(self, NSSelectorFromString(key), obj, OBJC_ASSOCIATION_RETAIN);
			[properties addObject:key];
		}];
	}
	return self;
}

id newMethod(id self, SEL _cmd)
{
	return objc_getAssociatedObject(self, _cmd);
}

-(NSMutableArray*) methodList {
	return properties;
}

-(BOOL) NVRAMDump {
	kern_return_t          		result;
	CFMutableDictionaryRef 		dict;
	mach_port_t         		masterPort;
	static io_registry_entry_t 	gOptionsRef;
	
	result = IOMasterPort(bootstrap_port, &masterPort);
	if (result != KERN_SUCCESS) {
		return false;
	}
	gOptionsRef = IORegistryEntryFromPath(masterPort, "IODeviceTree:/options");
	if (gOptionsRef == 0) {
		return false;
	}
	
	result = IORegistryEntryCreateCFProperties(gOptionsRef, &dict, 0, 0);
	if (result != kIOReturnSuccess) {
		return false;
	}
	self->nvram = (__bridge NSDictionary *)(dict);
	return true;
}

@end
