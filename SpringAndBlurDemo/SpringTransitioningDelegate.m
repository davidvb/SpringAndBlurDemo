//
//  TransitioningDelegate.m
//  Bencina Chile
//
//  Created by Sergio Campamá on 1/18/14.
//  Copyright (c) 2014 Kaipi. All rights reserved.
//

#import "SpringTransitioningDelegate.h"
#import "PresentingSpringAnimator.h"
#import "DynamicDismissalAnimator.h"
#import "LinearDismissalAnimator.h"

@implementation SpringTransitioningDelegate

- (id)initWithDelegate:(UIViewController *)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.transitioningDirection = TransitioningDirectionLeft;
    }
    return self;
}

- (void)presentViewController:(UIViewController *)modalViewController
{
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
    modalViewController.transitioningDelegate = self;
    [self.delegate presentViewController:modalViewController animated:YES completion:^{
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [modalViewController.view addGestureRecognizer:gestureRecognizer];
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    PresentingSpringAnimator *animator = [[PresentingSpringAnimator alloc] initWithTransitioningDirection:self.transitioningDirection];
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<UIViewControllerAnimatedTransitioning> animator;
    if (self.interactive)
        animator = [[LinearDismissalAnimator alloc] initWithTransitioningDirection:self.transitioningDirection];
    else
        animator = [[DynamicDismissalAnimator alloc] initWithTransitioningDirection:self.transitioningDirection];
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if (self.interactive) {
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        return self.interactiveTransition;
    }
    return nil;
}


- (void)handleGesture:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.interactive = YES;
            [self.delegate dismissViewControllerAnimated:YES completion:^{
                self.interactive = NO;
            }];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            UIView *containerView = gesture.view.superview;
            CGPoint translation = [gesture translationInView:containerView];
            CGFloat percent = [self percentForTranslation:translation inFrame:containerView.frame];
            [self.interactiveTransition updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (self.interactiveTransition.percentComplete > 0.25)
                [self.interactiveTransition finishInteractiveTransition];
            else
                [self.interactiveTransition cancelInteractiveTransition];
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            [self.interactiveTransition cancelInteractiveTransition];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)percentForTranslation:(CGPoint)translation inFrame:(CGRect)frame
{
    CGFloat percent;
    if (self.transitioningDirection & (TransitioningDirectionDown | TransitioningDirectionUp)) {
        percent = translation.y/CGRectGetHeight(frame);
    } else {
        percent = translation.x/CGRectGetWidth(frame);
    }
    
    if (self.transitioningDirection & (TransitioningDirectionUp | TransitioningDirectionLeft))
        percent *= -1.0f;
    
    return percent;
}

@end
