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

@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property BOOL animate;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage.image = self.dataModel.featured.firstObject;
    featuredIndex = 0;
    [self setCollectionViewHeight];

}
-(void)setCollectionViewHeight{
    if ((self.dataModel.menuItems.count * 40) < self.view.frame.size.height -10) {
        self.collectionViewHeightConstraint.constant = self.dataModel.menuItems.count * 40;
    }
    else {
        self.collectionViewHeightConstraint.constant = self.view.frame.size.height - 10;
    }

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self backgroundImageZoomOut];
    //[self initialAnimation];

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

-(void)backgroundImageZoomOut{

    if (self.animate == YES) {


    self.bottom.constant = 0;
    self.right.constant = -16;
    [UIView animateWithDuration:10 animations:^{[self.view.layer layoutIfNeeded];}completion:^(BOOL finished) {
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
        self.backgroundImage.image = [self.dataModel.featured objectAtIndex:featuredIndex];

        CATransition *transition = [CATransition animation];
        transition.duration = 3.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.backgroundImage.layer addAnimation:transition forKey:nil];
        featuredIndex ++;
        [self backgroundImageZoomIn];
    }

}
-(void)backgroundImageZoomIn{

    if (self.animate == YES) {

    self.bottom.constant = -40;
    self.right.constant = -56;
    [UIView animateWithDuration:10 animations:^{[self.view layoutIfNeeded];}completion:^(BOOL finished) {
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
    self.backgroundImage.image = [self.dataModel.featured objectAtIndex:featuredIndex];

    CATransition *transition = [CATransition animation];
    transition.duration = 3.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.backgroundImage.layer addAnimation:transition forKey:nil];
    featuredIndex ++;
    [self backgroundImageZoomOut];
    }
}

#pragma mark UICollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataModel.menuItems.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.labelName.text = [self.dataModel.menuItems objectAtIndex:indexPath.row];


    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        [self performSegueWithIdentifier:@"toAbout" sender:nil];
    }
    else if (indexPath.row ==1){
        [self performSegueWithIdentifier:@"toBlog" sender:nil];
    }
    else if (indexPath.row ==2){
        [self performSegueWithIdentifier:@"toContact" sender:nil];
    }
    else{
        collectionViewIndex = (int)indexPath.row;
        [self performSegueWithIdentifier:@"toGallery" sender:nil];
    }

}
#pragma mark navigation methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toGallery"]) {
        GalleryViewController *gvc = [segue destinationViewController];
        self.dataModel.galleryName = [self.dataModel.menuItems objectAtIndex:collectionViewIndex];
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
