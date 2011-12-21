//
//  LionAutoLayoutTestingAppDelegate.m
//  LionTableViewTesting
//
//  Created by Tomaž Kragelj on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController1.h"
#import "ViewController2.h"
#import "LionAutoLayoutTestingAppDelegate.h"

typedef void(^GBPlaceholderReplaceBlock)(NSView *placeholder, NSView *currentView, NSView *newView);

@interface LionAutoLayoutTestingAppDelegate ()
- (NSArray *)layoutConstraintsForView:(NSView *)view offsetBy:(NSPoint)offset;
- (void)slideViewControllerFromLeft:(NSViewController *)controller;
- (void)slideViewControllerFromRight:(NSViewController *)controller;
- (void)replacePlaceholderViewWith:(NSViewController *)controller;
- (void)replacePlaceholderViewWith:(NSViewController *)controller block:(GBPlaceholderReplaceBlock)handler;
@property (nonatomic, strong) NSViewController *currentViewController;
@property (nonatomic, strong) ViewController1 *viewController1;
@property (nonatomic, strong) ViewController2 *viewController2;
@end

#pragma mark -

@implementation LionAutoLayoutTestingAppDelegate

@synthesize window = _window;
@synthesize placeholderView = _placeholderView;
@synthesize currentViewController = _currentViewController;
@synthesize viewController1 = _viewController1;
@synthesize viewController2 = _viewController2;

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)note {
	[self replacePlaceholderViewWith:self.viewController1];
}

#pragma mark - User actions

- (IBAction)changeToViewController1:(id)sender {
	[self slideViewControllerFromLeft:self.viewController1];
}

- (IBAction)changeToViewController2:(id)sender {
	[self slideViewControllerFromRight:self.viewController2];
}

#pragma mark - Subviews handling

- (NSArray *)layoutConstraintsForView:(NSView *)view offsetBy:(NSPoint)offset {
	// We always return constraints in order: left, width, top, height.
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:4];
	NSView *placeholder = self.placeholderView;
	[result addObject:[NSLayoutConstraint constraintWithItem:view 
												   attribute:NSLayoutAttributeLeft 
												   relatedBy:NSLayoutRelationEqual 
													  toItem:placeholder 
												   attribute:NSLayoutAttributeLeft 
												  multiplier:1.0 constant:offset.x]];
	[result addObject:[NSLayoutConstraint constraintWithItem:view 
												   attribute:NSLayoutAttributeWidth 
												   relatedBy:NSLayoutRelationEqual 
													  toItem:placeholder 
												   attribute:NSLayoutAttributeWidth 
												  multiplier:1.0 constant:0.0]];
	[result addObject:[NSLayoutConstraint constraintWithItem:view 
												   attribute:NSLayoutAttributeTop 
												   relatedBy:NSLayoutRelationEqual 
													  toItem:placeholder 
												   attribute:NSLayoutAttributeTop 
												  multiplier:1.0 constant:offset.y]];
	[result addObject:[NSLayoutConstraint constraintWithItem:view 
												   attribute:NSLayoutAttributeHeight 
												   relatedBy:NSLayoutRelationEqual 
													  toItem:placeholder 
												   attribute:NSLayoutAttributeHeight 
												  multiplier:1.0 constant:0.0]];
	
	// Finally prepare a new animation for the transition; we need it so that we can intercept animationDidStop:finished: and remove old view.
	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.delegate = self;
	[[result objectAtIndex:0] setAnimations:[NSDictionary dictionaryWithObject:animation forKey:@"constant"]];
	return result;
}

- (void)slideViewControllerFromLeft:(NSViewController *)controller {
	[self replacePlaceholderViewWith:controller block:^(NSView *placeholder, NSView *currentView, NSView *newView) {
		CGFloat width = placeholder.bounds.size.width;
		NSArray *constraints = [self layoutConstraintsForView:newView offsetBy:NSMakePoint(-width, 0.0)];
		[newView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[placeholder addSubview:newView];
		[placeholder addConstraints:constraints];
		[[[placeholder.constraints objectAtIndex:0] animator] setConstant:width];
		[[[constraints objectAtIndex:0] animator] setConstant:0.0];
	}];
}

- (void)slideViewControllerFromRight:(NSViewController *)controller {
	[self replacePlaceholderViewWith:controller block:^(NSView *placeholder, NSView *currentView, NSView *newView) {
		CGFloat width = placeholder.bounds.size.width;
		NSArray *constraints = [self layoutConstraintsForView:newView offsetBy:NSMakePoint(width, 0.0)];
		[newView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[placeholder addSubview:newView];
		[placeholder addConstraints:constraints];
		[[[placeholder.constraints objectAtIndex:0] animator] setConstant:-width];
		[[[constraints objectAtIndex:0] animator] setConstant:0.0];
	}];
}

- (void)replacePlaceholderViewWith:(NSViewController *)controller {
	[self replacePlaceholderViewWith:controller block:^(NSView *placeholder, NSView *currentView, NSView *newView) {
		if (currentView) {
			[currentView removeFromSuperview];
		}
		if (newView) {
			NSDictionary *views = NSDictionaryOfVariableBindings(newView);
			[newView setTranslatesAutoresizingMaskIntoConstraints:NO];
			[placeholder addSubview:newView];
			[placeholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView]|" options:0 metrics:nil views:views]];
			[placeholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|" options:0 metrics:nil views:views]];
		}
	}];
}

- (void)replacePlaceholderViewWith:(NSViewController *)controller block:(GBPlaceholderReplaceBlock)handler {
	if (controller == self.currentViewController) return;
	self.currentViewController = controller;
	NSView *placeholderView = self.placeholderView;
	NSView *currentView = self.placeholderView.subviews.lastObject;
	NSView *newView = self.currentViewController.view;
	handler(placeholderView, currentView, newView);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	// Once animation is finished, we should remove previous view. Note that the delegate is called two times as we have two animations running for both views. Hence we need to take care to only remove original view! We simply remove first view in hierarchy as we always append new one after it - kind of a hack, but works...
	if (!flag || self.placeholderView.subviews.count < 2) return;
	[[self.placeholderView.subviews objectAtIndex:0] removeFromSuperview];
}

#pragma mark - Properties

- (ViewController1 *)viewController1 {
	if (_viewController1) return _viewController1;
	_viewController1 = [[ViewController1 alloc] init];
	return _viewController1;
}

- (ViewController2 *)viewController2 {
	if (_viewController2) return _viewController2;
	_viewController2 = [[ViewController2 alloc] init];
	return _viewController2;
}

@end
