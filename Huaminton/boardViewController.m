//
//  boardViewController.m
//  Huaminton
//
//  Created by MengHua on 4/25/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "boardViewController.h"

@interface boardViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeALabel;
@property (weak, nonatomic) IBOutlet UILabel *homeBLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayALabel;
@property (weak, nonatomic) IBOutlet UILabel *awayBLabel;

@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *awayButton;

@property (strong, nonatomic) NSArray *imageViews;

@property (strong, nonatomic) NSString *pathString;
@end

@implementation boardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.homeALabel.layer setBorderWidth:8];
    [self.homeBLabel.layer setBorderWidth:8];
    [self.awayBLabel.layer setBorderWidth:8];
    [self.awayALabel.layer setBorderWidth:8];
    
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.pathString = [documentsPath objectAtIndex:0];
    
//    [self.homeButton setTransform:CGAffineTransformMakeRotation(M_PI/2)];
//    [self.awayButton setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRemoteNotifiy:) name:@"bluetoothNotifiy" object:nil];
}

- (void)viewDidLayoutSubviews {
    self.imageViews = [[NSArray alloc] initWithObjects:
                       [[UIImageView alloc] initWithFrame:self.homeALabel.bounds],
                       [[UIImageView alloc] initWithFrame:self.homeBLabel.bounds],
                       [[UIImageView alloc] initWithFrame:self.awayBLabel.bounds],
                       [[UIImageView alloc] initWithFrame:self.awayALabel.bounds], nil];
    [self.imageViews[0] setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageViews[1] setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageViews[2] setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageViews[3] setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.homeALabel addSubview:self.imageViews[0]];
    [self.homeBLabel addSubview:self.imageViews[1]];
    [self.awayBLabel addSubview:self.imageViews[2]];
    [self.awayALabel addSubview:self.imageViews[3]];
    
    [self refreshLabels];
}

- (IBAction)homeAction:(UIButton *)sender {
    [self.game homeGetOnePoint];
    
    [self afterHomeAwayAction];
    
    [self refreshLabels];
}

- (IBAction)awayAction:(UIButton *)sender {
    [self.game awayGetOnePoint];
    
    [self afterHomeAwayAction];
    
    [self refreshLabels];
}

- (void)afterHomeAwayAction {
    
    if ([self.game isContinueAfterGetOnePoint]) {
        // get point animation
        // if new round animation
        if (self.game.isNewRound) {
            
        }
    } else {
        // over animation
        [self performSegueWithIdentifier:@"exitFromBoardView" sender:nil];
    }
}

-(void)refreshLabels {
    [self.setLabel setText:[NSString stringWithFormat:@"%tu:%tu", self.game.homeSet, self.game.awaySet]];
    
    [self.homeButton setTitle:[NSString stringWithFormat:@"%tu", self.game.match.homePoint] forState:UIControlStateNormal];
    [self.awayButton setTitle:[NSString stringWithFormat:@"%tu", self.game.match.awayPoint] forState:UIControlStateNormal];
    
    [self refreshServerLabel];
    
    
    for (UIView *v in [self.homeALabel subviews]) {
        [v removeFromSuperview];
    }for (UIView *v in [self.homeBLabel subviews]) {
        [v removeFromSuperview];
    }for (UIView *v in [self.awayBLabel subviews]) {
        [v removeFromSuperview];
    }for (UIView *v in [self.awayALabel subviews]) {
        [v removeFromSuperview];
    }
    
    if (self.game.type == HUAMINTON_TYPE_SINGLE) {
        if (self.game.server == 0 || self.game.server == 1) {
            if (self.game.match.homePoint%2==0) {
                [self.homeALabel addSubview:self.imageViews[HUAMINTON_POSITIONS_HOMEA]];
                [self.imageViews[HUAMINTON_POSITIONS_HOMEA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_HOMEA]).photoImage]]];
                
                [self.awayALabel addSubview:self.imageViews[HUAMINTON_POSITIONS_AWAYA]];
                [self.imageViews[HUAMINTON_POSITIONS_AWAYA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_AWAYA]).photoImage]]];
            } else {
                [self.homeBLabel addSubview:self.imageViews[HUAMINTON_POSITIONS_HOMEA]];
                [self.imageViews[HUAMINTON_POSITIONS_HOMEA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_HOMEA]).photoImage]]];
                
                [self.awayBLabel addSubview:self.imageViews[HUAMINTON_POSITIONS_AWAYA]];
                [self.imageViews[HUAMINTON_POSITIONS_AWAYA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_AWAYA]).photoImage]]];
            }
        } else {
            if (self.game.match.awayPoint%2==0) {
                [self.homeALabel addSubview:self.imageViews[HUAMINTON_POSITIONS_HOMEA]];
                [self.imageViews[HUAMINTON_POSITIONS_HOMEA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_HOMEA]).photoImage]]];
                
                [self.awayALabel addSubview:self.imageViews[HUAMINTON_POSITIONS_AWAYA]];
                [self.imageViews[HUAMINTON_POSITIONS_AWAYA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_AWAYA]).photoImage]]];
            } else {
                [self.homeBLabel addSubview:self.imageViews[HUAMINTON_POSITIONS_HOMEA]];
                [self.imageViews[HUAMINTON_POSITIONS_HOMEA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_HOMEA]).photoImage]]];
                
                [self.awayBLabel addSubview:self.imageViews[HUAMINTON_POSITIONS_AWAYA]];
                [self.imageViews[HUAMINTON_POSITIONS_AWAYA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_AWAYA]).photoImage]]];
            }
        }
    }
    
    if (self.game.type == HUAMINTON_TYPE_DOUBLE) {
        
        [self.homeALabel addSubview:self.imageViews[HUAMINTON_POSITIONS_HOMEA]];
        [self.imageViews[HUAMINTON_POSITIONS_HOMEA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[[self.game.positions[HUAMINTON_POSITIONS_HOMEA] intValue]]).photoImage]]];
        
        [self.homeBLabel addSubview:self.imageViews[HUAMINTON_POSITIONS_HOMEB]];
        [self.imageViews[HUAMINTON_POSITIONS_HOMEB] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[[self.game.positions[HUAMINTON_POSITIONS_HOMEB] intValue]]).photoImage]]];
        
        [self.awayBLabel addSubview:self.imageViews[HUAMINTON_POSITIONS_AWAYB]];
        [self.imageViews[HUAMINTON_POSITIONS_AWAYB] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[[self.game.positions[HUAMINTON_POSITIONS_AWAYB] intValue]]).photoImage]]];
        
        [self.awayALabel addSubview:self.imageViews[HUAMINTON_POSITIONS_AWAYA]];
        [self.imageViews[HUAMINTON_POSITIONS_AWAYA] setImage:[UIImage imageWithContentsOfFile:[self.pathString stringByAppendingString:((HuamintonPlayer *)self.game.players[[self.game.positions[HUAMINTON_POSITIONS_AWAYA] intValue]]).photoImage]]];
    }


    
//    if (self.game.type == HUAMINTON_TYPE_SINGLE) {
//        if ((self.game.match.homePoint+self.game.match.awayPoint)%2==0) {
//            
//            [self.homeALabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[0] unsignedIntegerValue]]).color]).CGColor];
//            
//            [self.awayALabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[3] unsignedIntegerValue]]).color]).CGColor];
//            
//            [self.homeBLabel.layer setBorderColor:[UIColor clearColor].CGColor];
//            [self.awayBLabel.layer setBorderColor:[UIColor clearColor].CGColor];
//            
//        } else {
//            [self.homeBLabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[1] unsignedIntegerValue]]).color]).CGColor];
//            
//            [self.awayBLabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[2] unsignedIntegerValue]]).color]).CGColor];
//            
//            [self.homeALabel.layer setBorderColor:[UIColor clearColor].CGColor];
//            [self.awayALabel.layer setBorderColor:[UIColor clearColor].CGColor];
//        }
//    }
//    
//    if (self.game.type == HUAMINTON_TYPE_DOUBLE) {
//        [self.homeALabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[HUAMINTON_POSITIONS_HOMEA] unsignedIntegerValue]]).color]).CGColor];
//        
//        [self.awayALabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[HUAMINTON_POSITIONS_AWAYA] unsignedIntegerValue]]).color]).CGColor];
//        
//        [self.homeBLabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[HUAMINTON_POSITIONS_HOMEB] unsignedIntegerValue]]).color]).CGColor];
//        
//        [self.awayBLabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[HUAMINTON_POSITIONS_AWAYB] unsignedIntegerValue]]).color]).CGColor];
//    }
    
}

-(void)refreshServerLabel {
    
    [self.homeALabel.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.homeBLabel.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.awayBLabel.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.awayALabel.layer setBorderColor:[UIColor clearColor].CGColor];
    
    switch (self.game.server) {
        case HUAMINTON_POSITIONS_HOMEA:
            [self.homeALabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[self.game.server] unsignedIntegerValue]]).color]).CGColor];
            break;
        case HUAMINTON_POSITIONS_HOMEB:
            [self.homeBLabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[self.game.server] unsignedIntegerValue]]).color]).CGColor];
            break;
        case HUAMINTON_POSITIONS_AWAYB:
            [self.awayBLabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[self.game.server] unsignedIntegerValue]]).color]).CGColor];
            break;
        case HUAMINTON_POSITIONS_AWAYA:
            [self.awayALabel.layer setBorderColor:((UIColor *)self.game.colorUIColorArray[((HuamintonPlayer *)self.game.players[[self.game.positions[self.game.server] unsignedIntegerValue]]).color]).CGColor];
            break;
    }
    
    
//    for (UIView *v in [self.homeALabel subviews]) {
//        [v removeFromSuperview];
//    }for (UIView *v in [self.homeBLabel subviews]) {
//        [v removeFromSuperview];
//    }for (UIView *v in [self.awayBLabel subviews]) {
//        [v removeFromSuperview];
//    }for (UIView *v in [self.awayALabel subviews]) {
//        [v removeFromSuperview];
//    }
//    
//    switch (self.game.server) {
//        case HUAMINTON_POSITIONS_HOMEA:
//            [self.homeALabel addSubview:self.imageViews[HUAMINTON_POSITIONS_HOMEA]];
//            [self.imageViews[HUAMINTON_POSITIONS_HOMEA] setImage:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_HOMEA]).photoImage];
//            break;
//        case HUAMINTON_POSITIONS_HOMEB:
//            [self.homeBLabel addSubview:self.imageViews[HUAMINTON_POSITIONS_HOMEB]];
//            [self.imageViews[HUAMINTON_POSITIONS_HOMEB] setImage:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_HOMEB]).photoImage];
//            break;
//        case HUAMINTON_POSITIONS_AWAYB:
//            [self.awayBLabel addSubview:self.imageViews[HUAMINTON_POSITIONS_AWAYB]];
//            [self.imageViews[HUAMINTON_POSITIONS_AWAYB] setImage:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_HOMEB]).photoImage];
//            break;
//        case HUAMINTON_POSITIONS_AWAYA:
//            [self.awayALabel addSubview:self.imageViews[HUAMINTON_POSITIONS_AWAYA]];
//            [self.imageViews[HUAMINTON_POSITIONS_AWAYA] setImage:((HuamintonPlayer *)self.game.players[HUAMINTON_POSITIONS_HOMEB]).photoImage];
//            break;
//    }
}

- (IBAction)menuAction:(UIButton *)sender {
    UIActionSheet *menuSheet = [[UIActionSheet alloc] initWithTitle:@"Functions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Undo", @"Reset", nil];
    menuSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [menuSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == HUAMINTON_MENU_UNDO) {
        [self.game undoPoint];
    }
    if (buttonIndex == HUAMINTON_MENU_RESET) {
        [self.game resetPoint];
    }
    
    [self refreshLabels];
}

-(void)getRemoteNotifiy:(NSNotification *)aNotification
{
    NSLog(@"get Notifiy...%@...",[aNotification userInfo]);
    if ([[[aNotification userInfo] objectForKey:KEY_BUTTON] isEqualToString:HOME_BUTTON]) {
        [self homeAction:nil];
    }
    if ([[[aNotification userInfo] objectForKey:KEY_BUTTON] isEqualToString:AWAY_BUTTON]) {
        [self awayAction:nil];
    }
    if ([[[aNotification userInfo] objectForKey:KEY_BUTTON] isEqualToString:UNDO_BUTTON]) {
        [self.game undoPoint];
        [self refreshLabels];
    }
}


-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(BOOL)shouldAutorotate {
    switch ([[UIDevice currentDevice] orientation]) {
        case UIInterfaceOrientationLandscapeLeft:
            [self.homeButton setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
            [self.awayButton setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            [self.homeButton setTransform:CGAffineTransformMakeRotation(M_PI/2)];
            [self.awayButton setTransform:CGAffineTransformMakeRotation(M_PI/2)];
            break;
            
        case UIInterfaceOrientationPortrait:
            [self.homeButton setTransform:CGAffineTransformMakeRotation(0)];
            [self.awayButton setTransform:CGAffineTransformMakeRotation(0)];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            [self.homeButton setTransform:CGAffineTransformMakeRotation(M_PI)];
            [self.awayButton setTransform:CGAffineTransformMakeRotation(M_PI)];
            break;
        default:
            break;
    }
    NSLog(@"Rotate");
    return FALSE;
}

@end
