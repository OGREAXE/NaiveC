//
//  NaiveCTests.m
//  NaiveCTests
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/16.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NVCocoaEngine.h"

@interface NaiveCTests : XCTestCase
@property (nonatomic) NVCocoaEngine *engine;
@end

@implementation NaiveCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.engine = [[NVCocoaEngine alloc] init];
}

- (NSString *)codeTextForFileName:(NSString *)filename {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:filename ofType:@"nc"];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *code = [self codeTextForFileName:@"hello"];
    [self.engine run:code mode:NCInterpretorModeCommandLine error:nil];
    XCTAssert([[self.engine.result toString] isEqualToString:@"hello world"], @"result is not right");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
