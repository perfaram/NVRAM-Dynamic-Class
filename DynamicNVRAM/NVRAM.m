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
		nvram = [self NVRAMDump];
		[nvram enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			class_addMethod([self class], NSSelectorFromString(key), (IMP)newMethod, "v@:");
		}];
	}
	return self;
}

id newMethod(id self, SEL _cmd)
{
	Ivar nvramIvar = class_getInstanceVariable([self class], "nvram");
	id NVRAMIvar = object_getIvar(self, nvramIvar);
	return [NVRAMIvar objectForKey:NSStringFromSelector(_cmd)];
	
}

-(NSDictionary *) NVRAMDump {
	kern_return_t          		result;
	CFMutableDictionaryRef 		dict;
	mach_port_t         		masterPort;
	static io_registry_entry_t 	gOptionsRef;
	
	result = IOMasterPort(bootstrap_port, &masterPort);
	if (result != KERN_SUCCESS) {
		return [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"Error getting the IOMaster port: %s", mach_error_string(result)], @"error", nil];
	}
	gOptionsRef = IORegistryEntryFromPath(masterPort, "IODeviceTree:/options");
	if (gOptionsRef == 0) {
		return [[NSDictionary alloc]initWithObjectsAndKeys:@"nvram is not supported on this system", nil];
	}
	
	result = IORegistryEntryCreateCFProperties(gOptionsRef, &dict, 0, 0);
	if (result != kIOReturnSuccess) {
		return [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"Error getting the firmware variables: %s", mach_error_string(result)], @"error", nil];
	}
	
	return (__bridge NSDictionary *)(dict);
}

@end
