//
//  NavigationController.m
//  Photographer
//
//  Created by Matt on 3/26/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(BOOL)isToolbarHidden{
    return YES;
}
-(BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {

    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
