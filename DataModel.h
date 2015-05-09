//
//  DataModel.h
//  Photographer
//
//  Created by Matt on 3/16/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 
@protocol DataModelDelegate
@optional
-(void)featuredDownloaded;
-(void)retriveNumberOfFeatured:(int)number andGalleries:(NSMutableArray*)galleries;
-(void)retriveNumberOfPhotos:(int)number;
-(void)retriveAbout:(NSString*)about;
-(void)connectionProblem;
-(void)photoUploaded;
-(void)photoDownloaded;
@end

@interface DataModel : NSObject
@property NSMutableArray *menuItems;
@property NSMutableArray *galleries;
@property NSMutableArray *gallieriesIDs;
@property NSMutableArray *photos;
@property NSString *photographerName;
@property NSMutableArray *featured;
@property NSString *about;
@property NSString *headerAbout;
@property UIImage *aboutImage;
@property NSString *blog;
@property NSString *password;
@property NSString *address;
@property NSString *city;
@property NSString *tel;
@property NSString *email;
@property NSString *website;
@property NSString *objectId;
@property NSString *currentGalleryId;
@property int totalNumberOfPhotos;


@property NSString *galleryName;
@property id<DataModelDelegate>delegate;

-(instancetype)init;
-(void)getMenuItems;
-(void)getFeatured;
-(void)getNumberOfPhotosFromGallery:(NSString*)gallery;
-(void)saveInfo;
-(void)addGalleryWithName:(NSString*)name;
-(void)deleteGallery;
-(void)addPhoto:(UIImage*)image toGallery:(NSString*)galleryName featured:(BOOL)featured;
-(void)getTotalNumberOfPhotos;

@end
