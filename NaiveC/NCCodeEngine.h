//
//  NCCodeEngine.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/16.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NCInterpretorMode) {
    NCInterpretorModeModular = 0,
    NCInterpretorModeCommandLine,
};

@protocol NCCodeEngine <NSObject>

@property (nonatomic) NCInterpretorMode mode;

//used in project
- (void)setRoot:(NSString *)rootDir;
- (void)setDirty:(NSString *)filename;
- (BOOL)run;
- (BOOL)runWithError:(NSError **)error;

//play ground only
//run a piece of code
- (BOOL)run:(NSString *)sourceCode error:(NSError **)error;
- (BOOL)run:(NSString *)sourceCode
       mode:(NCInterpretorMode)mode
      error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
