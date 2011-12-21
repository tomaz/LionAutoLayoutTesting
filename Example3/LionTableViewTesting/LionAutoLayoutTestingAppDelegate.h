//
//  LionAutoLayoutTestingAppDelegate.h
//  LionTableViewTesting
//
//  Created by Tomaž Kragelj on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface LionAutoLayoutTestingAppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)changeToViewController1:(id)sender;
- (IBAction)changeToViewController2:(id)sender;

@property (nonatomic, unsafe_unretained) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet NSView *placeholderView;

@end
