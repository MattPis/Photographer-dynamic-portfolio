//
//  FeaturedViewController.m
//  Photographer
//
//  Created by Matt on 4/25/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "FeaturedAdminViewController.h"
#import "AdminGalleryViewController.h"
#import "GalleryCell.h"
#import "Photograph.h"
@interface FeaturedAdminViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *selectedPhotos;
@end

@implementation FeaturedAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedPhotos = [NSMutableArray new];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.allowsSelection=YES;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataModel.featured.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Photograph *photograph = [Photograph new];
    photograph = [self.dataModel.featured objectAtIndex:indexPath.row];
    photograph.number = (int)indexPath.row;
    cell.imageView.image = photograph.image;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ((self.collectionView.frame.size.width ) / 3)- 15;

    return CGSizeMake(width, width);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell=[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    [self.selectedPhotos addObject:[self.dataModel.featured objectAtIndex:indexPath.row]];
    NSLog(@"%lu",(unsigned long)self.selectedPhotos.count);

}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell=[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [self.selectedPhotos removeObjectIdenticalTo:[self.dataModel.featured objectAtIndex:indexPath.row]];
    NSLog(@"%lu",(unsigned long)self.selectedPhotos.count);

}
#pragma mark actions
- (IBAction)removeFeaturedTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are You Sure Remove Selected From Featured?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];
    [alert show];
}
#pragma mark AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self removeFeatured];
    }
}
#pragma mark helper methods
-(void)removeFeatured{
    for (Photograph *photo in self.selectedPhotos) {
        [photo removeFeature];
        [self.dataModel.featured removeObjectIdenticalTo:photo];
    }
    [self.selectedPhotos removeAllObjects];

    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.backgroundColor = [UIColor clearColor];
    }
    [self.collectionView reloadData];
}
#pragma mark Navigation methods
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft ;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
