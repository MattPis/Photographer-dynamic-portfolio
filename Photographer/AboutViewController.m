//
//  AboutViewController.m
//  Photographer
//
//  Created by Matt on 3/22/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AdminAboutViewController.h"

@interface AboutViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *aboutTextField;
@property (strong, nonatomic) IBOutlet UILabel *navLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *header;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aboutTextField.text = self.dataModel.about;
    [self.aboutTextField setFont:[UIFont fontWithName:@"Heiti SC" size:15]];
    self.aboutTextField.textAlignment = NSTextAlignmentJustified;
    self.aboutTextField.scrollEnabled = YES;
    self.header.text = self.dataModel.headerAbout;
    self.imageView.image = self.dataModel.aboutImage;

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.aboutTextField setContentOffset:CGPointZero animated:YES] ;
}
-(void)drawShadow{
    CALayer *layer = self.imageView.layer;
    layer.shadowOffset = CGSizeMake(5, 5);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 5.5f;
    layer.shadowOpacity = 0.60f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];

}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self showPasswordInput];

    }
}

-(void)showPasswordInput{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Admin Access" message:@"provide Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alertView textFieldAtIndex:0];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([[alertView textFieldAtIndex:0].text isEqualToString: self.dataModel.password]) {
        [self performSegueWithIdentifier:@"toAdmin" sender:self];
    }
    else{
        [self showWrongPasswordError];
    }
}
-(void)showWrongPasswordError{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong Password" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];

    [alertView show];


}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toAdmin"]) {
        AdminAboutViewController *avc = [segue destinationViewController];
        avc.dataModel = self.dataModel;
    }
}
-(IBAction)unwindToAbout:(UIStoryboardSegue *)segue {
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
