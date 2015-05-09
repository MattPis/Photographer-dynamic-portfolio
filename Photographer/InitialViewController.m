//
//  InitialViewController.m
//  Photographer
//
//  Created by Matt on 3/16/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "InitialViewController.h"
#import "DataModel.h"
#import "RootViewController.h"

@implementation InitialViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    featuredCount = 0;
    self.dataModel = [[DataModel alloc]init];
    self.dataModel.delegate = self;
    [self.dataModel getMenuItems];
    

}
#pragma mark delegate methods
-(void)retriveNumberOfFeatured:(int)number andGalleries:(NSMutableArray*)galleries{
    self.dataModel.menuItems = galleries;
    featuredCount = number;

}


-(void)featuredDownloaded{
       self.progressBar.progress = self.progressBar.progress + 1.0/featuredCount;

    if (self.progressBar.progress == 1.0) {
        [self performSegueWithIdentifier:@"toRoot" sender:self];
    }

}

-(void)connectionProblem{
    self.infoLabel.text = @"Connection Problem, please retry later";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toRoot"]) {
        RootViewController *rvc = [segue destinationViewController];
        rvc.dataModel = self.dataModel;
    }

    
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
