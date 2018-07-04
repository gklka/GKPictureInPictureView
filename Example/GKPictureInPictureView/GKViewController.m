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

@end


@implementation GKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pipView = [GKPictureInPictureView new];
    self.pipView.frame = CGRectMake(20, 40, 300, 200);
    self.pipView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pipView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
