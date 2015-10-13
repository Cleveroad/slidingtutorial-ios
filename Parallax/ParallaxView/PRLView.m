//
//  PRLView.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/9/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLView.h"
#import "PRLElementView.h"

@interface PRLView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSMutableArray *arrayOfBackgroundColors;
@property (nonatomic, strong) NSMutableArray *arrayOfPages;

@property (nonatomic,assign) CGFloat lastScreenWidth;

@end

@implementation PRLView

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame
                    pageCount:(NSInteger)pageCount;
{
    if (pageCount <= 0) {
        NSLog(@"Wrong page count %li. It should be at least 1", (long)pageCount);
        return nil;
    }
    
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.width * pageCount)])) {
        self.arrayOfElements = [NSMutableArray new];
        self.arrayOfPages = [NSMutableArray new];
        self.arrayOfBackgroundColors = [NSMutableArray new];
        [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
        self.lastScreenWidth = 0;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * pageCount, SCREEN_HEIGHT)];
        [self addSubview:self.scrollView];
        
        for (int i = 0; i < pageCount; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.arrayOfPages addObject:view];
            [self.scrollView addSubview:view];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return  self;
}

- (void)addElementWithName:(NSString *)elementName
                   offsetX:(CGFloat)offsetX
                   offsetY:(CGFloat)offsetY
       slippingCoefficient:(CGFloat)slippingCoefficient
                   pageNum:(NSInteger)pageNum;
{
    if (pageNum >= self.arrayOfPages.count || pageNum < 0) {
        NSLog(@"Wrong page number %li Range of pages should be from 0 to %u",(long)pageNum, self.arrayOfPages.count -1);
        return;
    }
    
    PRLElementView *viewSlip = [[PRLElementView alloc] initWithImageName:elementName
                                                                     offsetX:offsetX
                                                                     offsetY:offsetY
                                                                  pageNumber:pageNum
                                                         slippingCoefficient:slippingCoefficient];
    if (viewSlip) {
        [self.arrayOfPages[pageNum] addSubview:viewSlip];
        [self.arrayOfElements addObject:viewSlip];
    }
}

- (void)addBackkgroundColor:(UIColor *)color;
{
    [self.arrayOfBackgroundColors insertObject:color atIndex:self.arrayOfBackgroundColors.count -1];
}

- (void)prepareForShow;
{
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
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGFloat contentOffset = self.scrollView.contentOffset.x;
    for (PRLElementView *view in self.arrayOfElements) {
        CGFloat offset = (self.lastContentOffset - contentOffset) * view.slippingCoefficient;
        [view setFrame:CGRectMake(view.frame.origin.x + offset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    }
    
    self.lastContentOffset = contentOffset;
    NSInteger pageNum =  floorf(scrollView.contentOffset.x / SCREEN_WIDTH);
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

#pragma mark - Private


- (UIColor *)colorWithFirstColor:(UIColor *)firstColor
                     secondColor:(UIColor *)secondColor
                          offset:(CGFloat)offset;
{
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

- (void)deviceOrientationChanged:(NSNotification *)notification {
    if (self.lastScreenWidth == 0) { //first launch setup
        self.lastScreenWidth = SCREEN_WIDTH;
    }
    
    NSInteger currentPageNum = self.scrollView.contentOffset.x / self.lastScreenWidth;
    [self setBackgroundColor:self.scrollView.backgroundColor];
    [self.scrollView setContentOffset:CGPointMake(0, 0)]; //fix problem with inapropriate elements transtion
    [self.scrollView setFrame:[UIScreen mainScreen].bounds];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * self.arrayOfPages.count, SCREEN_HEIGHT)];
    
    for (int i = 0; i < self.arrayOfPages.count; i++) {
        UIView *view = self.arrayOfPages[i];
        [view setFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    //-- removing element views and put in a new coords
    for (int i = 0; i < self.arrayOfElements.count; i++) {
        PRLElementView *view = self.arrayOfElements[i];
        [view removeFromSuperview];
        
        PRLElementView *viewSlip = [[PRLElementView alloc] initWithImageName:view.imageName
                                                                     offsetX:view.offsetX
                                                                     offsetY:view.offsetY
                                                                  pageNumber:view.pageNumber
                                                         slippingCoefficient:view.slippingCoefficient];
        
        if (viewSlip) {
            [self.arrayOfPages[viewSlip.pageNumber] addSubview:viewSlip];
            [self.arrayOfElements replaceObjectAtIndex:i withObject:viewSlip];
        }
    }
    
    //--- scrolling to current page selected
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * currentPageNum, 0)];
    self.lastScreenWidth = SCREEN_WIDTH;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

@end
