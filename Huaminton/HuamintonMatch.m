//
//  HuamintonMatch.m
//  Huaminton
//
//  Created by MengHua on 4/25/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "HuamintonMatch.h"

@interface HuamintonMatch()

@end

@implementation HuamintonMatch

-(id)initHuamintonMatch:(NSUInteger)points{
    
    self = [super init];
    
    if (self) {
        _homePoint=0;
        _awayPoint=0;
        _maxPoint=points+9;
        _gamePoint=points;
        
        _homePointHistory = [[NSMutableArray alloc] init];
        _awayPointHistory = [[NSMutableArray alloc] init];
        
        [self addPointToHistoryAtIndex:0];
    }
    
    return self;
}

-(void)homeGetOnePointAtIndex:(NSUInteger)pointIndex {
    _homePoint++;
    [self addPointToHistoryAtIndex:pointIndex];
}

-(void)awayGetOnePointAtIndex:(NSUInteger)pointIndex {
    _awayPoint++;
    [self addPointToHistoryAtIndex:pointIndex];
}

-(void)addPointToHistoryAtIndex:(NSUInteger)pointIndex {
    [_homePointHistory insertObject:[NSNumber numberWithUnsignedInteger:_homePoint] atIndex:pointIndex];
    [_awayPointHistory insertObject:[NSNumber numberWithUnsignedInteger:_awayPoint] atIndex:pointIndex];
}

-(void)deletePointFromHistoryAtIndex:(NSUInteger)pointIndex{
    [_homePointHistory removeObjectAtIndex:pointIndex];
    _homePoint = (NSUInteger)[[_homePointHistory objectAtIndex:pointIndex-1] intValue];
    
    [_awayPointHistory removeObjectAtIndex:pointIndex];
    _awayPoint = (NSUInteger)[[_awayPointHistory objectAtIndex:pointIndex-1] intValue];
}

-(void)resetPoint {
    _homePoint=0;
    _awayPoint=0;
    
    _homePointHistory = [[NSMutableArray alloc] init];
    _awayPointHistory = [[NSMutableArray alloc] init];
    
    [self addPointToHistoryAtIndex:0];
}
@end
