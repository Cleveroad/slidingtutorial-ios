//
//  PRLParalaxView.m
//  Pods
//
//  Created by Danil on 11/4/16.
//
//

#import "PRLParalaxView.h"

#import "PRLElementView.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const kPRLCellReuseIdentifier = @"PRLCellReuseIdentifier";


@interface PRLParalaxView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataSourceArray;

@property (nonatomic, assign) BOOL circular;
@property (nonatomic, strong) UIView *skipView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSMutableArray *arrayOfBackgroundColors;
@property (nonatomic, strong) NSMutableArray<UIView *> *arrayOfPages;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PRLParalaxView
#pragma mark - Public Methods

- (instancetype)initWithViewsFromXibsNamed:(NSArray <NSString *> *)xibNames
                            circularScroll:(BOOL)circular {
    
    if ((self = [super initWithFrame:[UIScreen mainScreen].bounds])) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:[self prepareFlowLayout]];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPRLCellReuseIdentifier];
        if (circular) {
            self.dataSourceArray = [self createArrayForCircularScrollWithXibNames:xibNames];
        } else {
            self.dataSourceArray = xibNames;
        }
        self.arrayOfElements = [NSMutableArray new];
        self.arrayOfPages = [NSMutableArray new];
        self.arrayOfBackgroundColors = [NSMutableArray new];
        [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
        [self addSubview:self.collectionView];
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
    }
    return self;
}


- (void)prepareForShow {
    if (self.arrayOfBackgroundColors.count -1 < self.arrayOfPages.count) {
        NSLog(@"Wrong count of background colors. Should be %lu instead of %u", (unsigned long)self.arrayOfPages.count, self.arrayOfBackgroundColors.count -1);
        NSLog(@"The missing colors will be replaced by white");
        while (self.arrayOfBackgroundColors.count < self.arrayOfPages.count) {
            [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
        }
    }
    //    UIColor *mixedColor = [self colorWithFirstColor:self.arrayOfBackgroundColors[0]
    //                                        secondColor:self.arrayOfBackgroundColors[1]
    //                                             offset:0];
        [self setBackgroundColor:self.arrayOfBackgroundColors[0]];
    if (self.circular) {
        CGPoint currentOff = CGPointMake(SCREEN_WIDTH, self.collectionView.contentOffset.y);
        self.lastContentOffset = currentOff.x;
    }
}

#pragma mark - Private Methods

- (UICollectionViewFlowLayout *)prepareFlowLayout {
    UICollectionViewFlowLayout *result = [UICollectionViewFlowLayout new];
    result.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return result;
}

- (NSArray *)createArrayForCircularScrollWithXibNames:(NSArray *)xibNames {
    NSMutableArray *xibNamesWithExtra = xibNames.mutableCopy;
    [xibNamesWithExtra insertObject:xibNames.lastObject atIndex:0];
    [xibNamesWithExtra addObject:xibNames.firstObject];
    return xibNamesWithExtra.copy;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPRLCellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self addViewFromXib:self.dataSourceArray[indexPath.item] toCell:cell];

}

- (void)addViewFromXib:(NSString *)xibName toCell:(UICollectionViewCell *)cell {
    dispatch_async(dispatch_get_main_queue(), ^{
        PRLElementView *viewSlip = [[NSBundle mainBundle] loadNibNamed:xibName
                                                                 owner:nil
                                                               options:nil].lastObject;
        if (viewSlip) {
            viewSlip.frame = cell.contentView.frame;
            viewSlip.clipsToBounds = YES;
        }
        [self addBackgroundColor:viewSlip.backgroundColor];
        viewSlip.backgroundColor  = [UIColor clearColor];
        [cell.contentView addSubview:viewSlip];
    });
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.circular) {
        CGFloat contentOffsetWhenFullyScrolledRight = self.frame.size.width * ([self.dataSourceArray count] -1);
        if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
            
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        } else if (scrollView.contentOffset.x == 0)  {
            
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.dataSourceArray count] -2) inSection:0];
            [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }
}

#pragma mark - Colors Helpers

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
