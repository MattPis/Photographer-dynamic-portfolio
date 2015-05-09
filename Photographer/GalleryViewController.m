//
//  GalleryViewController.m
//  Photographer
//
//  Created by Matt on 3/17/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//
#import "GalleryCell.h"
#import "GalleryViewController.h"
#import "DataModel.h"
#import "PhotoViewViewController.h"
#import "Photograph.h"


@interface GalleryViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate, DataModelDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property int numberOfPhotos;
@property int currentPhotoIndex;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstant;
@property (strong, nonatomic) IBOutlet UIView *frontView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuTop;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UIImageView *imageView;
@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.dataModel.galleryName;
    self.progressView.progress = 0.0;
    self.dataModel.delegate = self;
    self.dataModel.photos = [NSMutableArray new];
    self.dataModel.galleryName = self.dataModel.galleries.firstObject;
}
-(void)viewDidAppear:(BOOL)animated{
    if (self.dataModel.photos.count ==0) {
        self.collectionView.alpha = .0;
        [self.dataModel getNumberOfPhotosFromGallery:self.dataModel.galleryName];
    }
    self.menuTop.constant = 65;

    }
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self drawShadow];

}
-(void)photoDownloaded{
    float currentProgressState = self.progressView.progress;
    self.progressView.progress = currentProgressState + 1.0/self.numberOfPhotos;
    [self.collectionView reloadData];

    if (self.numberOfPhotos == self.dataModel.photos.count)
    {
        [self collectionViewAnimateIn];
    }
}

#pragma mark delegate methods



-(void)retriveNumberOfPhotos:(int)number{
    self.numberOfPhotos = number;

}
#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return  self.dataModel.galleries.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    cell.textLabel.text = [self.dataModel.galleries objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:18];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentRight;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataModel.photos removeAllObjects];
    self.collectionView.alpha = 0.0;
    self.progressView.progress = 0.0;
    self.progressView.alpha = 1.0;
    self.progressView.hidden = NO;
    self.dataModel.galleryName = [self.dataModel.galleries objectAtIndex:indexPath.row];
    [self.dataModel getNumberOfPhotosFromGallery:[self.dataModel.galleries objectAtIndex:indexPath.row]];


}
#pragma mark collectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataModel.photos.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    GalleryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    Photograph *photograph = [Photograph new];
    photograph = [self.dataModel.photos objectAtIndex:indexPath.row];
    cell.imageView.image = photograph.image;
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ((self.view.frame.size.width ) / 4)- 15;

    return CGSizeMake(width, width);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.currentPhotoIndex = (int)indexPath.row;
    [self performSegueWithIdentifier:@"toPhotoView" sender:self];

}
#pragma mark navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqual:@"toPhotoView"]) {
        PhotoViewViewController *pvc = [segue destinationViewController];
        pvc.currentPhotoIndex = self.currentPhotoIndex;
        pvc.photos = self.dataModel.photos;
        pvc.galleryName = self.dataModel.galleryName;
    }

}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft ;
}
-(IBAction)unwindToGalleryView:(UIStoryboardSegue *)segue {
    [self.imageView removeFromSuperview];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark animations
- (IBAction)hideShowBurger:(id)sender {
    if ( self.leftConstant.constant == 0)
 {
     self.leftConstant.constant = 190;
     self.rightConstant.constant = -222;
     self.menuTop.constant = 45;
     [UIView animateWithDuration:.5 animations:^{[self.view.layer layoutIfNeeded];}completion:^(BOOL finished) {
     }];
 }

    else {
        self.leftConstant.constant = 0;
        self.rightConstant.constant = 0;
        self.menuTop.constant = 65;
        [UIView animateWithDuration:.5 animations:^{[self.view.layer layoutIfNeeded];}completion:^(BOOL finished) {
        }];
    }

}
-(void)drawShadow{
    CALayer *layer = self.frontView.layer;
    layer.shadowOffset = CGSizeMake(-3, -3);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 5.5f;
    layer.shadowOpacity = 0.60f;
    layer.masksToBounds = NO;


    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
}
-(void)collectionViewAnimateIn{

    [UIView animateWithDuration:1.0F animations:^{
        self.titleLabel.text = self.dataModel.galleryName;
        self.collectionView.alpha = 1.0;
        self.progressView.alpha = 0.0;
    }];
    [self hideShowBurger:self];

}

@end
