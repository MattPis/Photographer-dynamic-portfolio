//
//  PhotoViewViewController.m
//  Photographer
//
//  Created by Matt on 3/23/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "PhotoViewViewController.h"
#import "Photograph.h"

@interface PhotoViewViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *navLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titilelabelConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navLabelConstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backButtonConstraint;
@end

@implementation PhotoViewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    Photograph *photo = [Photograph new];
    photo = [self.photos objectAtIndex:self.currentPhotoIndex];
    self.imageView.image = photo.image;
    self.titleLabel.text = self.galleryName;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 4;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    [self hideItemsFromView];

}
-(void)viewDidLayoutSubviews{
    [self drawShadow];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
-(void)hideItemsFromView{
    self.navLabelConstraint.constant = -52;
    self.titilelabelConstraint.constant = -52;
    self.backButtonConstraint.constant = -52;

    [UIView animateWithDuration:0.3F animations:^{[self.view layoutIfNeeded];

    }];

}
-(void)drawShadow{
  CALayer *layer = self.navLabel.layer;
  layer.shadowOffset = CGSizeMake(5, 5);
  layer.shadowColor = [[UIColor blackColor] CGColor];
  layer.shadowRadius = 5.5f;
  layer.shadowOpacity = 0.60f;
  layer.masksToBounds = NO;

  layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
         
}

-(void)showItemsFromView{
    self.navLabelConstraint.constant = 0;
    self.titilelabelConstraint.constant = 0;
    self.backButtonConstraint.constant = 11;
    [UIView animateWithDuration:0.3F animations:^{[self.view layoutIfNeeded];
    }];


}

- (IBAction)handleTap:(id)sender {
    if (self.titilelabelConstraint.constant < 0) {
        [self showItemsFromView];
    }
    else {
        [self hideItemsFromView];
    }

}
- (IBAction)rightSwipeHandler:(UISwipeGestureRecognizer *)sender {
    if (self.currentPhotoIndex > 0) {

    self.currentPhotoIndex --;
    [self hideItemsFromView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    Photograph *photo = [Photograph new];
    photo = [self.photos objectAtIndex:self.currentPhotoIndex];
    self.imageView.image = photo.image;
    }
    else{
        [self showItemsFromView];
    }
}
- (IBAction)leftSwipeHandler:(UISwipeGestureRecognizer *)sender {
    if (self.currentPhotoIndex < self.photos.count-1) {
     self.currentPhotoIndex ++;
     [self hideItemsFromView];
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:.3];
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
     [UIView commitAnimations];
        Photograph *photo = [Photograph new];
        photo = [self.photos objectAtIndex:self.currentPhotoIndex];
        self.imageView.image = photo.image;
    }
    else{
        [self showItemsFromView];
    }
}



-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
