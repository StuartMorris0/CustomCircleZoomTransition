//
//  CCZTViewController2.m
//  CustomCircleZoomTransition
//
//  Created by Stuart Morris on 09/05/2014.
//  Copyright (c) 2014 Morris Projects Ltd. All rights reserved.
//

#import "CCZTViewController2.h"

@interface CCZTViewController2 ()

@end

@implementation CCZTViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"Second Controller";
    label.textColor = [UIColor blueColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *superViewReference = self.view;
    
    [superViewReference addSubview:label];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superViewReference attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superViewReference attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [superViewReference addConstraint:centerX];
    [superViewReference addConstraint:centerY];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized)]];
}


- (void)tapRecognized
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}


@end
