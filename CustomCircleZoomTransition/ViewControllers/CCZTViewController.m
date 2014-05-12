//
//  CCZTViewController.m
//  CustomCircleZoomTransition
//
//  Created by Stuart Morris on 09/05/2014.
//  Copyright (c) 2014 Morris Projects Ltd. All rights reserved.
//

#import "CCZTViewController.h"
#import "CCZTCircleView.h"
#import "CCZTViewController2.h"
#import "CCZTTransitionDelegate.h"

@interface CCZTViewController ()

@property (nonatomic, strong) CCZTCircleView *circleView;
@property (nonatomic, strong) CCZTTransitionDelegate *transDelegate;

@end

static const CGFloat cricleHeightAndWidth = 100.0;

@implementation CCZTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    self.title = @"View Controller 1";

    self.transDelegate = [CCZTTransitionDelegate new];
    self.transitioningDelegate = self.transDelegate;
    
    [self setupViewControllerViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[CCZTCircleView class]]) {
            if (subview.transform.a != 1 || subview.transform.d != 1) {
                CCZTCircleView *circleView = (CCZTCircleView *)subview;
                circleView.reverseAnimationRequired = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        circleView.transform = CGAffineTransformIdentity;
                    }];
                });
            }
        }
    }

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[CCZTCircleView class]]) {
            CCZTCircleView *circleView = (CCZTCircleView *)subview;
            if (circleView.reverseAnimationRequired) {
                [self undoAnimatedCirle:circleView];
            }
        }
    }
}

-(void)setupViewControllerViews {
    self.circleView = [[CCZTCircleView alloc] initWithFrame:CGRectMake(0, 0, cricleHeightAndWidth, cricleHeightAndWidth)]; // Added frame so that the layer can be rounded but this is also controlled by the constraints
    self.circleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *circleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleTapped:)];
    [self.circleView addGestureRecognizer:circleTap];
    [self.view addSubview:self.circleView];
    
    [self setupCircleViewAutoLayoutConstraints];
}


-(void)setupCircleViewAutoLayoutConstraints {
    NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.circleView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.circleView.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *circleHeight = [NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:cricleHeightAndWidth];
    NSLayoutConstraint *circleWidth = [NSLayoutConstraint constraintWithItem:self.circleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.circleView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.circleView.superview addConstraint:circleHeight];
    [self.circleView.superview addConstraint:circleWidth];
    [self.circleView.superview addConstraint:xCenterConstraint];
    [self.circleView.superview addConstraint:yCenterConstraint];
    
}

-(void)circleTapped:(id)sender {
    UITapGestureRecognizer *tapRecognizer = sender;
    CCZTCircleView *circleView = (CCZTCircleView *)tapRecognizer.view;
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    // Animate from 1 to 0.5 - 0.1 duration
    // Animate from 0.5 to 10 - 0.5 duration
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            NSLog(@"Circle View - Animate to 0.5 - 0.1 Duration");
            circleView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            if (finished) {
                NSLog(@"Circle View - Animate to 10 - 0.5 Duration");
                [UIView animateWithDuration:0.5 animations:^{
                    circleView.transform = CGAffineTransformMakeScale(10, 10);
                } completion:^(BOOL finished) {
                    if (finished) {
                        NSLog(@"Circle View - Animation complete send for VC transition");
                        CCZTViewController2 *VC2 = [[CCZTViewController2 alloc] init];
                        VC2.transitioningDelegate = self.transitioningDelegate;
                        [self presentViewController:VC2 animated:YES completion:nil];
                    }
                }];
            }
        }];
    });
}

-(void)undoAnimatedCirle:(CCZTCircleView *)circle {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    circle.reverseAnimationRequired = NO;

    // Animate from current transform to 0.5 - 0.5 duration
    // Animate from 0.5 to 1.5 - 0.2 duration
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            NSLog(@"Circle View - Animate to 0.5 - 0.25 Duration");
            circle.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    NSLog(@"Circle View - Aniamte to 1.5 - 0.2 Duration");
                    circle.transform = CGAffineTransformMakeScale(1.5, 1.5);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            NSLog(@"Circle View - Animate to no tranform - 0.1 Duration");
                            circle.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    });
}



-(void)dealloc {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
@end
