//
//  CCZTTransitionDelegate.m
//  CustomCircleZoomTransition
//
//  Created by Stuart Morris on 09/05/2014.
//  Copyright (c) 2014 Morris Projects Ltd. All rights reserved.
//

#import "CCZTTransitionDelegate.h"
#import "CCZTAnimatedTransitioning.h"

@implementation CCZTTransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{

    CCZTAnimatedTransitioning *transitioning = [CCZTAnimatedTransitioning new];
    return transitioning;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{

    CCZTAnimatedTransitioning *transitioning = [CCZTAnimatedTransitioning new];
    transitioning.reverse = YES;
    return transitioning;
}

@end
