//
//  PRLView.h
//  Parallax
//
//  Created by VLADISLAV KIRIN on 10/9/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PRLViewProtocol <NSObject>

/**
    This method calls when Skip button action pressed
*/
- (void)skipTutorial;

@end

@interface PRLView : UIView

@property (weak, nonatomic) id <PRLViewProtocol> delegate;

/**
 Calls for instantiating Slipping Tutorial view
 
 @param pageCount - a count of pages in tutorial and second parameter is a coefficient of scaling images (put 1.0 if you don't need scale and images will displaying in a full size).
 @param scaleCoefficient - is a coefficient of scaling images (put 1.0 if you don't need scale and images will displaying in a full size).
 */

- (instancetype)initWithViewsFromXibsNamed:(NSArray <NSString *> *)xibNames
                            circularScroll:(BOOL)circular;

/**
 Calls for adding images onto sliding page
 
 @param name - image name from your project resources.
 @param offsetX and offsetY - layer offset from the center of the screen. If you send offsetX:0 offsetY:0 your image layer will be placed exactly in the center of the screen. Dot (0,0) in this coords system situated in the center of the screen in all device orientations.
 @param slippingCoefficient - ratio bound to scroll offset in scroll view. For 1 pixel content offset of scroll view layer will be slipping for 1 * slippingCoefficient (so if slippingCoefficient == 0.3, it will be equal 0.3px). Sign determines the direction of slipping - left or right.
 @param pageNum - the page number on which you will add this image layer.
 */
//- (void)addElementWithName:(NSString *)elementName
//                   offsetX:(CGFloat)offsetX
//                   offsetY:(CGFloat)offsetY
//       slippingCoefficient:(CGFloat)slippingCoefficient
//                   pageNum:(NSInteger)pageNum;


//New stuff
//- (void)addViewFromXib:(NSString *)xibName toPageNum:(NSInteger)pageNum;
//

/**
 Calls for adding background colors for all your tutorial pages
 The colors follow the order they are added. All missing colors will be replaced with white color.
 */
//- (void)addBackgroundColor:(UIColor *)color;


/**
  Call this method after you finished preparing Sliding Tutorial view.
 */
- (void)prepareForShow;


@end
