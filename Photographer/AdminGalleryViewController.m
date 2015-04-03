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

@interface AdminGalleryViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, DataModelDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *addPhotoView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerController;
@property (strong, nonatomic) IBOutlet UISwitch *featuredSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
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

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.dataModel getNumberOfPhotosFromGallery:self.dataModel.galleries.firstObject];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];

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
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.deleteButton.enabled = YES;
    self.addPhotoView.hidden = YES;
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
    Photograph *photograph = [Photograph new];
    photograph = [self.dataModel.photos objectAtIndex:indexPath.row];
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
#pragma mark actions

- (IBAction)addGalleryHandler:(UIButton *)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Provide Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView textFieldAtIndex:0];
    [alertView show];

}
- (IBAction)deleteGalleryHandler:(id)sender {
    [self.dataModel deleteGallery];
    [self.dataModel.galleries removeObjectIdenticalTo:self.dataModel.galleryName];
    [self.dataModel.gallieriesIDs removeObjectIdenticalTo:self.dataModel.currentGalleryId];
    [self.tableView reloadData];
    self.deleteButton.enabled = NO;
     [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];

}
- (IBAction)addPhotoHandler:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerController animated:YES completion:^{

    }];
}
- (IBAction)savePhotograph:(id)sender {
}

#pragma mark AlertViewDelegate methods
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([[alertView textFieldAtIndex:0] text]) {

    [self.dataModel addGalleryWithName:[alertView textFieldAtIndex:0].text];
    [self.dataModel.galleries addObject:[alertView textFieldAtIndex:0].text];
    [self.tableView reloadData];
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

    }];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.addPhotoView.hidden = YES;
}

#pragma mark pickerView Delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

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
