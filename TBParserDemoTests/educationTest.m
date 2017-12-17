//
//  educationTest.m
//  TBParserDemoTests
//
//  Created by 崔健 on 2017/11/4.
//  Copyright © 2017年 cy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TBPaserTool.h"
@interface educationTest : XCTestCase

@end

@implementation educationTest

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
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testTBParser{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"The_Bad_Education.torrent" ofType:nil];
    XCTAssertNotNil(path, @"path can not nil");
    NSDictionary *resultDict = [TBPaserTool parseWithFilePath:path];
    XCTAssertNotNil(resultDict, @"resultDict can not nil");
}
@end
