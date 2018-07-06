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

@class GKPictureInPictureView;


@protocol GKPictureInPictureViewDelegate <NSObject>

@optional

/**
 The method will be called when the position is changed. This can occur by setting the position property explicitly or by the user dragging the view to a new position.
 
 @property pictureInPictureView The view which has changed position
 @property position The new position value
 */
- (void)pictureInPictureView:(GKPictureInPictureView *)pictureInPictureView changedPosition:(GKPictureInPictureViewPosition)position;

/**
 The method will be called when the size class is changed. This can occur by setting the position property explicitly or by the user dragging the view to a new position.
 
 @property pictureInPictureView The view which has changed position
 @property position The new position value
 */
- (void)pictureInPictureView:(GKPictureInPictureView *)pictureInPictureView changedSizeClass:(GKPictureInPictureViewSize)sizeClass;

@end


@interface GKPictureInPictureView : UIView

//! Small size of the view. The user can toggle size with a pinch gesture. (default: 200x124)
@property (nonatomic) CGSize smallSize;

//! Large size of the view. The user can toggle size with a pinch gesutre. (default: 300x187)
@property (nonatomic) CGSize largeSize;

//! The current position of the view. (default: GKPictureInPictureViewPositionTopLeft)
@property (nonatomic) GKPictureInPictureViewPosition position;

//! The current size class of the view. (default: GKPictureInPictureViewSizeSmall)
@property (nonatomic) GKPictureInPictureViewSize sizeClass;

//! Prevents the view to take the top left position (default: YES)
@property (nonatomic) BOOL topLeftPositionEnabled;

//! Prevents the view to take the top right position (default: YES)
@property (nonatomic) BOOL topRightPositionEnabled;

//! Prevents the view to take the bottom left position (default: YES)
@property (nonatomic) BOOL bottomLeftPositionEnabled;

//! Prevents the view to take the bottom right position (default: YES)
@property (nonatomic) BOOL bottomRightPositionEnabled;

//! Prevents user to resize the view by pinching (default: YES)
@property (nonatomic) BOOL resizeEnabled;

//! GKPictureInPictureDelegate object which will be notified about important events
@property (nonatomic, weak) id<GKPictureInPictureViewDelegate> delegate;


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
