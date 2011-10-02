//
//  DGAppDelegate.m
//  DGKVOBlocks
//
//  Created by Danny Greg on 02/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import "DGAppDelegate.h"
#import "NSObject+DGKVOBlocks.h"

@implementation DGAppDelegate

@synthesize window = _window;
@synthesize string;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
	[self dgkvo_addObserverForKeyPath:@"string" options:NSKeyValueObservingOptionNew block:^(NSDictionary *change) {
		NSLog(@"%@", change);
	}];
	
	
	self.string = @"ONE";
	self.string = @"TWO";
	self.string = @"THREE";
}

@end
