//
//  PRLCollectionView.m
//  Pods
//
//  Created by Danil on 11/4/16.
//
//

#import "PRLCollectionView.h"

#import "PRLElementView.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const kPRLCellReuseIdentifier = @"PRLCellReuseIdentifier";

@interface PRLCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) BOOL circular;
@property (nonatomic, strong) UIView *skipView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSMutableArray *arrayOfBackgroundColors;
@property (nonatomic, strong) NSMutableArray<UIView *> *arrayOfPages;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation PRLCollectionView

#pragma mark - Public Methods

- (instancetype)initWithViewsFromXibsNamed:(NSArray <NSString *> *)xibNames
                            circularScroll:(BOOL)circular {
    
    if ((self = [super initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:[self prepareFlowLayout]])) {
        self.dataSource = self;
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPRLCellReuseIdentifier];
        if (circular) {
            self.dataSource = [self createArrayForCircularScrollWithXibNames:xibNames];
        } else {
            self.dataSource = xibNames;
        }
        self.arrayOfElements = [NSMutableArray new];
        self.arrayOfPages = [NSMutableArray new];
        self.arrayOfBackgroundColors = [NSMutableArray new];
        [self.arrayOfBackgroundColors addObject:[UIColor whiteColor]];
    }
    return self;
}


- (void)prepareForShow {
    
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
    self.dataSource.count;
}

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:kPRLCellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self addViewFromXib:self.dataSource toCell:cell];
}

- (void)addViewFromXib:(NSString *)xibName toCell:(UICollectionViewCell *)cell {
    PRLElementView *viewSlip = [[NSBundle mainBundle] loadNibNamed:xibName
                                                             owner:nil
                                                           options:nil].lastObject;
    if (viewSlip) {
        viewSlip.frame = cell.frame;
        viewSlip.clipsToBounds = YES;
    }
    [self addBackgroundColor:viewSlip.backgroundColor];
    viewSlip.backgroundColor  = [UIColor clearColor];
    [cell.contentView addSubview:viewSlip];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat contentOffsetWhenFullyScrolledRight = self.frame.size.width * ([self.dataSource count] -1);
    if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {

        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    } else if (scrollView.contentOffset.x == 0)  {

        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.dataSource count] -2) inSection:0];
        [self scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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

@end
