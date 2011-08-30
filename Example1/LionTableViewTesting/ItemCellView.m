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

- (void)awakeFromNib {
	NSView *iconView = self.imageView;
	NSView *nameView = self.textField;
	NSView *detailView = self.detailTextField;
	NSDictionary *views = NSDictionaryOfVariableBindings(iconView, nameView, detailView);
	[self removeConstraints:self.constraints];
	
	// Pin icon 2 pixels from each edge and make it's horizontal size fit vertical.
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-2-[iconView]" options:0 metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[iconView]-2-|" options:0 metrics:nil views:views]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:iconView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
	
	// Pin name field to the top and tie it few pixels to the right of the icon, all the way to the right edge of the cell.
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[iconView]-4-[nameView]-2-|" options:0 metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[nameView]" options:0 metrics:nil views:views]];
	
	// Pin detail field's few pixels from the bottom and tie it's left and width to name field.
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[detailView]-5-|" options:0 metrics:nil views:views]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:nameView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nameView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
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
