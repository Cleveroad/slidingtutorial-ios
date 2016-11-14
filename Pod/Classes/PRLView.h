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
 
 @param xibNames - xib names from your project resources.
 @param infinite - set YES if you want endless scroll.
 @param delegate - object's delegate.
 */

- (instancetype)initWithViewsFromXibsNamed:(NSArray <NSString *> *)xibNames
                            infiniteScroll:(BOOL)infinite
                                  delegate:(id<PRLViewProtocol>)delegate NS_DESIGNATED_INITIALIZER;

/**
  Call this method after you finished preparing Sliding Tutorial view.
 */
- (void)prepareForShow;


@end
