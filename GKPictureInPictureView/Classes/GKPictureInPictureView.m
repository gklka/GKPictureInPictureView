//
//  GKPictureInPictureView.m
//  GKPictureInPictureView
//
//  Created by GK on 2018.07.04..
//

#import "GKPictureInPictureView.h"

@implementation GKPictureInPictureView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.layer.cornerRadius = 4.f;
        self.layer.shadowRadius = 4.f;
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2.f);
    }
    
    return self;
}

@end
