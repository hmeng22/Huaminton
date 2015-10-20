//
//  bluetoothViewController.m
//  Huaminton
//
//  Created by MengHua on 6/13/15.
//  Copyright © 2015 menghua.cn. All rights reserved.
//

#import "bluetoothViewController.h"

@interface bluetoothViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *bluetoothTableView;

@end

@implementation bluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bluetoothTableView.dataSource = self;
    self.bluetoothTableView.delegate = self;
    
    [self.bt initBlueTooth:self.bluetoothTableView];
    self.bt.spinner.center = self.view.center;
    [self.view addSubview:self.bt.spinner];
}

- (IBAction)doneAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Table count %lu,",(unsigned long)[self.bt.discoveredPeripheralList count]);
    return [self.bt.discoveredPeripheralList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *bluetoothCellIdentifier = @"bluetoothCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bluetoothCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:bluetoothCellIdentifier];
    }
    
    // Configure the cell...
    CBPeripheral *p = [self.bt.discoveredPeripheralList objectAtIndex:[indexPath item]];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    cell.textLabel.text = p.name;
    cell.detailTextLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10.0];
    cell.detailTextLabel.text = p.description;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.tintColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *p = [self.bt.discoveredPeripheralList objectAtIndex:[indexPath item]];
    [self.bt connectPeripheral:p];
    
//    //10秒以后停止
//    double delayInSeconds = 5.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds*NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        if (self.bt.discoveredPeripheral.state == CBPeripheralStateConnected) {
//            [self doneAction:nil];
//        } else {
//            [self tableView:self.bluetoothTableView didSelectRowAtIndexPath:indexPath];
//        }
//    });
    
    NSLog(@"Bluetooth state : ... %@ ...",self.bt.discoveredPeripheral.debugDescription);
}

@end
