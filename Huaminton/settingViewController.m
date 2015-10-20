//
//  settingViewController.m
//  Huaminton
//
//  Created by MengHua on 4/25/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "settingViewController.h"
#import <MessageUI/MessageUI.h>

@interface settingViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *versionButton;

@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tapToReturn:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)versionButtonAction:(UIButton *)sender {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.versionButton setTitle:app_Version forState:UIControlStateNormal];
}

- (IBAction)aboutmeButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: ME_URL_STRING]];
}

- (IBAction)ratemeButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: APP_URL_STRING]];
}

- (IBAction)feedbackButtonAction:(UIButton *)sender {
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc setSubject:NSLocalizedString(@"subject", @"email subject")];
        [mc setToRecipients:[NSArray arrayWithObjects:ME_EMAIL, nil]];
        NSString *message = [NSString stringWithFormat:@"<HTML><BR/><BR/><BR/><B>%@</B><BR/><p>%@</p><p>%@</p><p>%@</p></HTML>",NSLocalizedString(@"message1", @"first"),NSLocalizedString(@"message2", "suggestions"),NSLocalizedString(@"message3", @"your"),NSLocalizedString(@"message4", @"finally")];
        [mc setMessageBody:message isHTML:YES];
        [self presentViewController:mc animated:YES completion:Nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch(result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(BOOL)shouldAutorotate {
    return FALSE;
}

@end
