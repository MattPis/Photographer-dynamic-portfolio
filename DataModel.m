//
//  DataModel.m
//  Photographer
//
//  Created by Matt on 3/16/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "DataModel.h"
#import <Parse/Parse.h>
#import "Photograph.h"

@implementation DataModel


-(instancetype)init{
    self = [super init];
    self.photographerName = @"MikeAnders";
    self.menuItems = [[NSMutableArray alloc]initWithObjects:@"ABOUT",@"BLOG",@"CONTACT", nil];
    self.galleries = [NSMutableArray new];
    self.featured = [NSMutableArray new];
    self.gallieriesIDs =[NSMutableArray new];
    return self;
}


-(void)getMenuItems{

    PFQuery *query = [PFQuery queryWithClassName:@"Galleries"];
    [query whereKey:@"photographer" equalTo:self.photographerName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {

        for (PFObject *object in objects) {
            [self.menuItems addObject:object[@"name"]];
            [self.galleries addObject:object[@"name"]];
            [self.gallieriesIDs addObject:object.objectId];
        }
        }
        else {
            [self.delegate connectionProblem];
        }
        [self getInfo];

    }];


}
-(void)getInfo{
    PFQuery *query = [PFQuery queryWithClassName:@"Photographers"];
    [query whereKey:@"name" equalTo:self.photographerName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            self.about = objects.firstObject[@"about"];
            self.headerAbout = objects.firstObject[@"header"];
            self.blog = objects.firstObject[@"blog"];
            self.password = objects.firstObject[@"password"];
            self.address = objects.firstObject[@"address"];
            self.city = objects.firstObject[@"city"];
            self.tel = objects.firstObject[@"tel"];
            self.email = objects.firstObject[@"email"];
            self.website = objects.firstObject[@"website"];
            self.objectId = [[objects objectAtIndex:0] objectId];
            self.password = objects.firstObject[@"password"];

            [self downloadImageWithObject:objects.firstObject withPurpose:@"aboutImage"];

        }
        else {
            [self alertMessage:@"Error" message:@"Connection Error"];
        }

    }];

    [self getFeatured];

}

-(void)getFeatured{

    PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
    [query whereKey:@"photographer" equalTo:self.photographerName];
    [query whereKey:@"featured" equalTo:@YES];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.delegate retriveNumberOfFeatured:(int)objects.count andGalleries:self.menuItems];

            for (PFObject *object in objects) {

                [self downloadImageWithObject:object withPurpose:@"featured"];
            }

        }

        else {
            [self alertMessage:@"Error" message:@"Connection Error"];

        }

    }];
    

}

-(void)getNumberOfPhotosFromGallery:(NSString*)gallery{

    PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
    [query whereKey:@"photographer" equalTo:@"MikeAnders"];
    [query whereKey:@"gallery" equalTo:gallery];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.delegate retriveNumberOfPhotos:(int)objects.count];
            for  (PFObject *object in objects){
                [self downloadImageWithObject:object withPurpose:@"gallery"];

            }}
    }];
}
-(void)downloadImageWithObject:(PFObject*)object withPurpose:(NSString*)purpose {


   PFFile *userImageFile = object[@"image"];

   [userImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

       if ([purpose isEqual:@"featured"]) {

           Photograph *photograph = [Photograph new];
           photograph.image = [UIImage imageWithData:data];
           photograph.atGallery =  object[@"gallery"];
           photograph.ID = object.objectId;
           [self.featured addObject:photograph];
           [self.delegate featuredDownloaded];
       }
       else if ([purpose isEqual:@"gallery"]){
           Photograph *photograph = [Photograph new];
           photograph.image = [UIImage imageWithData:data];
           photograph.atGallery =  object[@"gallery"];
           photograph.ID = object.objectId;
           [self.photos addObject:photograph];
           [self.delegate photoDownloaded];
       }
       else if ([purpose isEqual:@"aboutImage"]){
           self.aboutImage = [UIImage imageWithData:data];
       }

   }];

}

-(void)saveInfo{
    PFQuery *querry = [PFQuery queryWithClassName:@"Photographers"];

    // Retrieve the object by id
    [querry  getObjectInBackgroundWithId:self.objectId block:^(PFObject *object, NSError *error) {

        object[@"about"]= self.about;
        object[@"header"]= self.headerAbout;
        object[@"blog"]= self.blog;
        object[@"address"]= self.address;
        object[@"city"]= self.city;
        object[@"tel"]= self.tel;
        object[@"email"]= self.email;
        object[@"website"]= self.website;
        object[@"password"]= self.password;


        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self alertMessage:@"Success" message:@"Changes Saved"];
                [self.delegate photoUploaded];
            } else {
                [self alertMessage:@"Error" message:@"Changes not saved"];
            }
        }];
    }];

}
-(void)addGalleryWithName:(NSString *)name{
    PFObject *object = [PFObject objectWithClassName:@"Galleries"];
    object[@"photographer"] = self.photographerName;
    object[@"name"] = name;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.gallieriesIDs addObject:object.objectId];
            NSLog(@"%@", object.objectId);
            [self alertMessage:@"Saved" message:@"New Gallery Created"];

        } else {
            [self alertMessage:@"Error" message:@"Connection Error"];
        }
    }];
}
-(void)deleteGallery{
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Galleries"
                                                       objectId:self.currentGalleryId];

    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self deleteAllPhotosFromGallery];
            [self alertMessage:@"Delete" message:@"Gallery Sucessfuly Deleted"];

        }
        else {
            [self alertMessage:@"Error" message:error.description];

        }
    }];

}
-(void)deleteAllPhotosFromGallery{

    for (Photograph *photo in self.photos) {
        [photo deletePhotograph];
    }

}
-(void)alertMessage:(NSString*)title message:(NSString*)message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title   message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: @"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    [alertView show];

}
-(void)addPhoto:(UIImage*)image toGallery:(NSString*)galleryName featured:(BOOL)featured{
    PFObject *object = [PFObject objectWithClassName:@"Photos"];
    object[@"gallery"] = galleryName;
    object[@"photographer"] = self.photographerName;
    object[@"featured"] = [NSNumber numberWithBool:featured];
    
    if (featured) {
        object[@"featured"] = @YES;
    }
    else{
        object[@"featured"] = @NO;

    }
    object[@"image"]= [PFFile fileWithData: UIImageJPEGRepresentation(image,1.0)];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            [self alertMessage:@"Success" message:[NSString stringWithFormat:@"You can upload %d photos more",(100-self.totalNumberOfPhotos)]];
            [self.delegate photoUploaded];

            Photograph *photo = [Photograph new];
            photo.image = image;
            photo.ID = object.objectId;
            [self.featured addObject:photo];

            } else {
            [self alertMessage:@"Error" message:@"Photograph not saved"];
        }
    }];

}
-(void)getTotalNumberOfPhotos{

    PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
    [query whereKey:@"photographer" equalTo:self.photographerName];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.totalNumberOfPhotos = (int)objects.count;
        }

        else {
            [self alertMessage:@"Error" message:@"Connection Error"];
            
        }
        
    }];


}
@end
