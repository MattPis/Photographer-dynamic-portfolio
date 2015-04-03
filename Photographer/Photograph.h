//
//  Photograph.h
//  Photographer
//
//  Created by Matt on 3/31/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Photograph : NSObject
@property UIImage *image;
@property NSString *ID;
@property NSString *atGallery;
-(void)deletePhotograph;

@end
