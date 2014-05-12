//
//  CCZTMultiCircleViewController.m
//  CustomCircleZoomTransition
//
//  Created by Stuart Morris on 12/05/2014.
//  Copyright (c) 2014 Morris Projects Ltd. All rights reserved.
//

#import "CCZTMultiCircleViewController.h"
#import "CCZTCircleView.h"
#import "CCZTViewController2.h"
#import "CCZTTransitionDelegate.h"

@interface CCZTMultiCircleViewController ()

@property (nonatomic, strong) CCZTTransitionDelegate *transDelegate;
@property (strong, nonatomic) IBOutlet CCZTCircleView *circle1;
@property (strong, nonatomic) IBOutlet CCZTCircleView *circle2;
@property (strong, nonatomic) IBOutlet CCZTCircleView *circle3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vSpaceFromCircle1To2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vSpaceFromCircle2To3;

@end

@implementation CCZTMultiCircleViewController

#pragma mark -
#pragma mark - View Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.transDelegate = [CCZTTransitionDelegate new];
    self.transitioningDelegate = self.transDelegate;
    
    [self setupCircleViews];
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
                [self animateCircleBackToNormal:circleView];
            }
        }
    }
}

-(void)setupCircleViews {
    UITapGestureRecognizer *tapCircle1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circle1Tapped:)];
    UITapGestureRecognizer *tapCircle2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circle2Tapped:)];
    UITapGestureRecognizer *tapCircle3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circle3Tapped:)];

    [_circle1 addGestureRecognizer:tapCircle1];
    [_circle2 addGestureRecognizer:tapCircle2];
    [_circle3 addGestureRecognizer:tapCircle3];
}

#pragma mark -
#pragma mark - Tap Gestures
-(IBAction)circle1Tapped:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    UITapGestureRecognizer *tap = sender;
    CCZTCircleView *circleView = (CCZTCircleView *)tap.view;
    [self animateCircleOut:circleView];
}
-(IBAction)circle2Tapped:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    UITapGestureRecognizer *tap = sender;
    CCZTCircleView *circleView = (CCZTCircleView *)tap.view;
    [self animateCircleOut:circleView];
}
-(IBAction)circle3Tapped:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    UITapGestureRecognizer *tap = sender;
    CCZTCircleView *circleView = (CCZTCircleView *)tap.view;
    [self animateCircleOut:circleView];
}

#pragma mark -
#pragma mark - Animation
-(void)animateCircleOut:(CCZTCircleView *)circle {
    
    [self.view bringSubviewToFront:circle];
    
    // Due to issues when you have auto layout constraints and transform a view we create a reference to the constraints that we need to remove/re-add later
    // http://stackoverflow.com/questions/16289895/ios-cgaffinetransformscale-moves-my-object
    // If you have multiple circles you could use a different approach where you go through the constraints and remove the correct one
    // If I was going to implement that approach I would have one property where I store the constraints in an array that are being removed, then re-add them after
    
    if (circle == _circle1) {
        [_circle1.superview removeConstraint:self.vSpaceFromCircle1To2];
    } else if (circle == _circle3) {
        [_circle3.superview removeConstraint:self.vSpaceFromCircle2To3];
    } else if (circle == _circle2) {
        [_circle2.superview removeConstraint:self.vSpaceFromCircle1To2];
        [_circle1.superview removeConstraint:self.vSpaceFromCircle2To3];
    }
    
    // Animate from 1 to 0.5 - 0.1 duration
    // Animate from 0.5 to 10 - 0.5 duration
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            NSLog(@"Circle View - Animate to 0.5 - 0.1 Duration");
            circle.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            if (finished) {
                NSLog(@"Circle View - Animate to 10 - 0.5 Duration");
                [UIView animateWithDuration:0.5 animations:^{
                    circle.transform = CGAffineTransformMakeScale(10, 10);
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

-(void)animateCircleBackToNormal:(CCZTCircleView *)circle {

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
                        } completion:^(BOOL finished) {
                            if (finished) {
                                if (circle == _circle1) {
                                    [_circle1.superview addConstraint:self.vSpaceFromCircle1To2];
                                } else if (circle == _circle3) {
                                    [_circle3.superview addConstraint:self.vSpaceFromCircle2To3];
                                }
                            }
                        }];
                    }
                }];
            }
        }];
    });
}

@end
