//
//  BlogViewController.m
//  Photographer
//
//  Created by Matt on 3/21/15.
//  Copyright (c) 2015 Matt. All rights reserved.
//

#import "BlogViewController.h"

@interface BlogViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *navLabel;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
}
-(void)drawShadow{
    CALayer *layer = self.navLabel.layer;
    layer.shadowOffset = CGSizeMake(5, 5);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 5.5f;
    layer.shadowOpacity = 0.60f;
    layer.masksToBounds = NO;


    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self drawShadow];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSURL *url = [NSURL URLWithString:self.dataModel.blog];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [self.webView loadRequest:request];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.activityIndicator.hidden = YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
