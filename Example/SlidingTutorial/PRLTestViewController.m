//
//  PRLTestViewController.m
//  SlidingTutorial
//
//  Created by Danil on 11/1/16.
//  Copyright © 2016 Vladislav. All rights reserved.
//

#import "PRLTestViewController.h"
#import "PRLview.h"
#import "PRLParalaxView.h"

@interface PRLTestViewController () <PRLViewProtocol, UIScrollViewDelegate, PRLParalaxViewProtocol>

@property (nonatomic, strong) PRLView *viewParallax;
@property (nonatomic, strong) PRLParalaxView *brandNewParalax;

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
    [self.brandNewParalax removeFromSuperview];
}

#pragma mark - Private

- (void)deployTutorialParallaxView {
    PRLView *viewParallax = [[PRLView alloc] initWithViewsFromXibsNamed:@[@"TestView", @"TestView1", @"TestView2",@"TestView3"]
                                                         circularScroll:YES];
    viewParallax.delegate = self;
    self.viewParallax = viewParallax;
    [self.view addSubview:viewParallax];
    [viewParallax prepareForShow];
//    PRLParalaxView *brandNewParalax = [[PRLParalaxView alloc]initWithViewsFromXibsNamed:@[@"TestView", @"TestView1"] circularScroll:YES];
//    brandNewParalax.delegate = self;
//    self.brandNewParalax = brandNewParalax;
//    [self.view addSubview:brandNewParalax];
//    [brandNewParalax prepareForShow];
//    , @"TestView2", @"TestView3"
}

@end
