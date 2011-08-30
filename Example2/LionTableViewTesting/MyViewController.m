//
//  MyViewController.m
//  LionAutoLayoutTesting
//
//  Created by Tomaž Kragelj on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyViewController.h"

@implementation MyViewController

+ (id)viewControllerWithDefaultNib {
	return [[[self alloc] initWithNibName:@"MyViewController" bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }    
    return self;
}

@end
