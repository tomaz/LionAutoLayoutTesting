//
//  ItemCellView.m
//  LionTableViewTesting
//
//  Created by Tomaž Kragelj on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemCellView.h"

static BOOL kLargeSizeRequested = YES;

#pragma mark -

@implementation ItemCellView

@synthesize detailTextField = _detailTextField;

- (void)dealloc {
	[_detailTextField release], _detailTextField = nil;
    [super dealloc];
}

- (void)setObjectValue:(id)objectValue {
	[super setObjectValue:objectValue];
	[self layoutViewsForLargeSize:kLargeSizeRequested animated:NO];
}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
	NSColor *textColor = (backgroundStyle == NSBackgroundStyleDark) ? [NSColor windowBackgroundColor] : [NSColor controlShadowColor];
	self.detailTextField.textColor = textColor;
	[super setBackgroundStyle:backgroundStyle];
}

- (void)layoutViewsForLargeSize:(BOOL)largeSize animated:(BOOL)animated {
	kLargeSizeRequested = largeSize;
	
	// If large size is requested, we should show details text field otherwise hide it.
	CGFloat detailAlpha = largeSize ? 1.0f : 0.0f;

	if (animated) {
		[[self.detailTextField animator] setAlphaValue:detailAlpha];
	} else {
		[self.detailTextField setAlphaValue:detailAlpha];
	}
}

@end
