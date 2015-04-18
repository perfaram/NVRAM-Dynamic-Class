//
//  DynamicNVRAMTests.m
//  DynamicNVRAMTests
//
//  Created by Perceval FARAMAZ on 18/04/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NVRAM.h"

@interface DynamicNVRAMTests : XCTestCase {
	NVRAM* dynamicNVRAM;
}

@end

@implementation DynamicNVRAMTests

- (void)setUp {
    [super setUp];
	dynamicNVRAM = [NVRAM.alloc init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    //XCTAssert(YES, @"Pass");
	[[dynamicNVRAM methodList] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSLog(@"%@", [dynamicNVRAM performSelector:NSSelectorFromString(obj)]);
	}];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
