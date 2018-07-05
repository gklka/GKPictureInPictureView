//
//  GKViewController.m
//  GKPictureInPictureView
//
//  Created by gklka on 07/04/2018.
//  Copyright (c) 2018 gklka. All rights reserved.
//

#import "GKViewController.h"

@import GKPictureInPictureView;


@interface GKViewController ()

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
//    self.pipView.sizeClass = GKPictureInPictureViewSizeLarge;
    
//    [self show:nil];
//    [self.interfaceDesigner addToSuperView:self.view animated:NO];
}

- (IBAction)show:(id)sender {
    // Show it
    [self.pipView addToSuperView:self.view animated:YES];
}

- (IBAction)hide:(id)sender {
    // Hide it
    [self.pipView removeFromSuperviewAnimated:YES];
}

@end
