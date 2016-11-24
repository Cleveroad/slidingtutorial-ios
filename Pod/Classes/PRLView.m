//
//  PRLView.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/9/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+PRLParalaxView.h"
#import "UIView+PRLConstraintsBuilder.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static BOOL const debugMode = NO;

typedef NS_ENUM(NSInteger, PRLDirectionIndicator) {
    PRLDirectionIndicatorRight = 1,
    PRLDirectionIndicatorLeft = -1
    
};

static NSUInteger const kExtraPages = 2;

@interface PRLView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *skipView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *currentView;

@property (nonatomic, strong) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSMutableArray *arrayOfBackgroundColors;
@property (nonatomic, strong) NSMutableArray<UIView *> *arrayOfPages;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGFloat pageContentOffset;

@property (nonatomic, assign) BOOL infinite;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation PRLView

#pragma mark - Public

- (instancetype)initWithViewsFromXibsNamed:(NSArray <NSString *> *)xibNames
                            infiniteScroll:(BOOL)infinite
                                  delegate:(id<PRLViewProtocol>)delegate {
    if (!xibNames.count) {
        NSLog(@"Wrong you need at least 1 view");
        return nil;
    }
    _delegate = delegate;
    _infinite = infinite;
    if ((self = [super initWithFrame:[UIScreen mainScreen].bounds])) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.arrayOfElements = [NSMutableArray new];
        self.arrayOfPages = [NSMutableArray new];
        self.arrayOfBackgroundColors = [NSMutableArray new];
        [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        if (infinite) {
            NSArray *xibNamesWithExtra = [self createArrayForCircularScrollWithXibNames:xibNames];
            [self configureScrollViewWithArray:xibNamesWithExtra];
        } else {
            [self configureScrollViewWithArray:xibNames];
        }
        [self addSubview:self.scrollView];
        [self configureBottomSkipViewWithXibsCount:xibNames.count];
        
    }
    return  self;
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
    self.skipView.backgroundColor = mixedColor;
    self.scrollView.backgroundColor = mixedColor;
    if (self.infinite) {
        CGPoint currentOff = CGPointMake(SCREEN_WIDTH, self.scrollView.contentOffset.y);
        self.lastContentOffset = currentOff.x;
        [self.scrollView setContentOffset:currentOff animated: NO];
        self.currentView = self.arrayOfPages[1];
    } else {
        self.currentView = self.arrayOfPages.firstObject;
    }
    [self addConstraintsToBaseView];
    [self addConstraintsToScrollView:self.scrollView skipView:self.skipView];
    [self addConstraintsToStackView:self.stackView];
}

#pragma mark - LifeCycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger page = self.pageNum;
    CGPoint currentOffset;
    if (self.infinite) {
        currentOffset = CGPointMake((page + 1) * SCREEN_WIDTH, 0);
    } else {
        currentOffset = CGPointMake(page * SCREEN_WIDTH, 0);
    }
    self.lastContentOffset = currentOffset.x;
    [self.scrollView setContentOffset:currentOffset animated:NO];
    for (UIView *view in self.arrayOfElements) {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        view.transform = CGAffineTransformTranslate(transform, 0.0, 0.0);
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint translation = [scrollView.panGestureRecognizer velocityInView:scrollView.superview];
    NSUInteger page = self.pageNum;
    if(translation.x < 0) {
        if (debugMode) {
            NSLog(@"%d BEFORE", page);
        }
        if (!self.infinite) {
            if (page < self.arrayOfPages.count - 1) {
                page += 1;
            } else if (page == self.arrayOfPages.count - 1) {
                return;
            }
        } else {
            if (page < self.arrayOfPages.count - 1) {
                page += 2;
            }
        }
        if (debugMode) {
            NSLog(@"%d AFTER", page);
            NSLog(@"--->>");
        }
        [self prepareForShowViewAtIndex:page direction:PRLDirectionIndicatorRight];
        
    } else if (translation.x > 0){
        if (debugMode) {
            NSLog(@"%d BEFORE", page);
        }
        if (!self.infinite) {
            if (page > 0) {
                page -= 1;
            } else if (page == 0){
                return;
            }
        }
        if (debugMode) {
            NSLog(@"%d AFTER", page);
            NSLog(@"<<---");
        }
        [self prepareForShowViewAtIndex:page direction:PRLDirectionIndicatorLeft];
    }  else {
        if (debugMode) {
            NSLog(@"--------");
        }
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffset = scrollView.contentOffset.x;
    CGFloat repeatedOffset = contentOffset - self.pageContentOffset;
    CGFloat percentage = fabs(repeatedOffset / SCREEN_WIDTH);
    CGFloat invercePercentage = 1.0 - percentage;
    
    for (UIView *view in self.arrayOfElements) {
        CGFloat offset = (self.lastContentOffset - contentOffset) * view.slippingCoefficient * 0.5;
        view.transform = CGAffineTransformTranslate(view.transform, offset, 0.0);
    }
    NSInteger pageNum =  floorf(scrollView.contentOffset.x / SCREEN_WIDTH);
    if (pageNum < 0) {
        pageNum = 0;
    }
    if (pageNum > self.arrayOfBackgroundColors.count -2) {
        pageNum = self.arrayOfBackgroundColors.count -2;
    }
    UIColor *mixedColor = [self colorWithFirstColor:self.arrayOfBackgroundColors[pageNum]
                                        secondColor:self.arrayOfBackgroundColors[pageNum + 1]
                                             offset:scrollView.contentOffset.x];
    self.skipView.backgroundColor = mixedColor;
    self.scrollView.backgroundColor = mixedColor;
    self.lastContentOffset = contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.infinite) {
        if ([@(scrollView.contentOffset.x) isEqualToNumber:@(self.arrayOfPages.lastObject.frame.origin.x)]) {
            CGPoint currentOff = CGPointMake(SCREEN_WIDTH, self.scrollView.contentOffset.y);
            self.lastContentOffset = currentOff.x;
            [scrollView setContentOffset:currentOff animated:NO];
        } else if ([@(scrollView.contentOffset.x) isEqualToNumber:@(self.arrayOfPages.firstObject.frame.origin.x)]) {
            CGPoint currentOff = CGPointMake(self.arrayOfPages.lastObject.frame.origin.x - SCREEN_WIDTH, self.scrollView.contentOffset.y);
            self.lastContentOffset = currentOff.x;
            [scrollView setContentOffset:currentOff animated:NO];
        }
        for (UIView *view in self.arrayOfElements) {
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0, 0.0);
            view.transform = CGAffineTransformTranslate(transform, 0.0, 0.0);
            view.alpha = 1.0;
        }
    }
    self.pageControl.currentPage = [self getIndexOfPresentedViewFromOffset:scrollView.contentOffset.x];
    self.pageNum = self.pageControl.currentPage;
    self.pageContentOffset = SCREEN_WIDTH * self.pageNum;
    self.currentView = self.arrayOfPages[self.pageNum];
}

#pragma mark - PRLParalaxViewProtocol

- (void)skipPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(skipTutorial)]) {
        [self.delegate skipTutorial];
    }
}

#pragma mark - ConfigureView

- (void)configureBottomSkipViewWithXibsCount:(NSUInteger)xibsCount {
    UIView *skipView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kHeightSkipView, SCREEN_WIDTH, kHeightSkipView)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 2, 1)];
    skipView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [lineView setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
    [skipView addSubview:lineView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 0.0, 70.0, 40.0)];
    [button setTitle:@"Skip" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(skipPressed:) forControlEvents:UIControlEventTouchUpInside];
    [skipView addSubview:button];
    [self addSubview:skipView];
    
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.numberOfPages = xibsCount;
    pageControl.center = CGPointMake(SCREEN_WIDTH / 2, kHeightSkipView /2);
    [skipView addSubview:pageControl];
    self.pageControl = pageControl;
    
    self.skipView = skipView;
}

- (void)configureScrollViewWithArray:(NSArray *)array {
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * array.count - 1, SCREEN_HEIGHT)];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addViewFromXib:obj toPageNum:idx];
    }];
    [self addViewsToStackView];
}

- (void)addViewFromXib:(NSString *)xibName toPageNum:(NSInteger)pageNum {
    UIView *viewSlip = [[NSBundle mainBundle] loadNibNamed:xibName
                                                     owner:nil
                                                   options:nil].lastObject;
    if (viewSlip) {
        viewSlip.translatesAutoresizingMaskIntoConstraints = NO;
        viewSlip.clipsToBounds = YES;
        [self.arrayOfElements addObjectsFromArray:viewSlip.subviews];
    }
    [self addBackgroundColor:viewSlip.backgroundColor];
    viewSlip.backgroundColor  = [UIColor clearColor];
    [self.arrayOfPages addObject:viewSlip];
}

- (void)addViewsToStackView {
    UIStackView *stack = [[UIStackView alloc]initWithArrangedSubviews:self.arrayOfPages];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.spacing = 0.0;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView = stack;
    [self.scrollView addSubview:stack];
}

- (void)prepareForShowViewAtIndex:(NSInteger)index direction:(NSInteger)direction {
    for (UIView *view in self.arrayOfPages[index].subviews) {
        CGFloat xShift = (SCREEN_WIDTH * view.slippingCoefficient) * direction * 0.5;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        view.transform = CGAffineTransformTranslate(transform, xShift, 0.0);
    }
}

#pragma mark - ConfigureColors

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

#pragma mark - Helpers

- (NSArray *)createArrayForCircularScrollWithXibNames:(NSArray *)xibNames {
    NSMutableArray *xibNamesWithExtra = xibNames.mutableCopy;
    [xibNamesWithExtra insertObject:xibNames.lastObject atIndex:0];
    [xibNamesWithExtra insertObject:xibNames.firstObject atIndex:xibNamesWithExtra.count];
    return xibNamesWithExtra.copy;
}

- (NSInteger)getIndexOfPresentedViewFromOffset:(CGFloat)offset {
    __block NSInteger result;
    __weak typeof(self)weakSelf = self;
    [self.arrayOfPages enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.origin.x == offset) {
            result = weakSelf.infinite ? idx - 1 : idx;
            *stop = YES;
        }
    }];
    return result;
}

@end
