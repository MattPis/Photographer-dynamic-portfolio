//
//  ContactViewController.m
//  Photographer
//
//  Created by Matt on 3/17/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "ContactViewController.h"
#import <MessageUI/MessageUI.h>
@interface ContactViewController () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UIButton *tel;
@property (strong, nonatomic) IBOutlet UIButton *email;
@property (strong, nonatomic) IBOutlet UIButton *website;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.address.text = self.dataModel.address;
    self.city.text = self.dataModel.city;
    [self.tel setTitle:[NSString stringWithFormat:@"Tel: %@",self.dataModel.tel] forState:UIControlStateNormal];
    [self.email setTitle: [NSString stringWithFormat:@"Email: %@",self.dataModel.email] forState:UIControlStateNormal];
    [self.website setTitle:[NSString stringWithFormat:@"Website: %@", self.dataModel.website] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)callHandler:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.dataModel.tel]];

}
- (IBAction)emailHandler:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Title";
    // Email Content
    NSString *messageBody = @"Message here";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.dataModel.email];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    

}
- (IBAction)websiteHandler:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.dataModel.website]]];

}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
