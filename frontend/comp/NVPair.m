//
//  NVPair.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/23.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVPair.h"

@interface NVPair ()

@property (nonatomic) id object_first;
@property (nonatomic) id object_second;

@end

@implementation NVPair

+ (NVPair *)makePair:(id)obja second:(id)objb {
    NVPair *pair = [[NVPair alloc] init];
    pair.object_first = obja;
    pair.object_second = objb;
}

- (id)first {
    return self.object_first;
}

- (id)second {
    return self.object_second;
}

@end
