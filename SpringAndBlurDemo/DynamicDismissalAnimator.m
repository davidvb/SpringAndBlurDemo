//
//  DynamicDismissalAnimator.m
//  SpringAndBlurDemo
//
//  Created by Sergio Campamá on 1/18/14.
//  Copyright (c) 2014 Sergio Campamá. All rights reserved.
//

#import "DynamicDismissalAnimator.h"

@interface DynamicDismissalAnimator ()

@property (nonatomic) TransitioningDirection transitioningDirection;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation DynamicDismissalAnimator

- (id)initWithTransitioningDirection:(TransitioningDirection)transitioningDirection
{
    self = [super init];
    if (self) {
        self.transitioningDirection = transitioningDirection;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:transitionContext.containerView];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[fromVC.view]];
    [itemBehaviour addAngularVelocity:M_PI/2.0f forItem:fromVC.view];
    [self.animator addBehavior:itemBehaviour];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[fromVC.view]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 3.0f);
    gravityBehaviour.action = ^{
        if (!CGRectIntersectsRect(fromVC.view.frame, transitionContext.containerView.frame)) {
            [self.animator removeAllBehaviors];
            [transitionContext completeTransition:YES];
        }
    };
    
    [self.animator addBehavior:gravityBehaviour];
}


@end
