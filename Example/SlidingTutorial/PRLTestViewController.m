//
//  PRLTestViewController.m
//  SlidingTutorial
//
//  Created by Danil on 11/1/16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

#import "PRLTestViewController.h"
#import "PRLView.h"

@interface PRLTestViewController () <PRLViewProtocol>

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

#pragma mark - PRLViewProtocol

- (void)skipTutorial {
    [self.viewParallax removeFromSuperview];
}

#pragma mark - Private

- (void)deployTutorialParallaxView {
    PRLView *viewParallax = [[PRLView alloc] initWithPageCount:4 scaleCoefficient:0.8];
    viewParallax.delegate = self;
    self.viewParallax = viewParallax;
    [self.view addSubview:viewParallax];
    
    [viewParallax addViewFromXib:@"TestView" toPageNum:0];
    [viewParallax addViewFromXib:@"TestView1" toPageNum:1];
    [viewParallax addViewFromXib:@"TestView2" toPageNum:2];
    [viewParallax addViewFromXib:@"TestView3" toPageNum:3];

    [viewParallax prepareForShow];
}

@end
