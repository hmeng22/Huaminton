//
//  detailsViewController.h
//  Huaminton
//
//  Created by MengHua on 5/2/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "RoundModal.h"

@interface detailsViewController : UIViewController

@property (strong, nonatomic) NSString *gameName;
@property (nonatomic) NSInteger homeSet;
@property (nonatomic) NSInteger awaySet;

@end
