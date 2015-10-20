//
//  ViewController.m
//  Huaminton
//
//  Created by MengHua on 4/23/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) HuamintonGame *game;

@property (weak, nonatomic) IBOutlet UIPickerView *roundsPointsPicker;
@property (strong, nonatomic) NSArray *roundsData;
@property (strong, nonatomic) NSArray *pointsData;

@property (weak, nonatomic) IBOutlet UIButton *homeAButton;
@property (weak, nonatomic) IBOutlet UIButton *awayAButton;
@property (weak, nonatomic) IBOutlet UIButton *homeBButton;
@property (weak, nonatomic) IBOutlet UIButton *awayBButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.game = [[HuamintonGame alloc] initHuamintonGame];
    
    self.roundsData = @[@"1", @"3", @"5", @"7"];
    self.pointsData = @[@"11", @"21", @"31"];
    self.roundsPointsPicker.delegate = self;
    self.roundsPointsPicker.dataSource = self;
    [self.roundsPointsPicker selectRow:1 inComponent:0 animated:FALSE];
    [self.roundsPointsPicker selectRow:1 inComponent:1 animated:FALSE];
    
    [self.homeAButton.layer setBorderWidth:4];
    [self.awayAButton.layer setBorderWidth:4];
    [self.homeBButton.layer setBorderWidth:4];
    [self.awayBButton.layer setBorderWidth:4];
    [self refreshButtons];
    
//    float x = 150.f;
//    UIImage *image = [UIImage imageNamed:@"c"];
//    UIGraphicsBeginImageContext(CGSizeMake(x, x));
//    [image drawInRect:CGRectMake(0, 0, x, x)];
//    UIImage *storageImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *pathString = [documentsPath objectAtIndex:0];
//    NSString *fileName = [pathString stringByAppendingString:@"/ha.jpg"];
//    NSFileManager *filem = [NSFileManager defaultManager];
//    [filem createFileAtPath:fileName contents:UIImageJPEGRepresentation(storageImage, 1.f) attributes:nil];
}

-(void)refreshButtons {
    HuamintonPlayer *p;
    UIColor *c;
    p = self.game.players[HUAMINTON_POSITIONS_HOMEA];
    c = self.game.colorUIColorArray[p.color];
    [self.homeAButton setTitle:p.name forState:UIControlStateNormal];
    [self.homeAButton.layer setBorderColor:c.CGColor];

    p = self.game.players[HUAMINTON_POSITIONS_AWAYA];
    c = self.game.colorUIColorArray[p.color];
    [self.awayAButton setTitle:p.name forState:UIControlStateNormal];
    [self.awayAButton.layer setBorderColor:c.CGColor];

    p = self.game.players[HUAMINTON_POSITIONS_HOMEB];
    c = self.game.colorUIColorArray[p.color];
    if (self.homeBButton.isEnabled) {
        [self.homeBButton setTitle:p.name forState:UIControlStateNormal];
        [self.homeBButton.layer setBorderColor:c.CGColor];
    } else {
        [self.homeBButton setTitle:p.name forState:UIControlStateNormal];
        [self.homeBButton.layer setBorderColor:[UIColor clearColor].CGColor];
    }
    
    p = self.game.players[HUAMINTON_POSITIONS_AWAYB];
    c = self.game.colorUIColorArray[p.color];
    if (self.awayBButton.isEnabled) {
        [self.awayBButton setTitle:p.name forState:UIControlStateNormal];
        [self.awayBButton.layer setBorderColor:c.CGColor];
    } else {
        [self.awayBButton setTitle:p.name forState:UIControlStateNormal];
        [self.awayBButton.layer setBorderColor:[UIColor clearColor].CGColor];
    }
}

- (IBAction)typeAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == HUAMINTON_TYPE_SINGLE) {
        self.game.type = HUAMINTON_TYPE_SINGLE;
        [self.homeBButton setEnabled:FALSE];
        [self.awayBButton setEnabled:FALSE];
    } else {
        self.game.type = HUAMINTON_TYPE_DOUBLE;
        [self.homeBButton setEnabled:TRUE];
        [self.awayBButton setEnabled:TRUE];
    }
    [self refreshButtons];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.roundsData.count;
    } else if (component == 1) {
        return self.pointsData.count;
    } else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.roundsData[row];
    } else if (component == 1) {
        return self.pointsData[row];
    } else
        return nil;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.game.rounds = row;
    } else if (component == 1) {
        self.game.points = row;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *templ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    templ.backgroundColor = [UIColor clearColor];
    templ.textAlignment = NSTextAlignmentCenter;
    templ.font = [UIFont boldSystemFontOfSize:40];
    templ.textColor = [UIColor colorWithRed:(CGFloat)77/255 green:(CGFloat)77/255 blue:(CGFloat)77/255 alpha:1.0];
    
    if (component==0) {
        templ.text=self.roundsData[row];
    }
    if (component==1) {
        templ.text=self.pointsData[row];
    }
    
    return templ;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"homeASegue"]) {
        playerViewController *playerView = segue.destinationViewController;
        playerView.player = self.game.players[HUAMINTON_PLAYER_HOMEA];
        playerView.colorArray = [self.game colorArray];
        playerView.colorAvailable = [self.game getColorAvaiableTo:HUAMINTON_POSITIONS_HOMEA];
    }
    if ([segue.identifier isEqualToString:@"homeBSegue"]) {
        playerViewController *playerView = segue.destinationViewController;
        playerView.player = self.game.players[HUAMINTON_PLAYER_HOMEB];
        playerView.colorArray = [self.game colorArray];
        playerView.colorAvailable = [self.game getColorAvaiableTo:HUAMINTON_POSITIONS_HOMEB];
    }
    if ([segue.identifier isEqualToString:@"awayBSegue"]) {
        playerViewController *playerView = segue.destinationViewController;
        playerView.player = self.game.players[HUAMINTON_PLAYER_AWAYB];
        playerView.colorArray = [self.game colorArray];
        playerView.colorAvailable = [self.game getColorAvaiableTo:HUAMINTON_POSITIONS_AWAYB];
    }
    if ([segue.identifier isEqualToString:@"awayASegue"]) {
        playerViewController *playerView = segue.destinationViewController;
        playerView.player = self.game.players[HUAMINTON_PLAYER_AWAYA];
        playerView.colorArray = [self.game colorArray];
        playerView.colorAvailable = [self.game getColorAvaiableTo:HUAMINTON_POSITIONS_AWAYA];
    }
    
    if ([segue.identifier isEqualToString:@"boardSegue"]) {
        [self.game initNewGame];
        boardViewController *boardView = segue.destinationViewController;
        boardView.game = self.game;
    }
    
    if ([segue.identifier isEqualToString:@"bluetoothIdentifier"]) {
        bluetoothViewController *btView = segue.destinationViewController;
        btView.bt = self.game.bt;
        NSLog(@"bluetooth view");
    }
}

- (IBAction)backFromView:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"backFromPlayerView"]) {
        [self refreshButtons];
    }
    
    if ([segue.identifier isEqualToString:@"exitFromBoardView"]) {
        //
    }
    
    if ([segue.identifier isEqualToString:@"doneFromBluetoothView"]) {
        NSLog(@"bt now is %@...",self.game.bt);
    }
}

-(BOOL)shouldAutorotate {
    return FALSE;
}

@end
