//
//  UIViewController+NCExtension.h
//  NaiveC
//
//  Created by 梁志远 on 01/01/2018.
//  Copyright © 2018 Ogreaxe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertComfirmHandler) (void);

@interface UIViewController (NCExtension)

-(void)ShowAlert:(NSString * )content comfirmHandler:(AlertComfirmHandler)handler;

@end
