//
//  PRLView.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/9/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLView.h"
#import "PRLElementView.h"
#import <QuartzCore/QuartzCore.h>

static NSUInteger const kExtraPages = 2;

@interface PRLView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *skipView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSMutableArray *arrayOfBackgroundColors;
@property (nonatomic, strong) NSMutableArray<UIView *> *arrayOfPages;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGFloat lastScreenWidth;
@property (nonatomic, assign) CGFloat scaleCoefficient;
@property (nonatomic, assign) BOOL circular;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation PRLView

#pragma mark - Public

- (instancetype)initWithViewsFromXibsNamed:(NSArray <NSString *> *)xibNames circularScroll:(BOOL)circular {
    if (!xibNames.count) {
        NSLog(@"Wrong you need at least 1 vew");
        return nil;
    }
    self.circular = circular;
    if ((self = [super initWithFrame:[UIScreen mainScreen].bounds])) {
        self.arrayOfElements = [NSMutableArray new];
        self.arrayOfPages = [NSMutableArray new];
        self.arrayOfBackgroundColors = [NSMutableArray new];
        [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
        self.lastScreenWidth = 0;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        if (circular) {
            NSArray *xibNamesWithExtra = [self createArrayForCircularScrollWithXibNames:xibNames];
            [self configureScrollViewWithArray:xibNamesWithExtra];
        } else {
            [self configureScrollViewWithArray:xibNames];
        }
        [self addSubview:self.scrollView];
        
        //--- configure bottom skip view
        UIView *skipView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kHeightSkipView, SCREEN_WIDTH, kHeightSkipView)];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 2, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
        [skipView addSubview:lineView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 70, 40)];
        [button setTitle:@"Skip" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(skipPressed:) forControlEvents:UIControlEventTouchUpInside];
        [skipView addSubview:button];
        [self addSubview:skipView];
        
        UIPageControl *pageControl = [UIPageControl new];
        pageControl.numberOfPages = xibNames.count;
        pageControl.center = CGPointMake(SCREEN_WIDTH / 2, kHeightSkipView /2);
        [skipView addSubview:pageControl];
        self.pageControl = pageControl;
        
        self.skipView = skipView;
        //---
    }
    return  self;
}

- (void)configureScrollViewWithArray:(NSArray *)array {
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * array.count - 1, SCREEN_HEIGHT)];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addViewFromXib:obj toPageNum:idx];
    }];
}

- (void)addViewFromXib:(NSString *)xibName toPageNum:(NSInteger)pageNum {
    PRLElementView *viewSlip = [[NSBundle mainBundle] loadNibNamed:xibName
                                                             owner:nil
                                                           options:nil].lastObject;
    if (viewSlip) {
        viewSlip.frame = CGRectMake(SCREEN_WIDTH * pageNum, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kHeightSkipView);
        viewSlip.clipsToBounds = YES;
        [self.arrayOfElements addObjectsFromArray:viewSlip.subviews];
    }
    [self addBackgroundColor:viewSlip.backgroundColor];
    viewSlip.backgroundColor  = [UIColor clearColor];
    [self.arrayOfPages addObject:viewSlip];
    [self.scrollView addSubview:viewSlip];
}

- (NSArray *)createArrayForCircularScrollWithXibNames:(NSArray *)xibNames {
    NSMutableArray *xibNamesWithExtra = xibNames.mutableCopy;
    [xibNamesWithExtra insertObject:xibNames.lastObject atIndex:0];
    [xibNamesWithExtra insertObject:xibNames.firstObject atIndex:xibNamesWithExtra.count];
    return xibNamesWithExtra.copy;
}

- (void)prepareForShow {
    if (self.arrayOfBackgroundColors.count -1 < self.arrayOfPages.count) {
        NSLog(@"Wrong count of background colors. Should be %lu instead of %u", (unsigned long)self.arrayOfPages.count, self.arrayOfBackgroundColors.count -1);
        NSLog(@"The missing colors will be replaced by white");
        while (self.arrayOfBackgroundColors.count < self.arrayOfPages.count) {
            [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
        }
    }
    UIColor *mixedColor = [self colorWithFirstColor:self.arrayOfBackgroundColors[0]
                                        secondColor:self.arrayOfBackgroundColors[1]
                                             offset:0];
    [self.scrollView setBackgroundColor:mixedColor];
    if (self.circular) {
        CGPoint currentOff = CGPointMake(SCREEN_WIDTH, self.scrollView.contentOffset.y);
        self.lastContentOffset = currentOff.x;
        [self.scrollView setContentOffset:currentOff animated: NO];
    }

    [self addConstraintsToViewsArray:self.scrollView.subviews];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffset = scrollView.contentOffset.x;
    for (PRLElementView *view in self.arrayOfElements) {
        CGFloat offset = (self.lastContentOffset - contentOffset) * view.slippingCoefficient;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0.0);
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformTranslate(transform, offset, 0);
        }];
    }
    NSInteger pageNum =  floorf(scrollView.contentOffset.x / SCREEN_WIDTH);
    self.lastContentOffset = contentOffset;
    if (pageNum < 0) {
        pageNum = 0;
    }
    if (pageNum > self.arrayOfBackgroundColors.count -2) {
        pageNum = self.arrayOfBackgroundColors.count -2;
    }
    
    UIColor *mixedColor = [self colorWithFirstColor:self.arrayOfBackgroundColors[pageNum]
                                        secondColor:self.arrayOfBackgroundColors[pageNum +1]
                                             offset:scrollView.contentOffset.x];
    [scrollView setBackgroundColor:mixedColor];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.circular) {
        if (scrollView.contentOffset.x == self.arrayOfPages.lastObject.frame.origin.x - 1) {
            CGPoint currentOff = CGPointMake(SCREEN_WIDTH, self.scrollView.contentOffset.y);
            self.lastContentOffset = currentOff.x;
            [scrollView setContentOffset:currentOff animated:NO];
        } else if (scrollView.contentOffset.x == self.arrayOfPages.firstObject.frame.origin.x) {
            CGPoint currentOff = CGPointMake(self.arrayOfPages.lastObject.frame.origin.x - SCREEN_WIDTH, self.scrollView.contentOffset.y);
            self.lastContentOffset = currentOff.x;
            [scrollView setContentOffset:currentOff animated:NO];
        }
    }
    self.pageControl.currentPage = [self getIndexOfPresentedViewFromOffset:scrollView.contentOffset.x];
    self.pageNum = self.pageControl.currentPage;
}

#pragma mark - Private

- (void)addConstraintsToViewsArray:(NSArray *)views {
//    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
//
//    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view" : self.scrollView}];
//    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view" : self.scrollView}];
//
//    NSArray *horizontalViewToView = [NSLayoutConstraint constraintsWithVisualFormat:@"[firstView]-0-[view]-0-[secondView]" options:0 metrics:nil views:@{@"view" : self.scrollView,
//                                                                                                                                                         @"firstView" : self.scrollView,
//                                                                                                                                                         @"secondView" : self.scrollView}];
//    NSArray *horizontalViewToSuperView = [NSLayoutConstraint constraintsWithVisualFormat:@"[firstView]-0-[view]-0-|" options:0 metrics:nil views:@{@"view" : self.scrollView,
//                                                                                                                                                   @"firstView" : self.scrollView}];
//    [self addConstraints:horizontal];
//    [self addConstraints:vertical];
//    [views enumerateObjectsUsingBlock:^(UIView *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj setTranslatesAutoresizingMaskIntoConstraints:NO];
//        if (idx == 0) {
//            NSArray *horizontalSuperViewToView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-[secondView]"
//                                                                                         options:0
//                                                                                         metrics:nil
//                                                                                           views:@{@"view" : obj,                                                                                                                                                      @"secondView" : views[idx + 1]}];
//            NSArray *verticalView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view" : obj}];
//
//            [self addConstraints:horizontalSuperViewToView];
//            [self addConstraints:verticalView];
//        }
//    }];
}

- (NSInteger)getIndexOfPresentedViewFromOffset:(CGFloat)offset {
    __block NSInteger result;
    __weak typeof(self)weakSelf = self;
    [self.arrayOfPages enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.origin.x == offset) {
            if (weakSelf.circular) {
                result = idx - 1;
            } else {
                result = idx;
            }
            
        }
    }];
    return result;
}

- (void)addBackgroundColor:(UIColor *)color {
    [self.arrayOfBackgroundColors insertObject:color atIndex:self.arrayOfBackgroundColors.count -1];
}

- (UIColor *)colorWithFirstColor:(UIColor *)firstColor
                     secondColor:(UIColor *)secondColor
                          offset:(CGFloat)offset {
    CGFloat red1, green1, blue1, alpha1;
    CGFloat red2, green2, blue2, alpha2;
    [firstColor  getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [secondColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    CGFloat redDelta = red2 - red1;
    CGFloat greenDelta = green2 - green1;
    CGFloat blueDelta = blue2 - blue1;
    
    offset = fmod(offset, SCREEN_WIDTH);
    CGFloat resultRed = redDelta * (offset / SCREEN_WIDTH) + red1;
    CGFloat resultGreen = greenDelta * (offset / SCREEN_WIDTH) + green1;
    CGFloat resultBlue = blueDelta * (offset / SCREEN_WIDTH) + blue1;
    
    return [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:1];
}

- (void)skipPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(skipTutorial)]) {
        [self.delegate skipTutorial];
    }
}

@end
