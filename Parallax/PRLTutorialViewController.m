//
//  PRLTutorialViewController.m
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/5/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "PRLTutorialViewController.h"
#import "PRLElementView.h"

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
};

@interface PRLTutorialViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) NSMutableArray *arrayOfElements;

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@end

@implementation PRLTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfElements = [NSMutableArray array];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat width = screenSize.width;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setContentSize:CGSizeMake(screenSize.width *3, screenSize.height)];
    [self.view addSubview:self.scrollView];
    
    self.view1 = [[UIView alloc] initWithFrame:rect];
    [self.view1 setBackgroundColor:[UIColor redColor]];
    [self.scrollView addSubview:self.view1];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(width, 0, rect.size.width, rect.size.height)];
    [self.view2 setBackgroundColor:[UIColor yellowColor]];
    [self.scrollView addSubview:self.view2];
    
    self.view3 = [[UIView alloc] initWithFrame:CGRectMake(width *2, 0, rect.size.width, rect.size.height)];
    [self.view3 setBackgroundColor:[UIColor greenColor]];
    [self.scrollView addSubview:self.view3];
    
    [self setupFirstScreen];
}

- (void)setupFirstScreen {
    [self.view1 setBackgroundColor:[UIColor colorWithRed:231./255 green:150./255 blue:0 alpha:1]];
    
    [self addElementOnView:self.view1 elementName:@"elem01-04" offsetX:0 offsetY:30 slippingCoefficient:0];
    [self addElementOnView:self.view1 elementName:@"elem01-01" offsetX:0 offsetY:-100 slippingCoefficient:0.1];
    [self addElementOnView:self.view1 elementName:@"elem01-02" offsetX:-140 offsetY:0 slippingCoefficient:-0.2];
    [self addElementOnView:self.view1 elementName:@"elem01-03" offsetX:-110 offsetY:100 slippingCoefficient:0.3];
    
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.x) {
        scrollDirection = ScrollDirectionRight;
        for (PRLElementView *view in self.arrayOfElements) {
            CGFloat offset = fabs(self.lastContentOffset - scrollView.contentOffset.x) * view.slippingCoefficient;
            CGRect rect = view.frame;
            [view setFrame:CGRectMake(rect.origin.x + offset, rect.origin.y, rect.size.width, rect.size.height)];
        }
    } else if (self.lastContentOffset < scrollView.contentOffset.x) {
        scrollDirection = ScrollDirectionLeft;
        for (PRLElementView *view in self.arrayOfElements) {
            CGFloat offset = fabs(self.lastContentOffset - scrollView.contentOffset.x) * view.slippingCoefficient;
            CGRect rect = view.frame;
            [view setFrame:CGRectMake(rect.origin.x - offset, rect.origin.y, rect.size.width, rect.size.height)];
        }
    }
    
    self.lastContentOffset = scrollView.contentOffset.x;
}

#pragma mark -

- (void)addElementOnView:(UIView *)viewPage
             elementName:(NSString *)elementName
                 offsetX:(CGFloat)offsetX
                 offsetY:(CGFloat)offsetY
     slippingCoefficient:(CGFloat)slippingCoefficient
{
    UIImage *image = [UIImage imageNamed:elementName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat screenWidht = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat postionX = (screenWidht - image.size.width) / 2;
    CGFloat postionY = (screenHeight - image.size.height) / 2;
    
    PRLElementView *viewSlip = [[PRLElementView alloc] initWithFrame:CGRectMake(postionX + offsetX, postionY + offsetY, image.size.width, image.size.height)];
    viewSlip.slippingCoefficient = slippingCoefficient;
    [viewSlip addSubview:imageView];
    [viewPage addSubview:viewSlip];
    [self.arrayOfElements addObject:viewSlip];
}

@end
