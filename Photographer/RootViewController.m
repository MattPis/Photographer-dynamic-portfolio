//
//  ViewController.m
//  Photographer
//
//  Created by Matt on 3/10/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//


#import "RootViewController.h"
#import "MenuCell.h"
#import "GalleryViewController.h"
#import "AboutViewController.h"
#import "Photograph.h"
@interface RootViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *logoLabel;
@property BOOL animate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *portfolioRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aboutRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contactRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blogRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoLeft;
@property Photograph *photograph;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoLeft.constant = 0;
    self.portfolioRight.constant = 10;
    self.aboutRight.constant = 10;
    self.contactRight.constant = 10;
    self.blogRight.constant = 10;
    self.photograph = self.dataModel.featured.firstObject;
    self.backgroundImage.image = self.photograph.image;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    featuredIndex = 0;

    [self backgroundImageZoomOut];
    [self animateButtonsWhenViewDidApper];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.animate = YES;
    self.right.constant = -56;
    self.bottom.constant = -40;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.animate = NO;

}

#pragma mark annimations
-(void)initialAnimation{
    self.collectionViewLeftConstraint.constant = 0;
    [UIView animateWithDuration:.2 animations:^{[self.view layoutIfNeeded];}completion:^(BOOL finished) {
        [self changeFeaturedPhotoAfterZoomIn];
    }];

}
-(void)drawShadow{
    CALayer *layer = self.logoLabel.layer;
    layer.shadowOffset = CGSizeMake(5, 5);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 5.5f;
    layer.shadowOpacity = 0.60f;
    layer.masksToBounds = NO;


    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
}
-(void)backgroundImageZoomOut{

    if (self.animate == YES) {

    self.bottom.constant = 0;
    self.right.constant = -16;
    [UIView animateWithDuration:10 animations:^{[self.view.layer layoutIfNeeded];}completion:^(BOOL finished) {
        featuredIndex ++;
        [self changeFeaturedPhotoAfterZoomOut];
    }];
    }
}

-(void)changeFeaturedPhotoAfterZoomOut{

    if ((featuredIndex == self.dataModel.featured.count) && (self.animate == YES)) {
        featuredIndex = 0;
        [self changeFeaturedPhotoAfterZoomOut];
    }
    else if (self.animate == YES) {
        self.photograph = [self.dataModel.featured objectAtIndex:featuredIndex];

        self.backgroundImage.image = self.photograph.image;
        CATransition *transition = [CATransition animation];
        transition.duration = 3.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.backgroundImage.layer addAnimation:transition forKey:nil];
        [self backgroundImageZoomIn];
    }

}
-(void)backgroundImageZoomIn{

    if (self.animate == YES) {

    self.bottom.constant = -40;
    self.right.constant = -56;
    [UIView animateWithDuration:10 animations:^{[self.view layoutIfNeeded];}completion:^(BOOL finished) {
        featuredIndex ++;
        [self changeFeaturedPhotoAfterZoomIn];
    }];
    }
}
-(void)changeFeaturedPhotoAfterZoomIn{
    if ((featuredIndex == self.dataModel.featured.count) && (self.animate == YES)) {
        featuredIndex = 0;
        [self changeFeaturedPhotoAfterZoomIn];
    }
    else if (self.animate == YES) {
        self.photograph = [self.dataModel.featured objectAtIndex:featuredIndex];

        self.backgroundImage.image = self.photograph.image;
    CATransition *transition = [CATransition animation];
    transition.duration = 3.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.backgroundImage.layer addAnimation:transition forKey:nil];
    [self backgroundImageZoomOut];
    }
}
-(void)animateButtons:(int)portfolio about:(int)about contact:(int)contact blog:(int)blog segueTo:(NSString*)controller{

    self.portfolioRight.constant = portfolio;
    self.aboutRight.constant = about;
    self.contactRight.constant = contact;
    self.blogRight.constant = blog;

    [UIView animateWithDuration:.3 animations:^{[self.view layoutIfNeeded];}completion:^(BOOL finished) {
        [self performSegueWithIdentifier:controller sender:self];

    }];


}
-(void)animateButtonsWhenViewDidApper{
    self.logoLeft.constant = 24;
    self.portfolioRight.constant = 0;
    self.aboutRight.constant = 0;
    self.contactRight.constant = 0;
    self.blogRight.constant = 0;
    [UIView animateWithDuration:.3 animations:^{[self.view layoutIfNeeded];}completion:^(BOOL finished) {
    }];
}
#pragma mark navigation methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toGallery"]) {
        GalleryViewController *gvc = [segue destinationViewController];
        
        gvc.dataModel = self.dataModel;

    }
   else  if ([[segue identifier] isEqualToString:@"toAbout"]) {
       AboutViewController *avc = [segue destinationViewController];
       avc.dataModel = self.dataModel;


   }
   else  if ([[segue identifier] isEqualToString:@"toBlog"]) {
       AboutViewController *avc = [segue destinationViewController];
       avc.dataModel = self.dataModel;

   }
   else  if ([[segue identifier] isEqualToString:@"toContact"]) {
       AboutViewController *avc = [segue destinationViewController];
       avc.dataModel = self.dataModel;

   }


}
# pragma mark actions
- (IBAction)portfolioHandler:(UIButton *)sender {
    [self animateButtons:-10 about:100 contact:100 blog:100 segueTo:@"toGallery"];
}
- (IBAction)aboutHandler:(UIButton *)sender {
    [self animateButtons:100 about:-10 contact:100 blog:100 segueTo:@"toAbout"];

}
- (IBAction)contactHandler:(UIButton *)sender {
    [self animateButtons:100 about:100 contact:-10 blog:100 segueTo:@"toContact"];

}
- (IBAction)blogHandler:(UIButton *)sender {
    [self animateButtons:100 about:100 contact:100 blog:-10 segueTo:@"toBlog"];

}

-(IBAction)unwindToRoot:(UIStoryboardSegue *)segue {
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
