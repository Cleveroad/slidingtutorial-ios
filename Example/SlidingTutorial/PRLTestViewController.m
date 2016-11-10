//
//  PRLTestViewController.m
//  SlidingTutorial
//
//  Created by Danil on 11/1/16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

#import "PRLTestViewController.h"
#import "PRLview.h"

@interface PRLTestViewController () <PRLViewProtocol, UIScrollViewDelegate>

@property (nonatomic, strong) PRLView *viewParallax;

@end

@implementation PRLTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self deployTutorialParallaxView];
}
- (IBAction)actionBackButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionTryAgain:(id)sender {
    [self deployTutorialParallaxView];
}

#pragma mark - PRLViewProtocol

- (void)skipTutorial {
    [self.viewParallax removeFromSuperview];
}

#pragma mark - Private

- (void)deployTutorialParallaxView {
    PRLView *viewParallax = [[PRLView alloc] initWithViewsFromXibsNamed:@[@"TestView", @"TestView1", @"TestView2",@"TestView3"]
                                                         circularScroll:NO];
    viewParallax.delegate = self;
    self.viewParallax = viewParallax;
    [self.view addSubview:viewParallax];
    [viewParallax prepareForShow];
}

@end
