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


@interface GalleryViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate, DataModelDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property int numberOfPhotos;
@property int currentPhotoIndex;
@property UIImageView *imageView;
@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.dataModel.galleryName;
    self.progressView.progress = 0.0;
    self.dataModel.delegate = self;
    self.dataModel.photos = [NSMutableArray new];
}
-(void)viewDidAppear:(BOOL)animated{
    if (self.dataModel.photos.count ==0) {
        self.collectionView.alpha = .0;
        [self.dataModel getNumberOfPhotosFromGallery:self.dataModel.galleryName];
    }
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
#pragma mark animations
-(void)collectionViewAnimateIn{

    [UIView animateWithDuration:1.0F animations:^{
        self.collectionView.alpha = 1.0;
        self.progressView.alpha = 0.0;
    }];

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
@end
