//
//  histroyViewController.m
//  Huaminton
//
//  Created by MengHua on 4/25/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "histroyViewController.h"
#import "detailsViewController.h"

@interface histroyViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) FMResultSet *rs;

@property (strong, nonatomic) NSMutableArray *gameArray;
@property (strong, nonatomic) NSMutableArray *sectionArray;

@property (strong, nonatomic) NSString *selectedGameName;
@property (nonatomic) NSInteger selectedHomeSet;
@property (nonatomic) NSInteger selectedAwaySet;
@end

@implementation histroyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.historyTableView.delegate=self;
    self.historyTableView.dataSource=self;
    
    self.gameArray = [[NSMutableArray alloc] init];
    self.sectionArray = [[NSMutableArray alloc] init];
    
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathString = [documentsPath objectAtIndex:0];
    NSString *fileName = [pathString stringByAppendingString:@"/database.huaminton"];
    
    NSLog(@"Database file is %@.",fileName);
    
    self.database = [FMDatabase databaseWithPath:fileName];
    
    if ([self.database open]) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        self.rs = [self.database executeQuery:@"select distinct gamedate from games order by gamedate desc"];
        while ([self.rs next]) {
            [dateFormat setDateFormat:@"yyyyMMdd"];
            NSDate *nowdate =[dateFormat dateFromString:[self.rs stringForColumn:@"gamedate"]];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            [self.sectionArray addObject:[dateFormat stringFromDate:nowdate]];
        }
        
        
        self.rs = [self.database executeQuery:@"select gamename,gamedate,gametime,gamenum,type,rounds,points,hset,aset from games order by gamedate desc"];
        while ([self.rs next]) {
            GameModal *gm = [[GameModal alloc] init];
            gm.gamename = [self.rs stringForColumn:@"gamename"];
            
            [dateFormat setDateFormat:@"yyyyMMdd"];
            NSDate *nowdate =[dateFormat dateFromString:[self.rs stringForColumn:@"gamedate"]];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            gm.gamedate = [dateFormat stringFromDate:nowdate];
            
            [dateFormat setDateFormat:@"HHmmss"];
            NSDate *nowtime =[dateFormat dateFromString:[self.rs stringForColumn:@"gametime"]];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            gm.gametime = [dateFormat stringFromDate:nowtime];
            
            gm.gamenum = [self.rs intForColumn:@"gamenum"];
            
            gm.type = [self.rs intForColumn:@"type"];
            gm.rounds = [self.rs intForColumn:@"rounds"];
            gm.points = [self.rs intForColumn:@"points"];
            gm.hset = [self.rs intForColumn:@"hset"];
            gm.aset = [self.rs intForColumn:@"aset"];
            
            [self.gameArray addObject:gm];
        }
        
        [self.database close];
    } else {
        NSLog(@"History View Can Not Open Database!");
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (NSString *)[self.sectionArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count=0;
    for (GameModal *gm in self.gameArray) {
        if ([gm.gamedate isEqualToString:[self.sectionArray objectAtIndex:section]]) {
            count++;
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *gameCellIdentifier = @"gameCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gameCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:gameCellIdentifier];
    }
    
    for (GameModal *gm in self.gameArray) {
        if ([gm.gamedate isEqualToString:[self.sectionArray objectAtIndex:[indexPath section]]] && gm.gamenum == [indexPath row]) {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
            cell.textLabel.text = [NSString stringWithFormat:@"%@  Home %ld : %ld Away",gm.gametime,(long)gm.hset,(long)gm.aset];
            cell.detailTextLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10.0];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Rounds | %ld Points",(long)gm.rounds,(long)gm.points];
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (GameModal *gm in self.gameArray) {
        if ([gm.gamedate isEqualToString:[self.sectionArray objectAtIndex:[indexPath section]]] && gm.gamenum == [indexPath row]) {
            
            self.selectedGameName=gm.gamename;
            self.selectedHomeSet=gm.hset;
            self.selectedAwaySet=gm.aset;
            
//            NSLog(@"selected gamename is %@,,,",gm.gamename);
            
            break;
        }
    }
    
    [self performSegueWithIdentifier:@"showDetailsIdentifier" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetailsIdentifier"]) {
        ((detailsViewController *)segue.destinationViewController).gameName = self.selectedGameName;
        ((detailsViewController *)segue.destinationViewController).homeSet = self.selectedHomeSet;
        ((detailsViewController *)segue.destinationViewController).awaySet = self.selectedAwaySet;
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (IBAction)doneAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(BOOL)shouldAutorotate {
    return FALSE;
}

@end
