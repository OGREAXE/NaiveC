//
//  NCProject.m
//  NaiveC
//
//  Created by 梁志远 on 31/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCProject.h"

@implementation NCSourceFile : NSObject

@end

@implementation NCProject

-(id)initWithRoot:(NSString*)rootDirectory{
    self = [super init];
    if (self) {
        self.rootDirectory = rootDirectory;
        self.name = [rootDirectory lastPathComponent];
        
        [self reload];
    }
    return self;
}

-(void)reload{
    NSError * error = nil;
    NSArray * files = [[NSFileManager defaultManager]  contentsOfDirectoryAtPath:self.rootDirectory error:&error];
    if (!error) {
        NSMutableArray * sourceFiles = [NSMutableArray array];
        [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NCSourceFile * file = [[NCSourceFile alloc] init];
            file.filename = obj;
            file.filepath = [self.rootDirectory stringByAppendingString:file.filename];
            
            [sourceFiles addObject:file];
        }];
        self.sourceFiles = sourceFiles;
    }
    else {
        NSLog(@"error create project from directory %@, error:%@",self.rootDirectory,error);
    }
}

@end
