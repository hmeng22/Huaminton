//
//  blueTooth.h
//  test
//
//  Created by MengHua on 5/17/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface blueTooth : NSObject

#define SERVICE_UUID @"FFF0"

#define TRANSFER_SERVICE_UUID @"0xFFF0"
#define TRANSFER_CHARACTERISTIC_ONE_UUID @"FFF3"

#define BATTERY_SERVICE_UUID @"0x180F"
#define BATTERY_CHARACTERISTIC_ONE_UUID @"2A19"

#define HOME_BUTTON @"7"
#define AWAY_BUTTON @";"
#define UNDO_BUTTON @"="
#define KEY_BUTTON @"BUTTON"

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray *discoveredPeripheralList;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;

-(void)initBlueTooth:(UITableView *)table;
-(void)connectPeripheral:(CBPeripheral *)peripheral;

@end
