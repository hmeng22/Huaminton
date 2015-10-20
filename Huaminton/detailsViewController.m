//
//  detailsViewController.m
//  Huaminton
//
//  Created by MengHua on 5/2/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "detailsViewController.h"
#import "graphViewController.h"
#import "HuamintonPlayer.h"

@interface detailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeALabel;
@property (weak, nonatomic) IBOutlet UILabel *awayALabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeAImageView;
@property (weak, nonatomic) IBOutlet UIImageView *awayAImageView;
@property (weak, nonatomic) IBOutlet UILabel *homeBLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayBLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeBImageView;
@property (weak, nonatomic) IBOutlet UIImageView *awayBImageView;
@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) FMResultSet *rs;

@property (strong, nonatomic) NSString *haName;
@property (nonatomic) NSInteger haColor;
@property (strong, nonatomic) NSString *haPhotoSt;
@property (strong, nonatomic) NSString *hbName;
@property (nonatomic) NSInteger hbColor;
@property (strong, nonatomic) NSString *hbPhotoSt;
@property (strong, nonatomic) NSString *aaName;
@property (nonatomic) NSInteger aaColor;
@property (strong, nonatomic) NSString *aaPhotoSt;
@property (strong, nonatomic) NSString *abName;
@property (nonatomic) NSInteger abColor;
@property (strong, nonatomic) NSString *abPhotoSt;

@property (strong, nonatomic) NSMutableArray *detailsArray;

@property (strong, nonatomic) NSMutableArray *homeHistory;
@property (strong, nonatomic) NSMutableArray *awayHistory;
@end

@implementation detailsViewController

- (void)viewWillLayoutSubviews {
    self.detailsTableView.delegate=self;
    self.detailsTableView.dataSource=self;
    
    self.detailsArray = [[NSMutableArray alloc] init];
    
    self.homeHistory = [[NSMutableArray alloc] init];
    self.awayHistory = [[NSMutableArray alloc] init];
    
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathString = [documentsPath objectAtIndex:0];
    NSString *fileName = [pathString stringByAppendingString:@"/database.huaminton"];
    
    self.database = [FMDatabase databaseWithPath:fileName];
    
    if ([self.database open]) {
        
        NSString *querySql = [NSString stringWithFormat:@"select * from games,rounds where games.gamename = %@ and rounds.roundname like '%@'",self.gameName,[NSString stringWithFormat:@"%@%@",self.gameName,@"%"]];
        
        //        NSLog(@"query sql is : %@.",querySql);
        
        self.rs = [self.database executeQuery:querySql];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        while ([self.rs next]) {
            RoundModal *rm = [[RoundModal alloc] init];
            self.haName = [self.rs stringForColumn:@"haname"];
            self.haColor = [self.rs intForColumn:@"hacolor"];
            self.haPhotoSt = [self.rs stringForColumn:@"haphotost"];
            self.hbName = [self.rs stringForColumn:@"hbname"];
            self.hbColor = [self.rs intForColumn:@"hbcolor"];
            self.hbPhotoSt = [self.rs stringForColumn:@"hbphotost"];
            self.aaName = [self.rs stringForColumn:@"aaname"];
            self.aaColor = [self.rs intForColumn:@"aacolor"];
            self.aaPhotoSt = [self.rs stringForColumn:@"aaphotost"];
            self.abName = [self.rs stringForColumn:@"abname"];
            self.abColor = [self.rs intForColumn:@"abcolor"];
            self.abPhotoSt = [self.rs stringForColumn:@"abphotost"];
            
            [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *now = [dateFormat dateFromString:[self.rs stringForColumn:@"roundtime"]];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            rm.roundtime = [dateFormat stringFromDate:now];
            
            rm.pointnum = [self.rs intForColumn:@"pointnum"];
            rm.homepoint = [self.rs intForColumn:@"homepoint"];
            rm.awaypoint = [self.rs intForColumn:@"awaypoint"];
            
            for (int p=0; p<=80; p++) {
                if (p<rm.pointnum) {
                    [rm.homeHistory addObject:[NSNumber numberWithInt:[self.rs intForColumn:[NSString stringWithFormat:@"h%d",p]]]];
                    [rm.awayHistory addObject:[NSNumber numberWithInt:[self.rs intForColumn:[NSString stringWithFormat:@"a%d",p]]]];
                } else {
                    break;
                }
            }
            
            [self.detailsArray addObject:rm];
        }
        
        [self.database close];
    } else {
        NSLog(@"Details View Can Not Open Database!");
    }
    
    self.resultLabel.text = [NSString stringWithFormat:@"%ld : %ld",(long)self.homeSet,(long)self.awaySet];
    
    self.homeALabel.text = self.haName;
    self.homeBLabel.text = self.hbName;
    self.awayALabel.text = self.aaName;
    self.awayBLabel.text = self.abName;
    
    [self.homeALabel.layer setBorderWidth:2];
    [self.homeALabel.layer setBorderColor:[self colorFromColorList:self.haColor].CGColor];
    [self.homeBLabel.layer setBorderWidth:2];
    [self.homeBLabel.layer setBorderColor:[self colorFromColorList:self.hbColor].CGColor];
    [self.awayALabel.layer setBorderWidth:2];
    [self.awayALabel.layer setBorderColor:[self colorFromColorList:self.aaColor].CGColor];
    [self.awayBLabel.layer setBorderWidth:2];
    [self.awayBLabel.layer setBorderColor:[self colorFromColorList:self.abColor].CGColor];
    
    fileName = [pathString stringByAppendingString:self.haPhotoSt];
    [self.homeAImageView setImage:[UIImage imageWithContentsOfFile:fileName]];
    fileName = [pathString stringByAppendingString:self.hbPhotoSt];
    [self.homeBImageView setImage:[UIImage imageWithContentsOfFile:fileName]];
    fileName = [pathString stringByAppendingString:self.aaPhotoSt];
    [self.awayAImageView setImage:[UIImage imageWithContentsOfFile:fileName]];
    fileName = [pathString stringByAppendingString:self.abPhotoSt];
    [self.awayBImageView setImage:[UIImage imageWithContentsOfFile:fileName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.detailsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *gameCellIdentifier = @"roundCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gameCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:gameCellIdentifier];
    }
    
    for (RoundModal *rm in self.detailsArray) {
        if ([self.detailsArray indexOfObjectIdenticalTo:rm] == [indexPath row]) {
            cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20.0];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",rm.roundtime];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:20.0];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Home %ld : %ld Away",(long)rm.homepoint,(long)rm.awaypoint];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.tintColor = [UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            
            break;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (RoundModal *rm in self.detailsArray) {
        if ([self.detailsArray indexOfObjectIdenticalTo:rm] == [indexPath row]) {
            
            self.homeHistory = rm.homeHistory;
            self.awayHistory = rm.awayHistory;
            
            break;
        }
    }
    
    [self performSegueWithIdentifier:@"showGraphIdentifier" sender:nil];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGraphIdentifier"]) {
        ((graphViewController *) segue.destinationViewController).homeHistory=self.homeHistory;
        ((graphViewController *) segue.destinationViewController).awayHistory=self.awayHistory;
    }
}

-(UIColor *)colorFromColorList:(NSInteger)color {
    switch (color) {
        case HUAMINTON_COLOR_RED:
            return [UIColor redColor];
        case HUAMINTON_COLOR_YELLOW:
            return [UIColor yellowColor];
        case HUAMINTON_COLOR_GREEN:
            return [UIColor greenColor];
            break;
        case HUAMINTON_COLOR_BLUE:
            return [UIColor blueColor];
            break;
        case HUAMINTON_COLOR_PURPLE:
            return [UIColor purpleColor];
            break;
        case HUAMINTON_COLOR_BROWN:
            return [UIColor brownColor];
            break;
        case HUAMINTON_COLOR_MAGENTA:
            return [UIColor magentaColor];
            break;
        case HUAMINTON_COLOR_CYAN:
            return [UIColor cyanColor];
    }
    return [UIColor clearColor];
}

-(BOOL)shouldAutorotate {
    return FALSE;
}

@end
