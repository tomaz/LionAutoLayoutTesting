//
//  LionAutoLayoutTestingAppDelegate.m
//  LionTableViewTesting
//
//  Created by Tomaž Kragelj on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyViewController.h"
#import "LionAutoLayoutTestingAppDelegate.h"

@interface LionAutoLayoutTestingAppDelegate ()

- (void)changePlaceholderWithViewFromController:(NSViewController *)controller;
@property (nonatomic, readonly) MyViewController *myViewController;

@end

#pragma mark -

@implementation LionAutoLayoutTestingAppDelegate

@synthesize window = _window;
@synthesize placeholderView = _placeholderView;
@synthesize myViewController = _myViewController;

#pragma mark - Initialization & disposal

- (void)dealloc {
	[_myViewController release], _myViewController = nil;
    [super dealloc];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)note {
	[self changePlaceholderWithViewFromController:self.myViewController];
}

#pragma mark - Helpers

- (void)changePlaceholderWithViewFromController:(NSViewController *)controller {
	NSView *placeholderView = self.placeholderView;
	NSView *realView = controller.view;
	NSDictionary *views = NSDictionaryOfVariableBindings(realView);
	
	// Remove current subviews.
	while ([placeholderView.subviews count] > 0) {
		[[placeholderView.subviews lastObject] removeFromSuperview];
	}
	
	// Disable autoresize masks translation on the real view otherwise auto-layout won't work! Then add it to placeholder.
	[realView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[placeholderView addSubview:realView];
	
	// Setup constraints after adding view to placeholder - we fit real view completely inside placeholder and make it resize with it. Note how we set contraints on the superview of the view which we want to layout!
	[placeholderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[realView(>=190)]|" options:0 metrics:nil views:views]];
	[placeholderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[realView(>=80)]|" options:0 metrics:nil views:views]];
}

- (MyViewController *)myViewController {
	if (_myViewController) return _myViewController;
	_myViewController = [MyViewController viewControllerWithDefaultNib];
	return _myViewController;
}

@end
