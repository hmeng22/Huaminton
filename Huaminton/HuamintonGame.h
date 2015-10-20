//
//  HuamintonGame.h
//  Huaminton
//
//  Created by MengHua on 4/23/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HuamintonPlayer.h"
#import "HuamintonMatch.h"
#import "FMDB.h"
#import "blueTooth.h"

@interface HuamintonGame : NSObject

enum HUAMINTON_TYPE{
    HUAMINTON_TYPE_SINGLE,
    HUAMINTON_TYPE_DOUBLE,
};
enum HUAMINTON_ROUNDS{
    HUAMINTON_ROUNDS_ONE,
    HUAMINTON_ROUNDS_THREE,
    HUAMINTON_ROUNDS_FIVE,
    HUAMINTON_ROUNDS_SEVEN,
    HUAMINTON_ROUNDS_COUNTS,
};
enum HUAMINTON_POINTS{
    HUAMINTON_POINTS_ELEVEN,
    HUAMINTON_POINTS_TWENTYONE,
    HUAMINTON_POINTS_THIRTYONE,
    HUAMINTON_POINTS_COUNTS,
};
enum HUAMINTON_POSITIONS{
    HUAMINTON_POSITIONS_HOMEA,
    HUAMINTON_POSITIONS_HOMEB,
    HUAMINTON_POSITIONS_AWAYB,
    HUAMINTON_POSITIONS_AWAYA,
};
enum HUAMINTON_PLAYER{
    HUAMINTON_PLAYER_HOMEA,
    HUAMINTON_PLAYER_HOMEB,
    HUAMINTON_PLAYER_AWAYB,
    HUAMINTON_PLAYER_AWAYA,
};
#define HOMEA_NAME @"HomeA"
#define HOMEB_NAME @"HomeB"
#define AWAYB_NAME @"AwayB"
#define AWAYA_NAME @"AwayA"

enum HUAMINTON_MENU{
    HUAMINTON_MENU_UNDO,
    HUAMINTON_MENU_RESET,
};

@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger rounds;
@property (nonatomic) NSInteger points;
@property (strong, nonatomic) NSArray *players;

@property (nonatomic) NSUInteger gameIndex;
@property (nonatomic) NSUInteger roundIndex;
@property (nonatomic) NSUInteger pointIndex;
@property (nonatomic) NSUInteger homeSet;
@property (nonatomic) NSUInteger awaySet;
@property (strong, nonatomic) HuamintonMatch *match;

@property (nonatomic) Boolean isLastScoreInHomeCourt;
@property (nonatomic) NSInteger server;
@property (nonatomic) NSMutableArray *serverHistory;
@property (nonatomic) NSMutableArray *positions;
@property (nonatomic) NSMutableArray *positionsHistory;

@property (nonatomic) Boolean isHomeGameWinner;
@property (nonatomic) Boolean isHomeRoundWinner;
@property (nonatomic) Boolean isNewRound;

@property (strong, nonatomic) NSArray *colorArray;
@property (strong, nonatomic) NSArray *colorUIColorArray;

@property (strong, nonatomic) blueTooth *bt;

-(id)initHuamintonGame;
-(void)initNewGame;
-(void)initNewRound;

-(void)homeGetOnePoint;
-(void)awayGetOnePoint;
-(Boolean)isContinueAfterGetOnePoint;

-(void)nextRound;

-(void)undoPoint;
-(void)resetPoint;

-(NSMutableArray *)getColorAvaiableTo:(NSUInteger)position;

@end
