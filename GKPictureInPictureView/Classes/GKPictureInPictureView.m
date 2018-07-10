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
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic) CGPoint panInitialCenter;

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

@property (nonatomic) CGFloat decelerationRate;

@end


@implementation GKPictureInPictureView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super init];
    
    if (self) {
        [self setup];
        
        // Add user's view to our content
        self.contentView = contentView;
        self.contentView.layer.cornerRadius = 4.f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:contentView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:@{} views:@{@"content": contentView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[content]|" options:0 metrics:@{} views:@{@"content": contentView}]];
    }
    
    return self;
}

- (void)setup {
    if (self.gestureRecognizers.count > 0) return;
    
    // Add shadow
    self.layer.cornerRadius = 4.f;
    self.layer.shadowRadius = 4.f;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2.f);
    
    // Default values
    self.padding = UIEdgeInsetsMake(Padding, Padding, Padding, Padding);
    self.smallSize = CGSizeMake(200.f, 124.f);
    self.largeSize = CGSizeMake(300.f, 187.f);
    self.position = GKPictureInPictureViewPositionTopLeft;
    self.sizeClass = GKPictureInPictureViewSizeSmall;
    self.panInitialCenter = CGPointZero;
    self.decelerationRate = [UIScrollView new].decelerationRate;
    self.topLeftPositionEnabled = YES;
    self.topRightPositionEnabled = YES;
    self.bottomLeftPositionEnabled = YES;
    self.bottomRightPositionEnabled = YES;
    self.resizeEnabled = YES;
    
    // Add constraints
    
    // Handle gestures
    [self addGestureRecognizer:self.panGestureRecognizer];
    [self addGestureRecognizer:self.pinchGestureRecognizer];
    [self addGestureRecognizer:self.doubleTapGestureRecognizer];
    
    // Width and height constraints
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:self.smallSize.width];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:self.smallSize.height];
    self.widthConstraint.active = YES;
    self.heightConstraint.active = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLog(@"Setup done for view: %@", self);
}

- (void)setupConstraints {
    if (!self.superview) return;
    
    self.topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.f constant:self.padding.top];
    self.leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.f constant:self.padding.left];
    self.topConstraint.active = YES;
    self.leftConstraint.active = YES;

    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.f constant:self.padding.bottom];
    self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.f constant:self.padding.right];
    self.bottomConstraint.active = NO;
    self.rightConstraint.active = NO;
    
    NSLog(@"Setup constraints done for view: %@", self);
}

- (void)cleanConstraints {
    self.topConstraint.active = NO;
    self.leftConstraint.active = NO;
    self.bottomConstraint.active = NO;
    self.rightConstraint.active = NO;
    
    self.topConstraint = nil;
    self.leftConstraint = nil;
    self.bottomConstraint = nil;
    self.rightConstraint = nil;
}

- (void)didMoveToSuperview {
    [self setupConstraints];
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

- (UITapGestureRecognizer *)doubleTapGestureRecognizer {
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    
    return _doubleTapGestureRecognizer;
}

- (void)pan:(UIPanGestureRecognizer *)gesutreRecognizer {
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
            CGPoint throwDistance = CGPointMake([self throwDistanceForInitialVelocity:velocity.x], [self throwDistanceForInitialVelocity:velocity.y]);
            CGPoint throwPoint = CGPointMake(newCenter.x + throwDistance.x, newCenter.y + throwDistance.y);
            
            [UIView animateWithDuration:MoveAnimationDuration delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
                GKPictureInPictureViewPosition nearestPosition = [self nearestPositionForPoint:throwPoint];
                piece.center = [self centerForPostion:nearestPosition];
                self.position = nearestPosition;
            } completion:^(BOOL finished) {
                [self refreshAnimated:NO];
            }];
        }
    } else {
        piece.center = self.panInitialCenter;
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gestureRecognizer {
    if (!self.resizeEnabled) return;
    
    if (gestureRecognizer.state != UIGestureRecognizerStateCancelled) {
        self.transform = CGAffineTransformMakeScale(gestureRecognizer.scale, gestureRecognizer.scale);

        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (gestureRecognizer.scale < 1.f) {
                self.sizeClass = GKPictureInPictureViewSizeSmall;
            } else {
                self.sizeClass = GKPictureInPictureViewSizeLarge;
            }

            [UIView animateWithDuration:ZoomAnimationDuration animations:^{
                [self refreshAnimated:NO];
                self.transform = CGAffineTransformMakeScale(1.f, 1.f);
            } completion:^(BOOL finished) {
            }];
        }
    }
    
}

- (void)doubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (!gestureRecognizer.view) return;
    
    self.sizeClass = self.sizeClass==GKPictureInPictureViewSizeSmall ? GKPictureInPictureViewSizeLarge : GKPictureInPictureViewSizeSmall;
    [self refreshAnimated:YES];
}

- (CGFloat)throwDistanceForInitialVelocity:(CGFloat)velocity {
    return (velocity / 3000.f) * self.decelerationRate / (1.0 - self.decelerationRate);
}

- (void)setPosition:(GKPictureInPictureViewPosition)position {
    _position = position;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(pictureInPictureView:changedPosition:)]) {
        [self.delegate pictureInPictureView:self changedPosition:position];
    }
}

- (void)setSizeClass:(GKPictureInPictureViewSize)sizeClass {
    _sizeClass = sizeClass;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(pictureInPictureView:changedSizeClass:)]) {
        [self.delegate pictureInPictureView:self changedSizeClass:sizeClass];
    }
}

- (void)setPadding:(UIEdgeInsets)padding {
    _padding = padding;
    if (self.leftConstraint) {
        // Constraints are up
        [self cleanConstraints];
        [self setupConstraints];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Adding and removing

- (void)addToSuperView:(UIView *)superview animated:(BOOL)animated {
    if (self.superview) return;
    
    [self refreshAnimated:NO];
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
        [self cleanConstraints];
        [self setNormalState];
    }];
}

#pragma mark - Setting size

- (void)setPosition:(GKPictureInPictureViewPosition)position animated:(BOOL)animated {
    self.position = position;
    [self refreshAnimated:animated];
}

- (void)setSizeClass:(GKPictureInPictureViewSize)sizeClass animated:(BOOL)animated {
    self.sizeClass = sizeClass;
    [self refreshAnimated:animated];
}

#pragma mark - Other

- (void)refreshAnimated:(BOOL)animated {
    [UIView animateWithDuration:animated?ZoomAnimationDuration:0 animations:^{
        switch (self.position) {
            case GKPictureInPictureViewPositionTopLeft:
            {
                self.rightConstraint.active = NO;
                self.bottomConstraint.active = NO;
                self.leftConstraint.active = YES;
                self.topConstraint.active = YES;
                break;
            }
            case GKPictureInPictureViewPositionTopRight:
            {
                self.leftConstraint.active = NO;
                self.bottomConstraint.active = NO;
                self.rightConstraint.active = YES;
                self.topConstraint.active = YES;
                break;
            }
            case GKPictureInPictureViewPositionBottomLeft:
            {
                self.rightConstraint.active = NO;
                self.topConstraint.active = NO;
                self.leftConstraint.active = YES;
                self.bottomConstraint.active = YES;
                break;
            }
            case GKPictureInPictureViewPositionBottomRight:
            {
                self.leftConstraint.active = NO;
                self.topConstraint.active = NO;
                self.rightConstraint.active = YES;
                self.bottomConstraint.active = YES;
                break;
            }
            default:
                break;
        }
        
        switch (self.sizeClass) {
            case GKPictureInPictureViewSizeSmall:
            {
                self.widthConstraint.constant = self.smallSize.width;
                self.heightConstraint.constant = self.smallSize.height;
                break;
            }
            case GKPictureInPictureViewSizeLarge:
            {
                self.widthConstraint.constant = self.largeSize.width;
                self.heightConstraint.constant = self.largeSize.height;
                break;
            }
            default:
                break;
        }
        
        [self.superview layoutIfNeeded];
        //        self.frame = [self rectForPosition:self.position sizeClass:self.sizeClass inView:self.superview];
    }];
}

- (BOOL)isVisible {
    return (self.superview != nil);
}

#pragma mark - Helper

- (CGRect)rectForPosition:(GKPictureInPictureViewPosition)position sizeClass:(GKPictureInPictureViewSize)sizeClass inView:(UIView *)view {
    CGSize size = [self sizeForSizeClass:sizeClass];

    switch (position) {
        case GKPictureInPictureViewPositionTopRight:
            return CGRectMake(view.frame.size.width - size.width - self.padding.right, self.padding.top, size.width, size.height);
        case GKPictureInPictureViewPositionBottomLeft:
            return CGRectMake(self.padding.left, view.frame.size.height - size.height - self.padding.bottom, size.width, size.height);
        case GKPictureInPictureViewPositionBottomRight:
            return CGRectMake(view.frame.size.width - size.width - self.padding.right, view.frame.size.height - size.height - self.padding.bottom, size.width, size.height);
        default:
            return CGRectMake(self.padding.left, self.padding.top, size.width, size.height);
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
    
    CGFloat winnerDistance = CGFLOAT_MAX;
    GKPictureInPictureViewPosition position = GKPictureInPictureViewPositionTopLeft;
    
    if (fabs([self distanceBetweenPoint:point andPoint:topLeftPosition]) < winnerDistance &&
        self.topLeftPositionEnabled) {
        position = GKPictureInPictureViewPositionTopLeft;
        winnerDistance = fabs([self distanceBetweenPoint:point andPoint:topLeftPosition]);
    }
    if (fabs([self distanceBetweenPoint:point andPoint:topRightPosition]) < winnerDistance &&
        self.topRightPositionEnabled) {
        position = GKPictureInPictureViewPositionTopRight;
        winnerDistance = fabs([self distanceBetweenPoint:point andPoint:topRightPosition]);
    }
    if (fabs([self distanceBetweenPoint:point andPoint:bottomLeftPosition]) < winnerDistance &&
        self.bottomLeftPositionEnabled) {
        position = GKPictureInPictureViewPositionBottomLeft;
        winnerDistance = fabs([self distanceBetweenPoint:point andPoint:bottomLeftPosition]);
    }
    if (fabs([self distanceBetweenPoint:point andPoint:bottomRightPosition]) < winnerDistance &&
        self.bottomRightPositionEnabled) {
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

- (void)setFarState {
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
}

- (void)setNormalState {
    self.alpha = 1;
    self.transform = CGAffineTransformMakeScale(1.f, 1.f);
}

@end
