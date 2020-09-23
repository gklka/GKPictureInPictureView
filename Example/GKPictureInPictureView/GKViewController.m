//
//  GKViewController.m
//  GKPictureInPictureView
//
//  Created by gklka on 07/04/2018.
//  Copyright (c) 2018 gklka. All rights reserved.
//

#import "GKViewController.h"


@interface GKViewController () <GKPictureInPictureViewDelegate>

@property (nonatomic, strong) GKPictureInPictureView *pipView;
@property (weak, nonatomic) IBOutlet GKPictureInPictureView *interfaceDesigner;

@end


@implementation GKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Our gorgeous content view
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor redColor];
    
    // Init Picture in Picture view
    self.pipView = [[GKPictureInPictureView alloc] initWithContentView:contentView];
    self.pipView.accessibilityIdentifier = @"red";
    self.pipView.smallSize = CGSizeMake(50.f, 50.f);
    self.pipView.largeSize = CGSizeMake(70.f, 70.f);
//    self.pipView.sizeClass = GKPictureInPictureViewSizeLarge;
    
    self.green.translatesAutoresizingMaskIntoConstraints = NO;
    self.blue.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.green setPosition:GKPictureInPictureViewPositionBottomLeft animated:NO];
    
    self.green.topRightPositionEnabled = NO;
    self.green.topLeftPositionEnabled = NO;
    self.green.resizeEnabled = NO;
    
    self.blue.delegate = self;
    
//    [self show:nil];
//    [self.interfaceDesigner addToSuperView:self.view animated:NO];
}

- (IBAction)show:(id)sender {
    // Show it
    [self.pipView addToSuperView:self.blue animated:YES];
}

- (IBAction)hide:(id)sender {
    // Hide it
    [self.pipView removeFromSuperviewAnimated:YES];
}

- (void)pictureInPictureView:(GKPictureInPictureView *)pictureInPictureView changedPosition:(GKPictureInPictureViewPosition)position {
    [self.pipView setPosition:position animated:YES];
}

- (void)pictureInPictureViewBeganDragging:(GKPictureInPictureView *)pictureInPictureView {
    NSLog(@"%@ began dragging", pictureInPictureView);
}

- (void)pictureInPictureViewEndedDragging:(GKPictureInPictureView *)pictureInPictureView {
    NSLog(@"%@ ended dragging", pictureInPictureView);
}

@end
