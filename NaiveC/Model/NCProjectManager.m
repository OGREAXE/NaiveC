//
//  NCProjectManager.m
//  NaiveC
//
//  Created by 梁志远 on 31/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCProjectManager.h"

@implementation NCProjectManager

+(instancetype)sharedManager{
    static NCProjectManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NCProjectManager alloc] init];
    });
    return instance;
}

-(NCProject*)defaultProject{
    NCProject * project = [[NCProject alloc] initWithRoot:[NSString stringWithFormat:@"%@/Documents/projects/project0/",NSHomeDirectory()]];
    return project;
}

-(BOOL)removeSourceFile:(NCSourceFile*)file project:(NCProject*)project error:(NSError**)error{
    [[NSFileManager defaultManager] removeItemAtPath:file.filepath error:error];
    if (*error) {
        return NO;
    }
    [project reload];
    return YES;
}

-(NCSourceFile*)createSourceFile:(NSString*)filename project:(NCProject*)project error:(NSError**)error{
    NSString * projectPath = project.rootDirectory;
    NSString * filepath = [projectPath stringByAppendingPathComponent:filename];
    
    [@"" writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:error];
    if (*error) {
        NSLog(@"write file fail: %@",*error);
        return nil;
    }
    
    NCSourceFile * file = [[NCSourceFile alloc] init];
    file.filename = filename;
    file.filepath = filepath;
    return file;
}

@end
