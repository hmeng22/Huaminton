//
//  graphViewController.m
//  Huaminton
//
//  Created by MengHua on 5/3/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "graphViewController.h"
#import "graphView.h"

@interface graphViewController ()

@end

@implementation graphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ((graphView *)self.view).homeHistory=self.homeHistory;
    ((graphView *)self.view).awayHistory=self.awayHistory;
}

-(BOOL)shouldAutorotate {
    return FALSE;
}

@end
