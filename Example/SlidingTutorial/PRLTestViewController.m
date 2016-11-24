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
@property (nonatomic, assign) BOOL infinity;

@end

@implementation PRLTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)actionBackButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionTryAgain:(id)sender {
    [self deployTutorialParallaxViewWithInfinityScroll:self.infinity];
}

#pragma mark - PRLViewProtocol

- (void)skipTutorial {
    [self.viewParallax removeFromSuperview];
}

#pragma mark - Private

- (void)deployTutorialParallaxViewWithInfinityScroll:(BOOL)infinity {
    self.infinity = infinity;
    PRLView *viewParallax = [[PRLView alloc] initWithViewsFromXibsNamed:@[@"TestView", @"TestView1", @"TestView2"]
                                                         infiniteScroll:infinity
                                                               delegate:self];
    self.viewParallax = viewParallax;
    [self.view addSubview:viewParallax];
    [viewParallax prepareForShow];
}
- (IBAction)actionShowSimpleTutorial:(id)sender {
    [self deployTutorialParallaxViewWithInfinityScroll:NO];
}

- (IBAction)actionShowInfinityTutorial:(id)sender {
    [self deployTutorialParallaxViewWithInfinityScroll:YES];
}

@end
