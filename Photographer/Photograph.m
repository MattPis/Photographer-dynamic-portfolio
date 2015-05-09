//
//  Photograph.m
//  Photographer
//
//  Created by Matt on 3/31/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "Photograph.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@implementation Photograph
-(void)deletePhotograph{
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Photos"
                                                       objectId:self.ID];

    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo Deleted");
        }
        else {
            NSLog(@"Photo Deleted: %@", error.description);

        }
    }];

}
-(void)featurePhotograph{
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Photos"
                                                       objectId:self.ID];
    object[@"featured"] = @YES;

    [object  saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Featured Saved");
        } else {
            NSLog(@"Featured Not Saved");
        }
    }];
}
-(void)removeFeature{
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Photos"
                                                       objectId:self.ID];
    object[@"featured"] = @NO;

    [object  saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Featured Removed");
        } else {
            NSLog(@"Featured Not Removed");
        }
    }];

}
@end
