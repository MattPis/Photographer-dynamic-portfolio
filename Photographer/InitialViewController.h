//
//  InitialViewController.h
//  Photographer
//
//  Created by Matt on 3/16/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface InitialViewController : UIViewController <DataModelDelegate>{
    int featuredCount;
}
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property DataModel *dataModel;
@end
