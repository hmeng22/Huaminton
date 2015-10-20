//
//  RoundModal.m
//  Huaminton
//
//  Created by MengHua on 5/2/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "RoundModal.h"

@implementation RoundModal

- (instancetype)init {
    self = [super init];
    
    self.homeHistory = [[NSMutableArray alloc] init];
    self.awayHistory = [[NSMutableArray alloc] init];
    
    return self;
}

@end
