//
//  NCConsole.h
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2017/12/26.
//  Copyright © 2017年 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined __cplusplus
extern "C" {
#endif
    void NCLog(NSString *format, ...);
#if defined __cplusplus
};
#endif

#define NCWriteConsole(fmt, ...) [[NCConsole sharedInstance] write:[NSString stringWithFormat:fmt,##__VA_ARGS__]]

@interface NCConsole : NSObject

+(instancetype)sharedInstance;

-(void)write:(NSString*)text;

@end
