//
//  LEDemoProject_CLITests.m
//  LEDemoProject-CLITests
//
//  Created by Darryl McAdams on 10/14/14.
//  Copyright (c) 2014 Language Engine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface LEDemoProject_CLITests : XCTestCase

@end

@implementation LEDemoProject_CLITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
