//
//  ViewController.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/2/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "ViewController.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImg1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImg2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImg3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [self.scrollView setContentSize:CGSizeMake(screenSize.width *3, screenSize.height)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //NSLog(@"Offset = %f",scrollView.contentOffset.x);
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.x) {
        scrollDirection = ScrollDirectionRight;
        self.constraintImg1.constant -= fabs(self.lastContentOffset - scrollView.contentOffset.x) * 0.75;
        self.constraintImg2.constant += fabs(self.lastContentOffset - scrollView.contentOffset.x) * 1.25;
        self.constraintImg3.constant -= fabs(self.lastContentOffset - scrollView.contentOffset.x) * 1.75;
    }
    else if (self.lastContentOffset < scrollView.contentOffset.x) {
        scrollDirection = ScrollDirectionLeft;
        self.constraintImg1.constant += fabs(self.lastContentOffset - scrollView.contentOffset.x) * 0.75;
        self.constraintImg2.constant -= fabs(self.lastContentOffset - scrollView.contentOffset.x) * 1.25;
        self.constraintImg3.constant += fabs(self.lastContentOffset - scrollView.contentOffset.x) * 1.75;
    }
    
    self.lastContentOffset = scrollView.contentOffset.x;
    CGFloat color = (int)(scrollView.contentOffset.x) % 255;
    color /= 255;
    [self.scrollView setBackgroundColor:[UIColor colorWithRed:color
                                                        green:color
                                                         blue:color
                                                        alpha:1]];
    
    [self.view layoutSubviews];
}

@end
