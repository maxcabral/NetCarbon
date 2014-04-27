//
//  NetCarbonXTests.m
//  NetCarbonXTests
//
//  Created by Maxwell Cabral on 4/26/14.
//  Copyright (c) 2014 Maxwell Cabral. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NETCarbon.h"

@interface NetCarbonXTests : XCTestCase

@end

@implementation NetCarbonXTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNETGraphite
{
    NETCarbon *graphite = [[NETCarbon alloc] initWithHost:[[NSURL alloc] init]];
    graphite.timeout = 1;
    XCTAssertTrue([graphite connect],@"Connected to Graphite");
    XCTAssertTrue([graphite sendPath:@"foo.bar.baz" intValue:700 andTime:nil], @"Sent Data to Graphite");
    XCTAssertTrue([graphite sendPath:@"foo.bar.baz" intValue:100 andTime:[NSDate date]], @"Sent Data to Graphite");
    XCTAssertTrue([graphite sendPath:@"foo.bar.baz" intValue:1000 andTime:[NSDate date]], @"Sent Data to Graphite");
    XCTAssertTrue([graphite sendPath:@"foo.bar.baz" intValue:15 andTime:[NSDate date]], @"Sent Data to Graphite");
    
}


@end
