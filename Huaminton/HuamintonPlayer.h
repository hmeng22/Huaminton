//
//  HuamintonPlayer.h
//  Huaminton
//
//  Created by MengHua on 4/23/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HuamintonPlayer : NSObject

enum HUAMINTON_COLOR{
    HUAMINTON_COLOR_RED,
    HUAMINTON_COLOR_YELLOW,
    HUAMINTON_COLOR_GREEN,
    HUAMINTON_COLOR_BLUE,
    HUAMINTON_COLOR_PURPLE,
    HUAMINTON_COLOR_BROWN,
    HUAMINTON_COLOR_MAGENTA,
    HUAMINTON_COLOR_CYAN,
    HUAMINTON_COLOR_COUNTS,
};

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSString *photoImage;

-(id)initWithName:(NSString *)name Color:(NSUInteger)color photoString:(NSString *)photo;

@end
