//
//  HuamintonPlayer.m
//  Huaminton
//
//  Created by MengHua on 4/23/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "HuamintonPlayer.h"

@interface HuamintonPlayer ()

@end

@implementation HuamintonPlayer

-(id)initWithName:(NSString *)name Color:(NSUInteger)color photoString:(NSString *)photo {
    
    self = [super init];
    
    if (self) {
        self.name = name;
        self.color = color;
        self.photoImage = photo;
    }
    
    return self;
}

@end
