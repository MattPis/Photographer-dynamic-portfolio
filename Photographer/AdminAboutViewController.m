//
//  AdminAboutViewController.m
//  Photographer
//
//  Created by Matt on 3/27/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "AdminAboutViewController.h"
#import "AdminGalleryViewController.h"

@interface AdminAboutViewController ()<UIScrollViewDelegate, UIScrollViewAccessibilityDelegate>
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *tel;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *website;
@property (strong, nonatomic) IBOutlet UITextField *blog;
@property (strong, nonatomic) IBOutlet UITextField *aboutHeader;
@property (strong, nonatomic) IBOutlet UITextView *about;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AdminAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.address.text = self.dataModel.address;
    self.city.text = self.dataModel.city;
    self.tel.text = self.dataModel.tel;
    self.email.text = self.dataModel.email;
    self.website.text = self.dataModel.website;
    self.blog.text = self.dataModel.blog;
    self.aboutHeader.text = self.dataModel.headerAbout;
    self.about.text = self.dataModel.about;
}
-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize:CGSizeMake(381, 600)];
}
- (IBAction)saveChangesTapped:(id)sender {
    self.dataModel.address= self.address.text;
    self.dataModel.city = self.city.text;
    self.dataModel.tel = self.tel.text;
    self.dataModel.email = self.email.text;
    self.dataModel.website = self.website.text;
    self.dataModel.blog = self.blog.text;

    self.dataModel.headerAbout = self.aboutHeader.text;
    self.dataModel.about = self.about.text;

    [self.dataModel saveInfo];
}
-(IBAction)handleToAdminGalleries:(id)sender{
    [self performSegueWithIdentifier:@"toGalleryAdmin" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AdminGalleryViewController *avc = [segue destinationViewController];
    avc.dataModel = self.dataModel;
}
-(IBAction)unwindToAboutAdmin:(UIStoryboardSegue *)segue {
}

#pragma mark Navigation Settings
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
