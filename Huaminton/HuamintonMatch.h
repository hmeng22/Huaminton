//
//  HuamintonMatch.h
//  Huaminton
//
//  Created by MengHua on 4/25/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuamintonMatch : NSObject

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;

@property (nonatomic) NSUInteger homePoint;
@property (nonatomic) NSUInteger awayPoint;
@property (nonatomic) NSUInteger maxPoint;
@property (nonatomic) NSUInteger gamePoint;

@property (strong, nonatomic) NSMutableArray *homePointHistory;
@property (strong, nonatomic) NSMutableArray *awayPointHistory;

-(id)initHuamintonMatch:(NSUInteger)points;

-(void)homeGetOnePointAtIndex:(NSUInteger)pointIndex;
-(void)awayGetOnePointAtIndex:(NSUInteger)pointIndex;
-(void)deletePointFromHistoryAtIndex:(NSUInteger)pointIndex;
-(void)resetPoint;

@end
