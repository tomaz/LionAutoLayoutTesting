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

@interface LionAutoLayoutTestingAppDelegate ()
- (void)replacePlaceholderViewWith:(NSViewController *)controller;
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
	[self replacePlaceholderViewWith:self.viewController1];
}

- (IBAction)changeToViewController2:(id)sender {
	[self replacePlaceholderViewWith:self.viewController2];
}

#pragma mark - Helpers

- (void)replacePlaceholderViewWith:(NSViewController *)controller {
	if (controller == self.currentViewController) return;
	self.currentViewController = controller;
	NSView *placeholderView = self.placeholderView;
	NSView *currentView = self.placeholderView.subviews.lastObject;
	NSView *newView = self.currentViewController.view;
	if (currentView) {
		[currentView removeFromSuperview];
	}
	if (newView) {
		NSDictionary *views = NSDictionaryOfVariableBindings(newView);
		[newView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[placeholderView addSubview:newView];
		[placeholderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView]|" options:0 metrics:nil views:views]];
		[placeholderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|" options:0 metrics:nil views:views]];
	}
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
