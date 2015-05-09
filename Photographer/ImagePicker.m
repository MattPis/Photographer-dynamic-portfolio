//
//  ImagePicker.m
//  Photographer
//
//  Created by Matt on 4/11/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "ImagePicker.h"

@interface ImagePicker ()

@end

@implementation ImagePicker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIModalPresentationStyle)modalPresentationStyle{


    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return UIModalPresentationFormSheet;
    }

    return [super modalPresentationStyle];
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
