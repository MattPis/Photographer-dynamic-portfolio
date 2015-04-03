//
//  ViewController.h
//  Photographer
//
//  Created by Matt on 3/10/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface RootViewController : UIViewController{

    int featuredIndex;
    int collectionViewIndex;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLeftConstraint;
@property DataModel *dataModel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *right;

@end

