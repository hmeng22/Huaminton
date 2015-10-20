//
//  GameModal.h
//  Huaminton
//
//  Created by MengHua on 5/2/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModal : NSObject

@property (strong, nonatomic) NSString *gamename;
@property (strong, nonatomic) NSString *gamedate;
@property (strong, nonatomic) NSString *gametime;
@property (nonatomic) NSInteger gamenum;

@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger rounds;
@property (nonatomic) NSInteger points;

@property (nonatomic) NSInteger hset;
@property (nonatomic) NSInteger aset;

@end
