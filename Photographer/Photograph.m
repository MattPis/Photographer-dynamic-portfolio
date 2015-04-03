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

@end
