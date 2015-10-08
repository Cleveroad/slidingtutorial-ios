//
//  PRLTutorialViewController.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/5/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLTutorialViewController.h"
#import "PRLElementView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PRLTutorialViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSMutableArray *arrayOfBackgroundColors;

@end

@implementation PRLTutorialViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color1 = [UIColor colorWithRed:231./255 green:150./255 blue:0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:163./255 green:181./255 blue:0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:35./255 green:75./255 blue:122.0/255 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:217./255 green:64./255 blue:0.0/255 alpha:1];
    self.arrayOfBackgroundColors = [@[color1, color2, color3, color4, [UIColor whiteColor]] mutableCopy];
    
    self.arrayOfElements = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * (self.arrayOfBackgroundColors.count -1), SCREEN_HEIGHT)];
    [self.scrollView setBackgroundColor:self.arrayOfBackgroundColors[0]];
    [self.view addSubview:self.scrollView];
    
    [self setupFirstScreen];
    [self setupSecondScreen];
    [self setupThirdScreen];
    [self setupFourthScreen];
}

//- (void)viewWillTransitionToSize:(CGSize)size  withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
////         NSLog(@"Orientation %i",orientation);
////         int i=0;
//         [self.scrollView removeFromSuperview];
//         // do whatever
//     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
//     {
//         
//         self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//         self.scrollView.delegate = self;
//         self.scrollView.pagingEnabled = YES;
//         [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * (self.arrayOfBackgroundColors.count -1), SCREEN_HEIGHT)];
//         [self.scrollView setBackgroundColor:self.arrayOfBackgroundColors[0]];
//         [self.view addSubview:self.scrollView];
//         
//         [self setupFirstScreen];
//         [self setupSecondScreen];
//         [self setupThirdScreen];
//         [self setupFourthScreen];
//     }];
//    
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//}

- (void)setupFirstScreen {
    UIView *viewPage  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:viewPage];
    
    [self addElementOnView:viewPage elementName:@"elem00-04" offsetX:0 offsetY:0 slippingCoefficient:0 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-00" offsetX:0 offsetY:-125 slippingCoefficient:0.1 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-01" offsetX:-140 offsetY:-30 slippingCoefficient:-0.2 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-02" offsetX:-110 offsetY:58 slippingCoefficient:0.2 pageNum:0];
    //[self addElementOnView:viewPage elementName:@"elem00-03" offsetX:0 offsetY:0 slippingCoefficient:0.3 pageNum:0];
    //[self addElementOnView:viewPage elementName:@"elem00-05" offsetX:0 offsetY:0 slippingCoefficient:0 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-06" offsetX:-170 offsetY:-125 slippingCoefficient:0.15 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-07" offsetX:-130 offsetY:-125 slippingCoefficient:-0.2 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-08" offsetX:135 offsetY:-125 slippingCoefficient:0.1 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-09" offsetX:135 offsetY:-80 slippingCoefficient:0.2 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-10" offsetX:-150 offsetY:-85 slippingCoefficient:-0.15 pageNum:0];
    [self addElementOnView:viewPage elementName:@"elem00-11" offsetX:0 offsetY:170 slippingCoefficient:0.05 pageNum:0];
}

- (void)setupSecondScreen {
    UIView *viewPage = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:viewPage];
    
    [self addElementOnView:viewPage elementName:@"elem01-07" offsetX:0 offsetY:0 slippingCoefficient:-0.05 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-00" offsetX:-145 offsetY:35 slippingCoefficient:0.2 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-01" offsetX:110 offsetY:-130 slippingCoefficient:0.3 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-02" offsetX:0 offsetY:-30 slippingCoefficient:-0.15 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-03" offsetX:0 offsetY:50 slippingCoefficient:-0.2 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-04" offsetX:0 offsetY:-95 slippingCoefficient:-0.3 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-05" offsetX:-120 offsetY:-25 slippingCoefficient:0.2 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-06" offsetX:-110 offsetY:-95 slippingCoefficient:0.25 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-08" offsetX:0 offsetY:-160 slippingCoefficient:0.2 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-09" offsetX:-110 offsetY:-160 slippingCoefficient:0.25 pageNum:1];
    [self addElementOnView:viewPage elementName:@"elem01-10" offsetX:0 offsetY:170 slippingCoefficient:0.2 pageNum:1];
}

- (void)setupThirdScreen {
    UIView *viewPage = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH *2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:viewPage];
    
    [self addElementOnView:viewPage elementName:@"elem02-04" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:2];
    [self addElementOnView:viewPage elementName:@"elem02-05" offsetX:0 offsetY:-110 slippingCoefficient:0.15 pageNum:2];
    [self addElementOnView:viewPage elementName:@"elem02-00" offsetX:-50 offsetY:-120 slippingCoefficient:-0.1 pageNum:2];
    [self addElementOnView:viewPage elementName:@"elem02-01" offsetX:130 offsetY:-130 slippingCoefficient:0.2 pageNum:2];
    [self addElementOnView:viewPage elementName:@"elem02-02" offsetX:40 offsetY:-150 slippingCoefficient:0.1 pageNum:2];
    [self addElementOnView:viewPage elementName:@"elem02-03" offsetX:110 offsetY:50 slippingCoefficient:0.10 pageNum:2];
    //[self addElementOnView:viewPage elementName:@"elem02-06" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:2];
    [self addElementOnView:viewPage elementName:@"elem02-07" offsetX:0 offsetY:170 slippingCoefficient:-0.15 pageNum:2];
}

- (void)setupFourthScreen {
    UIView *viewPage = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH *3, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:viewPage];
    
    [self addElementOnView:viewPage elementName:@"elem03-11" offsetX:-100 offsetY:-30 slippingCoefficient:-0.10 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-13" offsetX:-10 offsetY:-110 slippingCoefficient:0.10 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-04" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-00" offsetX:35 offsetY:60 slippingCoefficient:0.15 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-01" offsetX:70 offsetY:0 slippingCoefficient:0.05 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-02" offsetX:-30 offsetY:125 slippingCoefficient:-0.15 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-03" offsetX:55 offsetY:105 slippingCoefficient:0.10 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-05" offsetX:-110 offsetY:30 slippingCoefficient:0.15 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-06" offsetX:100 offsetY:40 slippingCoefficient:-0.10 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-07" offsetX:-90 offsetY:-125 slippingCoefficient:0.10 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-08" offsetX:110 offsetY:-60 slippingCoefficient:0.05 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-09" offsetX:110 offsetY:-110 slippingCoefficient:-0.15 pageNum:3];
    //[self addElementOnView:viewPage elementName:@"elem03-10" offsetX:130 offsetY:-30 slippingCoefficient:0.0 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-12" offsetX:50 offsetY:-120 slippingCoefficient:0.10 pageNum:3];
    //[self addElementOnView:viewPage elementName:@"elem03-14" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:3];
    //[self addElementOnView:viewPage elementName:@"elem03-15" offsetX:0 offsetY:0 slippingCoefficient:0.0 pageNum:3];
    [self addElementOnView:viewPage elementName:@"elem03-16" offsetX:0 offsetY:170 slippingCoefficient:-0.10 pageNum:3];
    
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
    if (pageNum > self.arrayOfBackgroundColors.count -1) {
        pageNum = self.arrayOfBackgroundColors.count -1;
    }
    
    UIColor *mixedColor = [self colorWithFirstColor:self.arrayOfBackgroundColors[pageNum]
                                        secondColor:self.arrayOfBackgroundColors[pageNum +1]
                                             offset:(CGFloat)scrollView.contentOffset.x];
    [scrollView setBackgroundColor:mixedColor];
}

#pragma mark -

- (void)addElementOnView:(UIView *)viewPage
             elementName:(NSString *)elementName
                 offsetX:(CGFloat)offsetX
                 offsetY:(CGFloat)offsetY
     slippingCoefficient:(CGFloat)slippingCoefficient
                 pageNum:(NSUInteger)pageNum
{
    UIImage *image = [UIImage imageNamed:elementName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    CGFloat postionX = (SCREEN_WIDTH - image.size.width) / 2;
    CGFloat postionY = (SCREEN_HEIGHT - image.size.height) / 2;
    
    PRLElementView *viewSlip = [[PRLElementView alloc] initWithFrame:CGRectMake(postionX + offsetX + SCREEN_WIDTH * slippingCoefficient * pageNum,
                                                                                postionY + offsetY,
                                                                                image.size.width,
                                                                                image.size.height)];
    viewSlip.slippingCoefficient = slippingCoefficient;
    //viewSlip.pageNum = pageNum;
    [viewSlip addSubview:imageView];
    [viewPage addSubview:viewSlip];
    [self.arrayOfElements addObject:viewSlip];
}

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

@end
