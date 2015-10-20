
//
//  blueTooth.m
//  test
//
//  Created by MengHua on 5/17/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "blueTooth.h"

@interface blueTooth () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) UITableView *bluetoothTableView;

@end

@implementation blueTooth



- (void)initBlueTooth:(UITableView *)table
{
//    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_queue_create("CentralManagerQueue",DISPATCH_QUEUE_SERIAL)];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
    self.discoveredPeripheralList = [[NSMutableArray alloc] init];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.color = [UIColor blueColor];
    
    self.bluetoothTableView = table;
}

- (void)scan {
    NSLog(@"Start Scan");
    [self.spinner startAnimating];
    
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
    
    //delay秒以后停止
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds*NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.centralManager stopScan];
        [self.spinner stopAnimating];
        NSLog(@"Stop scan...");
        [self.bluetoothTableView reloadData];
    });
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManager Powered On");
            [self scan];
            break;
            
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManager Powered Off");
            if (self.discoveredPeripheral) {
                [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
            }
            break;
            
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManager Un Supported");
            break;
            
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManager Resetting");
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManager Unauthorized");
            break;
            
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManager Unknown");
            break;
    }
}


// discover a peripheral
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discover Peripheral... %@...",peripheral.debugDescription);
    // connect to the first discovered peripheral, normally we should add them into a list and connect later.
    
    NSLog(@"Numbers of Periheral : %lu ...",(unsigned long)[self.discoveredPeripheralList count]);
    
    if (![self.discoveredPeripheralList containsObject:peripheral]) {
        [self.discoveredPeripheralList addObject:peripheral];
    }
    
//    if (self.discoveredPeripheral != peripheral) {
//        self.discoveredPeripheral = peripheral;
//        NSLog(@"Connecting to peripheral %@", peripheral);
//        // Connects to the discovered peripheral
//        [self.centralManager connectPeripheral:peripheral options:nil];
//    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    self.discoveredPeripheral = peripheral;
    NSLog(@"Connecting to peripheral %@", peripheral);
    // Connects to the discovered peripheral
    [self.centralManager connectPeripheral:peripheral options:nil];
}

// success connection
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.centralManager stopScan];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:@"Connection Success!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    
    // set Peripheral delegate
    peripheral.delegate = self;
    
    // Clears the data that we may already have
    [self.data setLength:0];
    
    // peripheral properties
    NSString *aname = [[NSString alloc] initWithFormat:@"%@",peripheral.name];
    NSString *auuid = [[NSString alloc]initWithFormat:@"%@", peripheral.identifier];
    NSLog(@"Peripheral Name is %@...UUID is %@...", aname,auuid);
    
    // Asks the peripheral to discover the service
    CBUUID *tServiceUUID = [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID];
    CBUUID *bServiceUUID = [CBUUID UUIDWithString:BATTERY_SERVICE_UUID];
    
    [peripheral discoverServices:@[tServiceUUID, bServiceUUID]];
}

- (void)centralManager:(nonnull CBCentralManager *)central didDisconnectPeripheral:(nonnull CBPeripheral *)peripheral error:(nullable NSError *)error
{
    NSLog(@"DISCONNECTED... %@ ...", peripheral);
    NSLog(@"discovered periheral ... %@ ...",self.discoveredPeripheral);
    [self connectPeripheral:self.discoveredPeripheral];
}

// failure connection
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Connection Failure...");
}

// discover services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering service: %@", [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services) {
        NSLog(@"Service found with UUID: %@", service.UUID);
        // Discovers the characteristics for a given service
        if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]) {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_ONE_UUID]] forService:service];
        }
        if ([service.UUID isEqual:[CBUUID UUIDWithString:BATTERY_SERVICE_UUID]]) {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:BATTERY_CHARACTERISTIC_ONE_UUID]] forService:service];
        }
    }
}

// discover characteristic
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristic: %@", [error localizedDescription]);
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_ONE_UUID]]) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            
        }
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:BATTERY_SERVICE_UUID]]) {
        for (CBCharacteristic *charcteristic in service.characteristics) {
            if ([charcteristic.UUID isEqual:[CBUUID UUIDWithString:BATTERY_CHARACTERISTIC_ONE_UUID]]) {
                [peripheral setNotifyValue:YES forCharacteristic:charcteristic];
            }
        }
    }
}

// process data
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Exits if it's not the transfer characteristic
//    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_ONE_UUID]]) {
//        return;
//    }
    
    NSLog(@"Notification");
    
    // Notification has started
    if (characteristic.isNotifying) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_ONE_UUID]]) {
            NSLog(@"Notification began on %@", characteristic);
            [peripheral readValueForCharacteristic:characteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BATTERY_CHARACTERISTIC_ONE_UUID]]) {
            NSLog(@"Notification began on %@", characteristic);
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_ONE_UUID]]) {
        if( (characteristic.value)  || !error )
        {
            NSString* buttonString = [NSString stringWithUTF8String:[characteristic.value bytes]];
            NSLog(@"TRANSFER : ... %@ ... %@ ... ", characteristic.value, buttonString);
            
            if ([buttonString isEqualToString:HOME_BUTTON]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bluetoothNotifiy" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:HOME_BUTTON,KEY_BUTTON,nil]];
            }
            if ([buttonString isEqualToString:AWAY_BUTTON]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bluetoothNotifiy" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:AWAY_BUTTON,KEY_BUTTON,nil]];
            }
            if ([buttonString isEqualToString:UNDO_BUTTON]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bluetoothNotifiy" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:UNDO_BUTTON,KEY_BUTTON,nil]];
            }
            
        }
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BATTERY_CHARACTERISTIC_ONE_UUID]]) {
        if( (characteristic.value)  || !error )
        {
            NSLog(@"BATTERY : ... %@ ...", characteristic.value);
        }
    }
}

- (void)writeValue:(NSString *)str forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type
{
    NSData *comData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData* valData = [NSData dataWithBytes:(Byte *)[comData bytes] length:sizeof(comData)];
    [self.discoveredPeripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

@end
