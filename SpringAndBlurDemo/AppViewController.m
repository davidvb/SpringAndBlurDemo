//
//  ViewController.m
//  SpringAndBlurDemo
//
//  Created by Sergio Campamá on 1/18/14.
//  Copyright (c) 2014 Sergio Campamá. All rights reserved.
//

#import "AppViewController.h"
#import "SpringTransitioningDelegate.h"
#import "ModalViewController.h"

@interface AppViewController ()

@property (nonatomic, strong) SpringTransitioningDelegate *transitioningDelegate;

@end

@implementation AppViewController

-(void)viewDidLoad
{
    self.transitioningDelegate = [[SpringTransitioningDelegate alloc] initWithDelegate:self];
}

- (void)presentModal
{
    ModalViewController *viewController = [ModalViewController new];
    [self.transitioningDelegate presentViewController:viewController];
}

- (IBAction)fromTop:(id)sender
{
    self.transitioningDelegate.transitioningDirection = TransitioningDirectionUp;
    [self presentModal];
}

- (IBAction)fromLeft:(id)sender
{
    self.transitioningDelegate.transitioningDirection = TransitioningDirectionLeft;
    [self presentModal];
}

- (IBAction)fromBottom:(id)sender
{
    self.transitioningDelegate.transitioningDirection = TransitioningDirectionDown;
    [self presentModal];
}

- (IBAction)fromRight:(id)sender
{
    self.transitioningDelegate.transitioningDirection = TransitioningDirectionRight;
    [self presentModal];
}

@end
