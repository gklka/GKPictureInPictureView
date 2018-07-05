//
//  GKPictureInPictureView.m
//  GKPictureInPictureView
//
//  Created by GK on 2018.07.04..
//

#import "GKPictureInPictureView.h"

#define Padding 10.f
#define ShowHideAnimationDuration 0.2f
#define ZoomAnimationDuration 0.2f
#define MoveAnimationDuration 0.3f

@interface GKPictureInPictureView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic) CGPoint panInitialCenter;

@property (nonatomic) CGFloat decelerationRate;

@end


@implementation GKPictureInPictureView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Add shadow
        self.layer.cornerRadius = 4.f;
        self.layer.shadowRadius = 4.f;
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2.f);
        
        // Background color
        self.backgroundColor = [UIColor whiteColor];
        
        // Defaul values
        self.smallSize = CGSizeMake(200.f, 124.f);
        self.largeSize = CGSizeMake(300.f, 187.f);
        self.position = GKPictureInPictureViewPositionTopLeft;
        self.sizeClass = GKPictureInPictureViewSizeSmall;
        self.panInitialCenter = CGPointZero;
        self.decelerationRate = [UIScrollView new].decelerationRate;
        
        // Handle gestures
        [self addGestureRecognizer:self.panGestureRecognizer];
        [self addGestureRecognizer:self.pinchGestureRecognizer];
    }
    
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [self init];
    
    if (self) {
        // Add user's view to our content
        self.contentView = contentView;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.layer.cornerRadius = 4.f;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
    }
    
    return self;
}

#pragma mark - Accessors

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    
    return _panGestureRecognizer;
}

- (UIPinchGestureRecognizer *)pinchGestureRecognizer {
    if (!_pinchGestureRecognizer) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    }
    
    return _pinchGestureRecognizer;
}

- (void)pan:(UIPanGestureRecognizer *)gesutreRecognizer {
    [self.superview bringSubviewToFront:self];

    if (!gesutreRecognizer.view) return;
    UIView *piece = gesutreRecognizer.view;
    CGPoint translation = [gesutreRecognizer translationInView:piece.superview];
    
    if (gesutreRecognizer.state == UIGestureRecognizerStateBegan) {
        self.panInitialCenter = piece.center;
    }
    
    if (gesutreRecognizer.state != UIGestureRecognizerStateCancelled) {
        CGPoint newCenter = CGPointMake(self.panInitialCenter.x + translation.x, self.panInitialCenter.y + translation.y);
        piece.center = newCenter;
        
        if (gesutreRecognizer.state == UIGestureRecognizerStateEnded) {
            
            CGPoint velocity = [gesutreRecognizer velocityInView:self.superview];
            NSLog(@"VELOCITY: %@", NSStringFromCGPoint(velocity));
            CGPoint throwDistance = CGPointMake([self throwDistanceForInitialVelocity:velocity.x], [self throwDistanceForInitialVelocity:velocity.y]);
            CGPoint throwPoint = CGPointMake(newCenter.x + throwDistance.x, newCenter.y + throwDistance.y);
            
            [UIView animateWithDuration:MoveAnimationDuration delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
                GKPictureInPictureViewPosition nearestPosition = [self nearestPositionForPoint:throwPoint];
                piece.center = [self centerForPostion:nearestPosition];
                self.position = nearestPosition;
            } completion:nil];
        }
    } else {
        piece.center = self.panInitialCenter;
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateCancelled) {
        self.transform = CGAffineTransformMakeScale(gestureRecognizer.scale, gestureRecognizer.scale);

        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (gestureRecognizer.scale < 1.f) {
                self.sizeClass = GKPictureInPictureViewSizeSmall;
            } else {
                self.sizeClass = GKPictureInPictureViewSizeLarge;
            }

            [UIView animateWithDuration:ZoomAnimationDuration animations:^{
                self.transform = CGAffineTransformIdentity;
                self.frame = [self rectForPosition:self.position sizeClass:self.sizeClass inView:self.superview];
            }];
        }
    }
    
}

- (CGFloat)throwDistanceForInitialVelocity:(CGFloat)velocity {
    return (velocity / 3000.f) * self.decelerationRate / (1.0 - self.decelerationRate);
}

//- (void)setSizeClass:(GKPictureInPictureViewSize)sizeClass {
//    _sizeClass = sizeClass;
//
//    CGRect frame = self.frame;
//    frame.size = [self sizeForSizeClass:sizeClass];
//    self.frame = frame;
//}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Adding and removing

- (void)addToSuperView:(UIView *)superview animated:(BOOL)animated {
    if (self.superview) return;
    
    self.frame = [self rectForPosition:self.position sizeClass:self.sizeClass inView:superview];
    [self setFarState];
    
    [superview addSubview:self];
    
    [UIView animateWithDuration:animated?ShowHideAnimationDuration:0 animations:^{
        [self setNormalState];
    }];
}

- (void)removeFromSuperviewAnimated:(BOOL)animated {
    if (!self.superview) return;
    
    [UIView animateWithDuration:animated?ShowHideAnimationDuration:0 animations:^{
        [self setFarState];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setFarState {
    self.alpha = 0;
//    self.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
}

- (void)setNormalState {
    self.alpha = 1;
//    self.transform = CGAffineTransformIdentity;
}

#pragma mark - Helper

- (CGRect)rectForPosition:(GKPictureInPictureViewPosition)position sizeClass:(GKPictureInPictureViewSize)sizeClass inView:(UIView *)view {
    CGSize size = [self sizeForSizeClass:sizeClass];
    
    switch (position) {
        case GKPictureInPictureViewPositionTopRight:
            return CGRectMake(view.frame.size.width - size.width - Padding, Padding, size.width, size.height);
        case GKPictureInPictureViewPositionBottomLeft:
            return CGRectMake(Padding, view.frame.size.height - size.height - Padding, size.width, size.height);
        case GKPictureInPictureViewPositionBottomRight:
            return CGRectMake(view.frame.size.width - size.width - Padding, view.frame.size.height - size.height - Padding, size.width, size.height);
        default:
            return CGRectMake(Padding, Padding, size.width, size.height);
    }
}

- (CGSize)sizeForSizeClass:(GKPictureInPictureViewSize)sizeClass {
    switch (sizeClass) {
        case GKPictureInPictureViewSizeSmall:
            return self.smallSize;
        default:
            return self.largeSize;
    }
}

- (GKPictureInPictureViewPosition)nearestPositionForPoint:(CGPoint)point {
    CGPoint topLeftPosition = [self centerForRect:[self rectForPosition:GKPictureInPictureViewPositionTopLeft sizeClass:self.sizeClass inView:self.superview]];
    CGPoint topRightPosition = [self centerForRect:[self rectForPosition:GKPictureInPictureViewPositionTopRight sizeClass:self.sizeClass inView:self.superview]];
    CGPoint bottomLeftPosition = [self centerForRect:[self rectForPosition:GKPictureInPictureViewPositionBottomLeft sizeClass:self.sizeClass inView:self.superview]];
    CGPoint bottomRightPosition = [self centerForRect:[self rectForPosition:GKPictureInPictureViewPositionBottomRight sizeClass:self.sizeClass inView:self.superview]];
    
    GKPictureInPictureViewPosition position = GKPictureInPictureViewPositionTopLeft;
    CGFloat winnerDistance = fabs([self distanceBetweenPoint:point andPoint:topLeftPosition]);
    
    if (fabs([self distanceBetweenPoint:point andPoint:topRightPosition]) < winnerDistance) {
        position = GKPictureInPictureViewPositionTopRight;
        winnerDistance = fabs([self distanceBetweenPoint:point andPoint:topRightPosition]);
    }
    if (fabs([self distanceBetweenPoint:point andPoint:bottomLeftPosition]) < winnerDistance) {
        position = GKPictureInPictureViewPositionBottomLeft;
        winnerDistance = fabs([self distanceBetweenPoint:point andPoint:bottomLeftPosition]);
    }
    if (fabs([self distanceBetweenPoint:point andPoint:bottomRightPosition]) < winnerDistance) {
        position = GKPictureInPictureViewPositionBottomRight;
        winnerDistance = fabs([self distanceBetweenPoint:point andPoint:bottomRightPosition]);
    }
    
    return position;
}

- (CGPoint)centerForRect:(CGRect)rect {
    return CGPointMake(rect.origin.x + rect.size.width / 2.f, rect.origin.y + rect.size.height / 2.f);
}

- (CGFloat)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2 {
    CGFloat diffX = point1.x - point2.x;
    CGFloat diffY = point1.y - point2.y;
    return sqrt(diffX * diffX + diffY * diffY);
}

- (CGPoint)centerForPostion:(GKPictureInPictureViewPosition)position {
    return [self centerForRect:[self rectForPosition:position sizeClass:self.sizeClass inView:self.superview]];
}

@end
