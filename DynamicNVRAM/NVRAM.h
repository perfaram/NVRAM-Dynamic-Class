//
//  NVRAM.h
//  DynamicNVRAM
//
//  Created by Perceval FARAMAZ on 18/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NVRAM : NSObject {
	NSDictionary* nvram;
}

-(id) init;
-(NSDictionary *) NVRAMDump;
@end
