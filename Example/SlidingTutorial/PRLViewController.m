//
//  ViewController.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/2/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLViewController.h"
#import "PRLView.h"

@interface ViewController () <UIScrollViewDelegate, PRLViewProtocol>

@property (nonatomic, strong) PRLView *viewParallax;

- (IBAction)actionTryAgain:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self deployTutorialParallaxView];
}

#pragma mark - PRLViewProtocol

- (void)skipTutorial {
    [self.viewParallax removeFromSuperview];
}

#pragma mark - IBActions

- (IBAction)actionTryAgain:(id)sender {
    [self deployTutorialParallaxView];
}

#pragma mark - Private

- (void)deployTutorialParallaxView {
    PRLView *viewParallax = [[PRLView alloc] initWithPageCount:4 scaleCoefficient:0.8];
    viewParallax.delegate = self;
    self.viewParallax = viewParallax;
    [self.view addSubview:viewParallax];
    
    [viewParallax addBackgroundColor:[UIColor colorWithRed:231./255 green:150./255 blue:0 alpha:1]];
    [viewParallax addBackgroundColor:[UIColor colorWithRed:163./255 green:181./255 blue:0 alpha:1]];
    [viewParallax addBackgroundColor:[UIColor colorWithRed:35./255 green:75./255 blue:122.0/255 alpha:1]];
    [viewParallax addBackgroundColor:[UIColor colorWithRed:217./255 green:64./255 blue:0.0/255 alpha:1]];
    
    [viewParallax addElementWithName:@"elem00-04" offsetX:0 offsetY:0 slippingCoefficient:0 pageNum:0];
    [viewParallax addElementWithName:@"elem00-00" offsetX:0 offsetY:-125 slippingCoefficient:0.1 pageNum:0];
    [viewParallax addElementWithName:@"elem00-01" offsetX:-140 offsetY:-30 slippingCoefficient:-0.2 pageNum:0];
    [viewParallax addElementWithName:@"elem00-02" offsetX:-110 offsetY:58 slippingCoefficient:0.2 pageNum:0];
    //[viewParallax addElementWithName:@"elem00-03" offsetX:0 offsetY:0 slippingCoefficient:0.3 pageNum:0];
    //[viewParallax addElementWithName:@"elem00-05" offsetX:0 offsetY:0 slippingCoefficient:0 pageNum:0];
    [viewParallax addElementWithName:@"elem00-06" offsetX:-170 offsetY:-125 slippingCoefficient:0.15 pageNum:0];
    [viewParallax addElementWithName:@"elem00-07" offsetX:-130 offsetY:-125 slippingCoefficient:-0.2 pageNum:0];
    [viewParallax addElementWithName:@"elem00-08" offsetX:135 offsetY:-125 slippingCoefficient:0.1 pageNum:0];
    [viewParallax addElementWithName:@"elem00-09" offsetX:135 offsetY:-80 slippingCoefficient:0.2 pageNum:0];
    [viewParallax addElementWithName:@"elem00-10" offsetX:-150 offsetY:-85 slippingCoefficient:-0.15 pageNum:0];
    [viewParallax addElementWithName:@"elem00-11" offsetX:0 offsetY:170 slippingCoefficient:0.05 pageNum:0];
    
    [viewParallax addElementWithName:@"elem01-07" offsetX:0 offsetY:0 slippingCoefficient:-0.05 pageNum:1];
    [viewParallax addElementWithName:@"elem01-00" offsetX:-145 offsetY:35 slippingCoefficient:0.2 pageNum:1];
    [viewParallax addElementWithName:@"elem01-01" offsetX:110 offsetY:-130 slippingCoefficient:0.3 pageNum:1];
    [viewParallax addElementWithName:@"elem01-02" offsetX:0 offsetY:-30 slippingCoefficient:-0.15 pageNum:1];
    [viewParallax addElementWithName:@"elem01-03" offsetX:0 offsetY:50 slippingCoefficient:-0.2 pageNum:1];
    [viewParallax addElementWithName:@"elem01-04" offsetX:0 offsetY:-95 slippingCoefficient:-0.3 pageNum:1];
    [viewParallax addElementWithName:@"elem01-05" offsetX:-120 offsetY:-25 slippingCoefficient:0.2 pageNum:1];
    [viewParallax addElementWithName:@"elem01-06" offsetX:-110 offsetY:-95 slippingCoefficient:0.25 pageNum:1];
    [viewParallax addElementWithName:@"elem01-08" offsetX:0 offsetY:-160 slippingCoefficient:0.2 pageNum:1];
    [viewParallax addElementWithName:@"elem01-09" offsetX:-110 offsetY:-160 slippingCoefficient:0.25 pageNum:1];
    [viewParallax addElementWithName:@"elem01-10" offsetX:0 offsetY:170 slippingCoefficient:0.2 pageNum:1];
    
    [viewParallax addElementWithName:@"elem02-04" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:2];
    [viewParallax addElementWithName:@"elem02-05" offsetX:0 offsetY:-110 slippingCoefficient:0.15 pageNum:2];
    [viewParallax addElementWithName:@"elem02-00" offsetX:-50 offsetY:-120 slippingCoefficient:-0.1 pageNum:2];
    [viewParallax addElementWithName:@"elem02-01" offsetX:130 offsetY:-130 slippingCoefficient:0.2 pageNum:2];
    [viewParallax addElementWithName:@"elem02-02" offsetX:40 offsetY:-150 slippingCoefficient:0.1 pageNum:2];
    [viewParallax addElementWithName:@"elem02-03" offsetX:110 offsetY:50 slippingCoefficient:0.10 pageNum:2];
    //[viewParallax addElementWithName:@"elem02-06" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:2];
    [viewParallax addElementWithName:@"elem02-07" offsetX:0 offsetY:170 slippingCoefficient:-0.15 pageNum:2];
    
    [viewParallax addElementWithName:@"elem03-11" offsetX:-100 offsetY:-30 slippingCoefficient:-0.10 pageNum:3];
    [viewParallax addElementWithName:@"elem03-13" offsetX:-10 offsetY:-110 slippingCoefficient:0.10 pageNum:3];
    [viewParallax addElementWithName:@"elem03-04" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:3];
    [viewParallax addElementWithName:@"elem03-00" offsetX:35 offsetY:60 slippingCoefficient:0.15 pageNum:3];
    [viewParallax addElementWithName:@"elem03-01" offsetX:70 offsetY:0 slippingCoefficient:0.05 pageNum:3];
    [viewParallax addElementWithName:@"elem03-02" offsetX:-30 offsetY:125 slippingCoefficient:-0.15 pageNum:3];
    [viewParallax addElementWithName:@"elem03-03" offsetX:55 offsetY:105 slippingCoefficient:0.10 pageNum:3];
    [viewParallax addElementWithName:@"elem03-05" offsetX:-110 offsetY:30 slippingCoefficient:0.15 pageNum:3];
    [viewParallax addElementWithName:@"elem03-06" offsetX:100 offsetY:40 slippingCoefficient:-0.10 pageNum:3];
    [viewParallax addElementWithName:@"elem03-07" offsetX:-90 offsetY:-125 slippingCoefficient:0.10 pageNum:3];
    [viewParallax addElementWithName:@"elem03-08" offsetX:110 offsetY:-60 slippingCoefficient:0.05 pageNum:3];
    [viewParallax addElementWithName:@"elem03-09" offsetX:110 offsetY:-110 slippingCoefficient:-0.15 pageNum:3];
    //[viewParallax addElementWithName:@"elem03-10" offsetX:130 offsetY:-30 slippingCoefficient:0.0 pageNum:3];
    [viewParallax addElementWithName:@"elem03-12" offsetX:50 offsetY:-120 slippingCoefficient:0.10 pageNum:3];
    //[viewParallax addElementWithName:@"elem03-14" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:3];
    //[viewParallax addElementWithName:@"elem03-15" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:3];
    [viewParallax addElementWithName:@"elem03-16" offsetX:0 offsetY:170 slippingCoefficient:-0.10 pageNum:3];
    
    [viewParallax prepareForShow];
}

@end
