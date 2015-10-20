//
//  AppDelegate.m
//  Huaminton
//
//  Created by MengHua on 4/23/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDB.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathString = [documentsPath objectAtIndex:0];
    NSString *fileName = [pathString stringByAppendingString:@"/database.huaminton"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:fileName];
    
    if (![database open]) {
        NSLog(@"App Can Not Open database!");
    } else {
        if ([database tableExists:@"games"]) {
            NSLog(@"table games already exist!");
        } else {
            NSLog(@"create table games!");
            NSString *createTabelgames = @"CREATE TABLE games (  id INTEGER  PRIMARY KEY  AUTOINCREMENT,  gamename TEXT,  gamedate TEXT,  gametime TEXT,  gamenum  INTEGER,  type  INTEGER,  rounds  INTEGER,  points  INTEGER,  haname  TEXT,  hacolor  INTEGER,  haphotost  TEXT,  hbname  TEXT,  hbcolor  INTEGER,  hbphotost  TEXT,  aaname  TEXT,  aacolor  INTEGER,  aaphotost  TEXT,  abname  TEXT,  abcolor  INTEGER,  abphotost  TEXT,  hset  INTEGER,  aset  INTEGER  );";
            [database executeUpdate:createTabelgames];
        }
        
        if ([database tableExists:@"rounds"]) {
            NSLog(@"table rounds already exist!");
        } else {
            NSLog(@"create table rounds!");
            NSString *createTablerounds = @"CREATE TABLE rounds ( id INTEGER PRIMARY KEY AUTOINCREMENT, roundname	TEXT, roundtime	TEXT, pointnum	INTEGER DEFAULT 0, homepoint	INTEGER DEFAULT 0, awaypoint INTEGER DEFAULT 0, h0 INTEGER DEFAULT -1, h1 INTEGER DEFAULT -1, h2 INTEGER DEFAULT -1, h3 INTEGER DEFAULT -1, h4 INTEGER DEFAULT -1, h5 INTEGER DEFAULT -1, h6 INTEGER DEFAULT -1, h7 INTEGER DEFAULT -1, h8 INTEGER DEFAULT -1, h9 INTEGER DEFAULT -1, h10 INTEGER DEFAULT -1, h11 INTEGER DEFAULT -1, h12 INTEGER DEFAULT -1, h13 INTEGER DEFAULT -1, h14 INTEGER DEFAULT -1, h15 INTEGER DEFAULT -1, h16 INTEGER DEFAULT -1, h17 INTEGER DEFAULT -1, h18 INTEGER DEFAULT -1, h19 INTEGER DEFAULT -1, h20 INTEGER DEFAULT -1, h21 INTEGER DEFAULT -1, h22 INTEGER DEFAULT -1, h23 INTEGER DEFAULT -1, h24 INTEGER DEFAULT -1, h25 INTEGER DEFAULT -1, h26 INTEGER DEFAULT -1, h27 INTEGER DEFAULT -1, h28 INTEGER DEFAULT -1, h29 INTEGER DEFAULT -1, h30 INTEGER DEFAULT -1, h31 INTEGER DEFAULT -1, h32 INTEGER DEFAULT -1, h33 INTEGER DEFAULT -1, h34 INTEGER DEFAULT -1, h35 INTEGER DEFAULT -1, h36 INTEGER DEFAULT -1, h37 INTEGER DEFAULT -1, h38 INTEGER DEFAULT -1, h39 INTEGER DEFAULT -1, h40 INTEGER DEFAULT -1, h41 INTEGER DEFAULT -1, h42 INTEGER DEFAULT -1, h43 INTEGER DEFAULT -1, h44 INTEGER DEFAULT -1, h45 INTEGER DEFAULT -1, h46 INTEGER DEFAULT -1, h47 INTEGER DEFAULT -1, h48 INTEGER DEFAULT -1, h49 INTEGER DEFAULT -1, h50 INTEGER DEFAULT -1, h51 INTEGER DEFAULT -1, h52 INTEGER DEFAULT -1, h53 INTEGER DEFAULT -1, h54 INTEGER DEFAULT -1, h55 INTEGER DEFAULT -1, h56 INTEGER DEFAULT -1, h57 INTEGER DEFAULT -1, h58 INTEGER DEFAULT -1, h59 INTEGER DEFAULT -1, h60 INTEGER DEFAULT -1, h61 INTEGER DEFAULT -1, h62 INTEGER DEFAULT -1, h63 INTEGER DEFAULT -1, h64 INTEGER DEFAULT -1, h65 INTEGER DEFAULT -1, h66 INTEGER DEFAULT -1, h67 INTEGER DEFAULT -1, h68 INTEGER DEFAULT -1, h69 INTEGER DEFAULT -1, h70 INTEGER DEFAULT -1, h71 INTEGER DEFAULT -1, h72 INTEGER DEFAULT -1, h73 INTEGER DEFAULT -1, h74 INTEGER DEFAULT -1, h75 INTEGER DEFAULT -1, h76 INTEGER DEFAULT -1, h77 INTEGER DEFAULT -1, h78 INTEGER DEFAULT -1, h79 INTEGER DEFAULT -1, h80 INTEGER DEFAULT -1, a0 INTEGER DEFAULT -1, a1 INTEGER DEFAULT -1, a2 INTEGER DEFAULT -1, a3 INTEGER DEFAULT -1, a4 INTEGER DEFAULT -1, a5 INTEGER DEFAULT -1, a6 INTEGER DEFAULT -1, a7 INTEGER DEFAULT -1, a8 INTEGER DEFAULT -1, a9 INTEGER DEFAULT -1, a10 INTEGER DEFAULT -1, a11 INTEGER DEFAULT -1, a12 INTEGER DEFAULT -1, a13 INTEGER DEFAULT -1, a14 INTEGER DEFAULT -1, a15 INTEGER DEFAULT -1, a16 INTEGER DEFAULT -1, a17 INTEGER DEFAULT -1, a18 INTEGER DEFAULT -1, a19 INTEGER DEFAULT -1, a20 INTEGER DEFAULT -1, a21 INTEGER DEFAULT -1, a22 INTEGER DEFAULT -1, a23 INTEGER DEFAULT -1, a24 INTEGER DEFAULT -1, a25 INTEGER DEFAULT -1, a26 INTEGER DEFAULT -1, a27 INTEGER DEFAULT -1, a28 INTEGER DEFAULT -1, a29 INTEGER DEFAULT -1, a30 INTEGER DEFAULT -1, a31 INTEGER DEFAULT -1, a32 INTEGER DEFAULT -1, a33 INTEGER DEFAULT -1, a34 INTEGER DEFAULT -1, a35 INTEGER DEFAULT -1, a36 INTEGER DEFAULT -1, a37 INTEGER DEFAULT -1, a38 INTEGER DEFAULT -1, a39 INTEGER DEFAULT -1, a40 INTEGER DEFAULT -1, a41 INTEGER DEFAULT -1, a42 INTEGER DEFAULT -1, a43 INTEGER DEFAULT -1, a44 INTEGER DEFAULT -1, a45 INTEGER DEFAULT -1, a46 INTEGER DEFAULT -1, a47 INTEGER DEFAULT -1, a48 INTEGER DEFAULT -1, a49 INTEGER DEFAULT -1, a50 INTEGER DEFAULT -1, a51 INTEGER DEFAULT -1, a52 INTEGER DEFAULT -1, a53 INTEGER DEFAULT -1, a54 INTEGER DEFAULT -1, a55 INTEGER DEFAULT -1, a56 INTEGER DEFAULT -1, a57 INTEGER DEFAULT -1, a58 INTEGER DEFAULT -1, a59 INTEGER DEFAULT -1, a60 INTEGER DEFAULT -1, a61 INTEGER DEFAULT -1, a62 INTEGER DEFAULT -1, a63 INTEGER DEFAULT -1, a64 INTEGER DEFAULT -1, a65 INTEGER DEFAULT -1, a66 INTEGER DEFAULT -1, a67 INTEGER DEFAULT -1, a68 INTEGER DEFAULT -1, a69 INTEGER DEFAULT -1, a70 INTEGER DEFAULT -1, a71 INTEGER DEFAULT -1, a72 INTEGER DEFAULT -1, a73 INTEGER DEFAULT -1, a74 INTEGER DEFAULT -1, a75 INTEGER DEFAULT -1, a76 INTEGER DEFAULT -1, a77 INTEGER DEFAULT -1, a78 INTEGER DEFAULT -1, a79 INTEGER DEFAULT -1, a80 INTEGER DEFAULT -1);";
            [database executeUpdate:createTablerounds];
        }
        
        [database close];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathString = [documentsPath objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[pathString stringByAppendingString:@"/ha.jpg"]]) {
        [fileManager removeItemAtPath:[pathString stringByAppendingString:@"/ha.jpg"] error:nil];
    }
    if ([fileManager fileExistsAtPath:[pathString stringByAppendingString:@"/hb.jpg"]]) {
        [fileManager removeItemAtPath:[pathString stringByAppendingString:@"/hb.jpg"] error:nil];
    }
    if ([fileManager fileExistsAtPath:[pathString stringByAppendingString:@"/aa.jpg"]]) {
        [fileManager removeItemAtPath:[pathString stringByAppendingString:@"/aa.jpg"] error:nil];
    }
    if ([fileManager fileExistsAtPath:[pathString stringByAppendingString:@"/ab.jpg"]]) {
        [fileManager removeItemAtPath:[pathString stringByAppendingString:@"/ab.jpg"] error:nil];
    }
}

@end
