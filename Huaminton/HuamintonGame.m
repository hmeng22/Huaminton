//
//  HuamintonGame.m
//  Huaminton
//
//  Created by MengHua on 4/23/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "HuamintonGame.h"

@interface HuamintonGame ()

@property (strong, nonatomic) FMDatabase *database;

@end

@implementation HuamintonGame

#pragma mark - initMethods
-(id)initHuamintonGame {
    
    self = [super init];
    
    if (self) {
        self.type = HUAMINTON_TYPE_SINGLE;
        self.rounds = HUAMINTON_ROUNDS_THREE;
        self.points = HUAMINTON_POINTS_TWENTYONE;
        
        _colorArray = [[NSArray alloc] initWithObjects:
                           [NSNumber numberWithInt:HUAMINTON_COLOR_RED],
                           [NSNumber numberWithInt:HUAMINTON_COLOR_YELLOW],
                           [NSNumber numberWithInt:HUAMINTON_COLOR_GREEN],
                           [NSNumber numberWithInt:HUAMINTON_COLOR_BLUE],
                           [NSNumber numberWithInt:HUAMINTON_COLOR_PURPLE],
                           [NSNumber numberWithInt:HUAMINTON_COLOR_BROWN],
                           [NSNumber numberWithInt:HUAMINTON_COLOR_MAGENTA],
                           [NSNumber numberWithInt:HUAMINTON_COLOR_CYAN], nil];
        
        _colorUIColorArray = [[NSArray alloc] initWithObjects:
                                  [UIColor redColor],
                                  [UIColor yellowColor],
                                  [UIColor greenColor],
                                  [UIColor blueColor],
                                  [UIColor purpleColor],
                                  [UIColor brownColor],
                                  [UIColor magentaColor],
                                  [UIColor cyanColor], nil];
        
        NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *pathString = [documentsPath objectAtIndex:0];
        NSString *fileName = [pathString stringByAppendingString:@"/database.huaminton"];
        
        NSLog(@"Database file is %@.",fileName);
        
        self.database = [FMDatabase databaseWithPath:fileName];
        
        documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        pathString = [documentsPath objectAtIndex:0];
        _players = [[NSArray alloc] initWithObjects:
                    [[HuamintonPlayer alloc] initWithName:HOMEA_NAME Color:HUAMINTON_PLAYER_HOMEA photoString:[pathString stringByAppendingString:@"/ha.jpg"]],
                    [[HuamintonPlayer alloc] initWithName:HOMEB_NAME Color:HUAMINTON_PLAYER_HOMEB photoString:[pathString stringByAppendingString:@"/hb.jpg"]],
                    [[HuamintonPlayer alloc] initWithName:AWAYB_NAME Color:HUAMINTON_PLAYER_AWAYB photoString:[pathString stringByAppendingString:@"/ab.jpg"]],
                    [[HuamintonPlayer alloc] initWithName:AWAYA_NAME Color:HUAMINTON_PLAYER_AWAYA photoString:[pathString stringByAppendingString:@"/aa.jpg"]],nil];
        
        self.bt = [[blueTooth alloc] init];
        
    }
    
    return self;
}

-(void)initNewGame {
    
    _roundIndex = 0;
    
    _homeSet = 0;
    _awaySet = 0;
    _pointIndex = 0;
    
    _match = [[HuamintonMatch alloc] initHuamintonMatch:self.points];
    
    _serverHistory = [[NSMutableArray alloc] init];
    _positionsHistory = [[NSMutableArray alloc] init];
    
    _server = arc4random()%2*3;
    _isLastScoreInHomeCourt=(_server==HUAMINTON_POSITIONS_HOMEA)?true:false;
    if (self.type==HUAMINTON_TYPE_SINGLE) {
        _positions = [[NSMutableArray alloc] initWithObjects:
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_HOMEA],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_HOMEA],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_AWAYA],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_AWAYA], nil];
    }
    if (self.type==HUAMINTON_TYPE_DOUBLE) {
        _positions = [[NSMutableArray alloc] initWithObjects:
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_HOMEA],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_HOMEB],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_AWAYB],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_AWAYA], nil];
        
        if (_server == HUAMINTON_PLAYER_HOMEA) {
            if (arc4random()%2==1) {
                [_positions exchangeObjectAtIndex:HUAMINTON_PLAYER_HOMEA withObjectAtIndex:HUAMINTON_PLAYER_HOMEB];
            }
        } else {
            if (arc4random()%2==1) {
                [_positions exchangeObjectAtIndex:HUAMINTON_PLAYER_AWAYA withObjectAtIndex:HUAMINTON_PLAYER_AWAYB];
            }
        }
    }
    
    ((HuamintonPlayer *)self.players[0]).photoImage = @"/ha.jpg";
    ((HuamintonPlayer *)self.players[1]).photoImage = @"/hb.jpg";
    ((HuamintonPlayer *)self.players[2]).photoImage = @"/ab.jpg";
    ((HuamintonPlayer *)self.players[3]).photoImage = @"/aa.jpg";
    
    [self addServerAndPositionsToHistoryAtIndex:_pointIndex];
    
    [self saveGameInitData];
    [self saveNewRoundData];
    
}

-(void)initNewRound {
    _roundIndex++;
    
    _pointIndex = 0;
    _match = [[HuamintonMatch alloc] initHuamintonMatch:self.points];
    
    _serverHistory = [[NSMutableArray alloc] init];
    _positionsHistory = [[NSMutableArray alloc] init];
    
    if (_isHomeRoundWinner) {
        _server = 0;
    } else {
        _server = 3;
    }
    _isLastScoreInHomeCourt=(_server==HUAMINTON_POSITIONS_HOMEA)?true:false;
    
    if (self.type==HUAMINTON_TYPE_SINGLE) {
        _positions = [[NSMutableArray alloc] initWithObjects:
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_HOMEA],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_HOMEA],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_AWAYA],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_AWAYA], nil];
    }
    
    if (self.type==HUAMINTON_TYPE_DOUBLE) {
        _positions = [[NSMutableArray alloc] initWithObjects:
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_HOMEA],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_HOMEB],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_AWAYB],
                      [[NSNumber alloc] initWithUnsignedInteger:HUAMINTON_PLAYER_AWAYA], nil];
        
        if (_server == HUAMINTON_PLAYER_HOMEA) {
            if (arc4random()%2==1) {
                [_positions exchangeObjectAtIndex:HUAMINTON_PLAYER_HOMEA withObjectAtIndex:HUAMINTON_PLAYER_HOMEB];
            }
        } else {
            if (arc4random()%2==1) {
                [_positions exchangeObjectAtIndex:HUAMINTON_PLAYER_AWAYA withObjectAtIndex:HUAMINTON_PLAYER_AWAYB];
            }
        }
    }
    
    [self addServerAndPositionsToHistoryAtIndex:_pointIndex];
    
    [self saveNewRoundData];
    
}

-(void)setRounds:(NSInteger)rounds {
    switch (rounds) {
        case HUAMINTON_ROUNDS_ONE:
            _rounds = 1;
            break;
        case HUAMINTON_ROUNDS_THREE:
            _rounds = 3;
            break;
        case HUAMINTON_ROUNDS_FIVE:
            _rounds = 5;
            break;
        case HUAMINTON_ROUNDS_SEVEN:
            _rounds = 7;
            break;
        default:
            break;
    }
}

-(void)setPoints:(NSInteger)points {
    switch (points) {
        case HUAMINTON_POINTS_ELEVEN:
            _points = 11;
            break;
        case HUAMINTON_POINTS_TWENTYONE:
            _points = 21;
            break;
        case HUAMINTON_POINTS_THIRTYONE:
            _points = 31;
            break;
        default:
            break;
    }
    _match = [[HuamintonMatch alloc] initHuamintonMatch:self.points];
}

-(NSMutableArray *)getColorAvaiableTo:(NSUInteger)position {
    NSMutableArray *colorAvailable = [[NSMutableArray alloc] initWithArray:_colorArray copyItems:TRUE];
    
    if (position == -1) {
        return colorAvailable;
    }
    
    if (self.type == HUAMINTON_TYPE_SINGLE) {
        [colorAvailable removeObjectAtIndex:((HuamintonPlayer *)_players[((position+1)%2)*3]).color];
    }
    
    if (self.type == HUAMINTON_TYPE_DOUBLE) {
        NSArray *pcolor = [[NSArray alloc] initWithObjects:[NSNumber numberWithUnsignedInteger:((HuamintonPlayer *)_players[(position+1)%4]).color], [NSNumber numberWithUnsignedInteger:((HuamintonPlayer *)_players[(position+2)%4]).color], [NSNumber numberWithUnsignedInteger:((HuamintonPlayer *)_players[(position+3)%4]).color], nil];
        [colorAvailable removeObjectsInArray:pcolor];
        
    }
    return colorAvailable;
}

#pragma mark - actionMethods
-(void)homeGetOnePoint {
    [_match homeGetOnePointAtIndex:_pointIndex];
    
    [self setServerPositionsWithHomeCourtScore:TRUE];
    [self setPlayersPositionsWithHomeCourtScore:TRUE IsLastScoreInHomeCourt:_isLastScoreInHomeCourt];
    
    _isLastScoreInHomeCourt=true;
    
    [self addServerAndPositionsToHistoryAtIndex:_pointIndex];
}

-(void)awayGetOnePoint {
    [_match awayGetOnePointAtIndex:_pointIndex];
    
    [self setServerPositionsWithHomeCourtScore:FALSE];
    [self setPlayersPositionsWithHomeCourtScore:FALSE IsLastScoreInHomeCourt:_isLastScoreInHomeCourt];
    
    _isLastScoreInHomeCourt=false;
    
    [self addServerAndPositionsToHistoryAtIndex:_pointIndex];
}

-(void)setServerPositionsWithHomeCourtScore:(Boolean)isHomeCourtScore {
    if (isHomeCourtScore) {
        
        if (_match.homePoint%2==0) {
            _server=HUAMINTON_POSITIONS_HOMEA;
        } else {
            _server=HUAMINTON_POSITIONS_HOMEB;
        }
        
    } else {
        
        if (_match.awayPoint%2==0) {
            _server=HUAMINTON_POSITIONS_AWAYA;
        } else {
            _server=HUAMINTON_POSITIONS_AWAYB;
        }
        
    }
}

-(void)setPlayersPositionsWithHomeCourtScore:(Boolean)isHomeCourtScore IsLastScoreInHomeCourt:(Boolean)isLastScoreInHomeCourt
{
    if (isHomeCourtScore) {
        
        if (isLastScoreInHomeCourt) {
            // switch home court players' positions
            [_positions exchangeObjectAtIndex:HUAMINTON_POSITIONS_HOMEA withObjectAtIndex:HUAMINTON_POSITIONS_HOMEB];
        }
        
    } else {
        
        if (!isLastScoreInHomeCourt) {
            // switch away court players' positions
            [_positions exchangeObjectAtIndex:HUAMINTON_POSITIONS_AWAYA withObjectAtIndex:HUAMINTON_POSITIONS_AWAYB];
        }
    }
}

-(void)swithcCourtPlayers {
    // change device orientation
}

#pragma mark - logicalMethods
-(Boolean)isContinueAfterGetOnePoint {
    
    if ([self isRoundEnd]) {
        _isNewRound = TRUE;
        [self saveRoundResultData];
        [self saveGameResultData];
        
        if ([self isGameEnd]) {
            return FALSE;
        } else {
            [self nextRound];
            return TRUE;
        }
    } else {
        _isNewRound = FALSE;
        return TRUE;
    }
    
}

-(Boolean)isRoundEnd {
    if (_match.homePoint==_match.gamePoint && _match.awayPoint < _match.gamePoint-1) {
        _homeSet++;
        _isHomeRoundWinner = TRUE;
        return TRUE;
    }
    if (_match.awayPoint==_match.gamePoint && _match.homePoint < _match.gamePoint-1) {
        _awaySet++;
        _isHomeRoundWinner = FALSE;
        return TRUE;
    }
    if (_match.homePoint>=self.points-1 && _match.awayPoint>=self.points-1) {
        if (_match.homePoint==_match.maxPoint || _match.homePoint-_match.awayPoint==2) {
            _homeSet++;
            _isHomeRoundWinner = TRUE;
            return TRUE;
        }
        if (_match.awayPoint==_match.maxPoint || _match.awayPoint-_match.homePoint==2) {
            _awaySet++;
            _isHomeRoundWinner = FALSE;
            return TRUE;
        }
    }
    return FALSE;
}

-(Boolean)isGameEnd {
    if (_homeSet>self.rounds/2) {
        _isHomeGameWinner=TRUE;
        return TRUE;
    }
    if (_awaySet>self.rounds/2) {
        _isHomeGameWinner=FALSE;
        return TRUE;
    }
    return FALSE;
}

-(void)nextRound {
    [self initNewRound];
}

#pragma mark - functionMethods
-(void)undoPoint {
    if (_pointIndex>1) {
        _pointIndex--;
        [_match deletePointFromHistoryAtIndex:_pointIndex];
        
        [self deleteServerAndPositionsFromHistoryAtIndex:_pointIndex];
    }
}

-(void)resetPoint {
    if (_pointIndex>0) {
        [_match resetPoint];
        _pointIndex=0;
        
        _server = [[_serverHistory objectAtIndex:_pointIndex] intValue];
        _serverHistory = [[NSMutableArray alloc] init];
        _positions = [_positionsHistory objectAtIndex:_pointIndex];
        _positionsHistory = [[NSMutableArray alloc] init];
        
        [self addServerAndPositionsToHistoryAtIndex:_pointIndex];
    }
}

#pragma mark - historyMethods
-(void)addServerAndPositionsToHistoryAtIndex:(NSUInteger)pointIndex {
    [_serverHistory insertObject:[NSNumber numberWithUnsignedInteger:_server] atIndex:pointIndex];
    
    [_positionsHistory insertObject:_positions atIndex:pointIndex];
    
    _pointIndex++;
}

-(void)deleteServerAndPositionsFromHistoryAtIndex:(NSUInteger)pointIndex {
    [_serverHistory removeObjectAtIndex:_pointIndex];
    _server = [[_serverHistory objectAtIndex:_pointIndex-1] intValue];
    
    [_positionsHistory removeObjectAtIndex:_pointIndex];
    _positions = [_positionsHistory objectAtIndex:_pointIndex-1];
}

-(void)saveGameInitData {
    // type, rounds, points, players
    NSLog(@"Save Game Data...");
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *gameName = [dateFormat stringFromDate:now];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString *gameDate = [dateFormat stringFromDate:now];
    [dateFormat setDateFormat:@"HHmmss"];
    NSString *gameTime = [dateFormat stringFromDate:now];
    NSLog(@"gameName is %@ .",gameName);
    
    if ([self.database open]) {
        NSString *latestDate;
        FMResultSet *rs = [self.database executeQuery:@"select gamedate,gamenum from games order by id desc limit 1"];
        while ([rs next]) {
            latestDate = [rs stringForColumn:@"gamedate"];
            _gameIndex = [rs intForColumn:@"gamenum"];
        }
        
        NSLog(@"gameDate is %@,,,,latestDate is %@,,,",gameDate,latestDate);
        if ([gameDate isEqualToString:latestDate]) {
            _gameIndex++;
            NSLog(@"gameDate = latestDate,,,gameIndex:%lu,,,",(unsigned long)_gameIndex);
        } else {
            _gameIndex=0;
            NSLog(@"gameDate !!!!!!= latestDate");
        }
        
        // format photo address strings
        NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *pathString = [documentsPath objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        for (int t=0; t<4; t++) {
            NSString *fileName = [pathString stringByAppendingString:((HuamintonPlayer *)self.players[t]).photoImage];
            if ([fileManager fileExistsAtPath:fileName]) {
                NSString *newFileName = [NSString stringWithFormat:@"/%@%d.jpg",gameName,t];
                [fileManager createFileAtPath:[pathString stringByAppendingString:newFileName] contents:[fileManager contentsAtPath:fileName] attributes:nil];
                ((HuamintonPlayer *)self.players[t]).photoImage = newFileName;
            }
        }
        
        [self.database executeUpdate:@"insert into games(gamename,gamedate,gametime,gamenum,type,rounds,points,haname,hacolor,haphotost,hbname,hbcolor,hbphotost,aaname,aacolor,aaphotost,abname,abcolor,abphotost,hset,aset) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",gameName,gameDate,gameTime,[NSNumber numberWithInteger:_gameIndex],[NSNumber numberWithInteger:self.type],[NSNumber numberWithInteger:self.rounds],[NSNumber numberWithInteger:self.points],((HuamintonPlayer *)self.players[0]).name,[NSNumber numberWithInteger:((HuamintonPlayer *)self.players[0]).color],((HuamintonPlayer *)self.players[0]).photoImage,((HuamintonPlayer *)self.players[1]).name,[NSNumber numberWithInteger:((HuamintonPlayer *)self.players[1]).color],((HuamintonPlayer *)self.players[1]).photoImage,((HuamintonPlayer *)self.players[3]).name,[NSNumber numberWithInteger:((HuamintonPlayer *)self.players[3]).color],((HuamintonPlayer *)self.players[3]).photoImage,((HuamintonPlayer *)self.players[2]).name,[NSNumber numberWithInteger:((HuamintonPlayer *)self.players[2]).color],((HuamintonPlayer *)self.players[2]).photoImage,[NSNumber numberWithInteger:self.homeSet],[NSNumber numberWithInteger:self.awaySet]];
        [self.database close];
    } else {
        NSLog(@"GameInit Can Not Open Database!");
    }
}

-(void)saveNewRoundData {
    NSLog(@"Save New Round Data...");
    
    NSString *roundname;
    if ([self.database open]) {
        FMResultSet *rs = [self.database executeQuery:@"select gamename from games order by id desc limit 1"];
        while ([rs next]) {
            roundname = [[rs stringForColumn:@"gamename"] stringByAppendingFormat:@"%lu",(unsigned long)self.roundIndex];
        }
        [self.database close];
    }
    NSLog(@"New Round roundname is %@,,,",roundname);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *roundtime = [dateFormat stringFromDate:now];
    
    if ([self.database open]) {
        [self.database executeUpdate:@"insert into rounds(roundname,roundtime) values(?,?)",roundname,roundtime];
        [self.database close];
    }
}

-(void)saveRoundResultData {
    // homePointHistory, awayPointHistory
    NSLog(@"Save Round Result Data...");
    
    NSString *roundname;
    if ([self.database open]) {
        FMResultSet *rs = [self.database executeQuery:@"select * from rounds order by id desc limit 1"];
        while ([rs next]) {
            roundname = [rs stringForColumn:@"roundname"];
        }
        [self.database close];
    }
    NSLog(@"Round Result roundname is %@,,,",roundname);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:roundname forKey:@"roundname"];
    
    for (int p=0; p<=80; p++) {
        if (p<[self.match.homePointHistory count]) {
            [dictionary setObject:[self.match.homePointHistory objectAtIndex:p] forKey:[NSString stringWithFormat:@"h%d",p]];
            [dictionary setObject:[self.match.awayPointHistory objectAtIndex:p] forKey:[NSString stringWithFormat:@"a%d",p]];
            [dictionary setObject:[NSNumber numberWithInt:p] forKey:@"pointnum"];
            [dictionary setObject:[self.match.homePointHistory objectAtIndex:p] forKey:@"homepoint"];
            [dictionary setObject:[self.match.awayPointHistory objectAtIndex:p] forKey:@"awaypoint"];
        } else {
            [dictionary setObject:[NSNumber numberWithInt:-1] forKey:[NSString stringWithFormat:@"h%d",p]];
            [dictionary setObject:[NSNumber numberWithInt:-1] forKey:[NSString stringWithFormat:@"a%d",p]];
        }
    }
    
    if ([self.database open]) {
        [self.database executeUpdate:@"update rounds set pointnum=:pointnum,homepoint=:homepoint,awaypoint=:awaypoint,h0=:h0,h1=:h1,h2=:h2,h3=:h3,h4=:h4,h5=:h5,h6=:h6,h7=:h7,h8=:h8,h9=:h9,h10=:h10,h11=:h11,h12=:h12,h13=:h13,h14=:h14,h15=:h15,h16=:h16,h17=:h17,h18=:h18,h19=:h19,h20=:h20,h21=:h21,h22=:h22,h23=:h23,h24=:h24,h25=:h25,h26=:h26,h27=:h27,h28=:h28,h29=:h29,h30=:h30,h31=:h31,h32=:h32,h33=:h33,h34=:h34,h35=:h35,h36=:h36,h37=:h37,h38=:h38,h39=:h39,h40=:h40,h41=:h41,h42=:h42,h43=:h43,h44=:h44,h45=:h45,h46=:h46,h47=:h47,h48=:h48,h49=:h49,h50=:h50,h51=:h51,h52=:h52,h53=:h53,h54=:h54,h55=:h55,h56=:h56,h57=:h57,h58=:h58,h59=:h59,h60=:h60,h61=:h61,h62=:h62,h63=:h63,h64=:h64,h65=:h65,h66=:h66,h67=:h67,h68=:h68,h69=:h69,h70=:h70,h71=:h71,h72=:h72,h73=:h73,h74=:h74,h75=:h75,h76=:h76,h77=:h77,h78=:h78,h79=:h79,h80=:h80,a0=:a0,a1=:a1,a2=:a2,a3=:a3,a4=:a4,a5=:a5,a6=:a6,a7=:a7,a8=:a8,a9=:a9,a10=:a10,a11=:a11,a12=:a12,a13=:a13,a14=:a14,a15=:a15,a16=:a16,a17=:a17,a18=:a18,a19=:a19,a20=:a20,a21=:a21,a22=:a22,a23=:a23,a24=:a24,a25=:a25,a26=:a26,a27=:a27,a28=:a28,a29=:a29,a30=:a30,a31=:a31,a32=:a32,a33=:a33,a34=:a34,a35=:a35,a36=:a36,a37=:a37,a38=:a38,a39=:a39,a40=:a40,a41=:a41,a42=:a42,a43=:a43,a44=:a44,a45=:a45,a46=:a46,a47=:a47,a48=:a48,a49=:a49,a50=:a50,a51=:a51,a52=:a52,a53=:a53,a54=:a54,a55=:a55,a56=:a56,a57=:a57,a58=:a58,a59=:a59,a60=:a60,a61=:a61,a62=:a62,a63=:a63,a64=:a64,a65=:a65,a66=:a66,a67=:a67,a68=:a68,a69=:a69,a70=:a70,a71=:a71,a72=:a72,a73=:a73,a74=:a74,a75=:a75,a76=:a76,a77=:a77,a78=:a78,a79=:a79,a80=:a80 where roundname=:roundname;" withParameterDictionary:dictionary];
        [self.database close];
    }
}


-(void)saveGameResultData {
    NSLog(@"Save Game Result Data...");
    
    NSString *gamename;
    if ([self.database open]) {
        FMResultSet *rs = [self.database executeQuery:@"select * from games order by id desc limit 1"];
        while ([rs next]) {
            gamename = [rs stringForColumn:@"gamename"];
        }
        [self.database close];
    }
    NSLog(@"Game Result gamename is %@,,,",gamename);
    
    if ([self.database open]) {
        [self.database executeUpdate:@"update games set hset=?, aset=? where gamename=?",[NSNumber numberWithInteger:self.homeSet],[NSNumber numberWithInteger:self.awaySet],gamename];
        [self.database close];
    }
}

@end
