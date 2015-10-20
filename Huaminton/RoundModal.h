//
//  RoundModal.h
//  Huaminton
//
//  Created by MengHua on 5/2/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoundModal : NSObject

@property (strong, nonatomic) NSString *roundtime;
@property (nonatomic) NSInteger pointnum;
@property (nonatomic) NSInteger homepoint;
@property (nonatomic) NSInteger awaypoint;

@property (strong, nonatomic) NSMutableArray *homeHistory;
@property (strong, nonatomic) NSMutableArray *awayHistory;
@end
