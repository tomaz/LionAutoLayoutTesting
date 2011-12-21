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
- (void)changePlaceholderWithViewFromController:(NSViewController *)controller;
@property (nonatomic, strong) ViewController1 *viewController1;
@property (nonatomic, strong) ViewController2 *viewController2;
@end

#pragma mark -

@implementation LionAutoLayoutTestingAppDelegate

@synthesize window = _window;
@synthesize placeholderView = _placeholderView;
@synthesize viewController1 = _viewController1;
@synthesize viewController2 = _viewController2;

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)note {
}

#pragma mark - Helpers

- (void)changePlaceholderWithViewFromController:(NSViewController *)controller {
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
