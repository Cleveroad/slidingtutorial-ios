//
//  PRLParalaxView.h
//  Pods
//
//  Created by Danil on 11/4/16.
//
//

#import <UIKit/UIKit.h>

@protocol PRLParalaxViewProtocol <NSObject>

/**
 This method calls when Skip button action pressed
 */
- (void)skipTutorial;

@end

@interface PRLParalaxView : UIView

@property (weak, nonatomic) id <PRLParalaxViewProtocol> delegate;


/**
 Calls for instantiating Slipping Tutorial view
 
 @param pageCount - a count of pages in tutorial and second parameter is a coefficient of scaling images (put 1.0 if you don't need scale and images will displaying in a full size).
 @param scaleCoefficient - is a coefficient of scaling images (put 1.0 if you don't need scale and images will displaying in a full size).
 */

- (instancetype)initWithViewsFromXibsNamed:(NSArray <NSString *> *)xibNames
                            circularScroll:(BOOL)circular;

/**
 Call this method after you finished preparing Sliding Tutorial view.
 */
- (void)prepareForShow;

@end
