//
//  GKPictureInPictureView.h
//  GKPictureInPictureView
//
//  Created by GK on 2018.07.04..
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GKPictureInPictureViewPosition) {
    GKPictureInPictureViewPositionTopLeft = 0,
    GKPictureInPictureViewPositionTopRight,
    GKPictureInPictureViewPositionBottomLeft,
    GKPictureInPictureViewPositionBottomRight
};

typedef NS_ENUM(NSUInteger, GKPictureInPictureViewSize) {
    GKPictureInPictureViewSizeSmall = 0,
    GKPictureInPictureViewSizeLarge
};

@interface GKPictureInPictureView : UIView

//! Small size of the view. The user can toggle size with a pinch gesture.
@property (nonatomic) CGSize smallSize;

//! Large size of the view. The user can toggle size with a pinch gesutre.
@property (nonatomic) CGSize largeSize;

//! The current position of the view.
@property (nonatomic) GKPictureInPictureViewPosition position;

//! The current size class of the view.
@property (nonatomic) GKPictureInPictureViewSize sizeClass;


#pragma mark - Lifecycle

/**
 Designated initializer. The given content view will be displayed in the PiP frame.
 
 @property contentView The content view to display. Your content.
 */
- (instancetype)initWithContentView:(UIView *)contentView;

#pragma mark - Adding and removing

/**
 Show the view
 
 @property superview The view which will contain the PiP view
 @property animated Animate adding or not
 */
- (void)addToSuperView:(UIView *)superview animated:(BOOL)animated;

/**
 Hide the view
 
 @property animated Animate removing or not
 */
- (void)removeFromSuperviewAnimated:(BOOL)animated;

#pragma mark - Setting size

/**
 Set the position of the view
 
 @property animated Animate setting or not
 */
- (void)setPosition:(GKPictureInPictureViewPosition)position animated:(BOOL)animated;

/**
 Set the size class of the view
 
 @property animated Animate setting or not
 */
- (void)setSizeClass:(GKPictureInPictureViewSize)sizeClass animated:(BOOL)animated;

@end
