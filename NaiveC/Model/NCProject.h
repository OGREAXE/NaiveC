//
//  NCProject.h
//  NaiveC
//
//  Created by 梁志远 on 31/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCSourceFile : NSObject

@property (nonatomic) NSString * filepath;

@property (nonatomic) NSString * filename;

@end

@interface NCProject : NSObject

@property (nonatomic) NSString * rootDirectory;

@property (nonatomic) NSArray * sourceFiles;

@property (nonatomic) NSString * name;

-(id)initWithRoot:(NSString*)rootDirectory;

-(void)reload;

@end
