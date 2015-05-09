//
//  AdminAboutViewController.m
//  Photographer
//
//  Created by Matt on 3/27/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "AdminAboutViewController.h"
#import "AdminGalleryViewController.h"
#import "FeaturedAdminViewController.h"
@interface AdminAboutViewController ()<UIScrollViewDelegate, UIScrollViewAccessibilityDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *tel;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *website;
@property (strong, nonatomic) IBOutlet UITextField *blog;
@property (strong, nonatomic) IBOutlet UITextField *aboutHeader;
@property (strong, nonatomic) IBOutlet UITextView *about;
@property IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aboutHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottom;

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
    self.password.text = self.dataModel.password;
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self.about.layoutManager
     ensureLayoutForTextContainer:self.about.textContainer];

    CGRect textContainerRect = [self.about.layoutManager
     usedRectForTextContainer:self.about.textContainer];


    self.aboutHeight.constant = (textContainerRect.size.height+ self.about.textContainerInset.top+ self.about.textContainerInset.bottom);

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 500 + self.about.frame.size.height)];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{

}
-(void)textViewDidEndEditing:(UITextView *)textView{


}
- (IBAction)saveChangesTapped:(id)sender {
    self.dataModel.address= self.address.text;
    self.dataModel.city = self.city.text;
    self.dataModel.tel = self.tel.text;
    self.dataModel.email = self.email.text;
    self.dataModel.website = self.website.text;
    self.dataModel.blog = self.blog.text;
    self.dataModel.password = self.password.text;

    self.dataModel.headerAbout = self.aboutHeader.text;
    self.dataModel.about = self.about.text;

    [self.dataModel saveInfo];
}
-(IBAction)handleToAdminGalleries:(id)sender{
   // [self performSegueWithIdentifier:@"toGalleryAdmin" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toGalleryAdmin"]) {

    AdminGalleryViewController *avc = [segue destinationViewController];
    avc.dataModel = self.dataModel;
    }
    else if ([[segue identifier] isEqualToString:@"toFeatured"]){
        FeaturedAdminViewController *fvc = [segue destinationViewController];
        fvc.dataModel = self.dataModel;

    }
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
- (IBAction)tapHandler:(id)sender {
    [self resignFirstResponder];
    [self.view endEditing:YES];
}
@end
