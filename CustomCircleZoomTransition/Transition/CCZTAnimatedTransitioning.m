//
//  CCZTAnimatedTransitioning.m
//  CustomCircleZoomTransition
//
//  Created by Stuart Morris on 09/05/2014.
//  Copyright (c) 2014 Morris Projects Ltd. All rights reserved.
//

#import "CCZTAnimatedTransitioning.h"

static NSTimeInterval const CCZTAnimatedTransitionDuration = 2.0f;


@implementation CCZTAnimatedTransitioning


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:(self.reverse)?0.25:1.0 animations:^{
            if (self.reverse) {
                NSLog(@"Transition FROM (back) - fading in/out controllers");
                toViewController.view.layer.opacity = 1;
                fromViewController.view.layer.opacity = 0;
            } else {
                NSLog(@"Transition TO - fading out controller");
                fromViewController.view.layer.opacity = 0;
            }
        } completion:^(BOOL finished) {
            NSLog(@"Custom transition completed");
            [transitionContext completeTransition:finished];
        }];
    });
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return CCZTAnimatedTransitionDuration;
}

@end
