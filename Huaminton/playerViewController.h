//
//  playerViewController.h
//  Huaminton
//
//  Created by MengHua on 4/25/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuamintonPlayer.h"

@interface playerViewController : UIViewController

#define PHOTOSIZE 150.f

//in
@property (strong, nonatomic) HuamintonPlayer *player;
@property (strong, nonatomic) NSArray *colorArray;
@property (strong, nonatomic) NSMutableArray *colorAvailable;


@end
