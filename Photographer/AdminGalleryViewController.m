//
//  AdminGalleryViewController.m
//  Photographer
//
//  Created by Matt on 3/27/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "AdminGalleryViewController.h"
#import "GalleryCell.h"
#import "Photograph.h"
#import "ImagePicker.h"

@interface AdminGalleryViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, DataModelDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *addPhotoView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerController;
@property (strong, nonatomic) IBOutlet UISwitch *featuredSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property NSMutableArray *selectedPhotos;
@property NSString *galleryNameFromPicker;
@property IBOutlet UIButton *deleteButton;
@end

@implementation AdminGalleryViewController

- (void)viewDidLoad {
    self.dataModel.delegate = self;
    self.dataModel.photos = [NSMutableArray new];
    self.deleteButton.enabled = NO;
    self.addPhotoView.hidden = YES;
    self.pickerController.dataSource = self;
    self.pickerController.delegate = self;
    self.collectionView.allowsSelection=YES;
    self.collectionView.allowsMultipleSelection = YES;
    self.selectedPhotos = [NSMutableArray new];
    self.galleryNameFromPicker = self.dataModel.galleries.firstObject;
    if (self.dataModel.totalNumberOfPhotos == 0) {
        [self.dataModel getTotalNumberOfPhotos];
    }

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (self.dataModel.photos.count==0) {
        [self.dataModel getNumberOfPhotosFromGallery:self.dataModel.galleries.firstObject];
    }
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];

}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView  = nil;

}

-(void)retriveNumberOfPhotos:(int)number{
    
}

-(void)photoDownloaded{

    [self.collectionView reloadData];

}

#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModel.galleries.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.dataModel.galleries objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:14];
    cell.backgroundView = nil;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.deleteButton.enabled = YES;
    self.addPhotoView.hidden = YES;
    self.collectionView.hidden = NO;

    [self.dataModel.photos removeAllObjects];
    [self.collectionView reloadData];
    [self.dataModel getNumberOfPhotosFromGallery:[self.dataModel.galleries objectAtIndex:indexPath.row]];
    self.dataModel.galleryName = [self.dataModel.galleries objectAtIndex:indexPath.row];
    self.dataModel.currentGalleryId = [self.dataModel.gallieriesIDs objectAtIndex:indexPath.row];
}

#pragma mark CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataModel.photos.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GalleryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    Photograph *photograph = [Photograph new];
    photograph = [self.dataModel.photos objectAtIndex:indexPath.row];
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
    [self.selectedPhotos addObject:[self.dataModel.photos objectAtIndex:indexPath.row]];
    NSLog(@"%lu",(unsigned long)self.selectedPhotos.count);

}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell=[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [self.selectedPhotos removeObjectIdenticalTo:[self.dataModel.photos objectAtIndex:indexPath.row]];
    NSLog(@"%lu",(unsigned long)self.selectedPhotos.count);

}
#pragma mark actions

- (IBAction)addGalleryHandler:(UIButton *)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"New Gallery" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView textFieldAtIndex:0];
    alertView.tag=1;
    [alertView show];

}
- (IBAction)deleteGalleryHandler:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are You Sure Delete Gallery?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    alertView.tag= 2;
    [alertView show];

    }
- (IBAction)addPhotoHandler:(id)sender {
    if (self.dataModel.totalNumberOfPhotos <=100) {

    self.collectionView.hidden = YES;
    ImagePicker *imagePickerController = [[ImagePicker alloc]init];
    imagePickerController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerController animated:YES completion:^{

    }];
    }
    else {
        [self alertViewWithTitle:@"Error" message:@"You reached limit of 100"];
    }
}
- (IBAction)savePhotograph:(id)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.iconImageView.alpha = 0.4;
    if ([self checkUploadImageSize]) {
        [self.dataModel addPhoto:self.iconImageView.image toGallery:self.galleryNameFromPicker featured:self.featuredSwitch.on];
        self.dataModel.totalNumberOfPhotos ++;
        NSLog(@"You uploaded %d photos", self.dataModel.totalNumberOfPhotos);

    }
    else {
        [self alertViewWithTitle:@"Error" message:@"Max photograph size is 10MB"];
        [self.activityIndicator stopAnimating];
        self.iconImageView.alpha = 1.0;
    }
}
-(BOOL)checkUploadImageSize{

    NSData *dataFromImage = [[NSData alloc] initWithData:UIImageJPEGRepresentation(self.iconImageView.image, 1.0)];
    if (dataFromImage.length/1024>10000) {
        NSLog(@"%lu",(unsigned long)dataFromImage.length/1024);

        return NO;
    }
    else {
    return YES;
    }
}
- (IBAction)deleteSelectedHandler:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Are You Sure Delete %lu Photos?",(unsigned long)self.selectedPhotos.count] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    alertView.tag= 3;
    [alertView show];

}
- (IBAction)featureSelectedHandler:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Add %lu To Featured?",(unsigned long)self.selectedPhotos.count] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    alertView.tag= 4;
    [alertView show];

}
-(void)cleanAfterSelection{
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.backgroundColor = [UIColor clearColor];
    }
}
-(void)photoUploaded{
    self.iconImageView.alpha = 1.0;
    self.activityIndicator.hidden = YES;
}

#pragma mark AlertViewDelegate methods
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (([[alertView textFieldAtIndex:0] text].length>0)&& (alertView.tag ==1)) {

    [self.dataModel addGalleryWithName:[alertView textFieldAtIndex:0].text];
    [self.dataModel.galleries addObject:[alertView textFieldAtIndex:0].text];
    [self.tableView reloadData];
    }
    else if ((alertView.tag == 2) && (buttonIndex ==1)){

        [self.dataModel deleteGallery];
        [self.dataModel.galleries removeObjectIdenticalTo:self.dataModel.galleryName];
        [self.dataModel.gallieriesIDs removeObjectIdenticalTo:self.dataModel.currentGalleryId];
        [self.tableView reloadData];
        self.deleteButton.enabled = NO;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    }
    else if ((alertView.tag == 3)&& (buttonIndex==1)){

        for (Photograph *photo in self.selectedPhotos) {

            [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:photo.number inSection:0] animated:YES];
            [photo deletePhotograph];
            [self.collectionView reloadData];

        }
        [self.dataModel.photos removeObjectsInArray:[self.selectedPhotos copy]];
        [self cleanAfterSelection];
        [self.selectedPhotos removeAllObjects];
    }
    else if ((alertView.tag == 4)&& (buttonIndex==1)){

        for (Photograph *photo in self.selectedPhotos) {

            [photo featurePhotograph];
            [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:photo.number inSection:0] animated:YES];

            [self.dataModel.featured addObject:photo];
        }
        [self cleanAfterSelection];
        [self.selectedPhotos removeAllObjects];
    }
}
#pragma mark Alerts
-(void)alertViewWithTitle:(NSString*)title message:(NSString*)message{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    [alertView show];
    self.deleteButton.enabled = NO;

}
#pragma mark ImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.addPhotoView.hidden = NO;
    self.iconImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.pickerController reloadAllComponents];
    }];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.addPhotoView.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:^{
        self.collectionView.hidden = NO;
    }
];
}
#pragma mark pickerView Delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.galleryNameFromPicker = [self.dataModel.galleries objectAtIndex:row];

}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

        return [self.dataModel.galleries objectAtIndex:row];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

        return self.dataModel.galleries.count;

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
