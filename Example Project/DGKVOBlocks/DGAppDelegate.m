//
//  DGAppDelegate.m
//  DGKVOBlocks
//
//  Created by Danny Greg on 02/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import "DGAppDelegate.h"
#import "NSObject+DGKVOBlocks.h"

@interface DGAppDelegate ()

- (NSUInteger)fibonacciNumber:(NSUInteger)aNumber;
@end

@implementation DGAppDelegate

@synthesize window =_window;
@synthesize string;
@synthesize fibonacciField;
@synthesize number;

- (id)init 
{
    if (!(self = [super init])) {
        return nil;
    }
    number = 1;
    
    return self;
}

- (void)dealloc {
    [self dgkvo_removeObserver:numberObserver];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
	stringObserver = [self dgkvo_addObserverForKeyPath:@"string" options:NSKeyValueObservingOptionNew queue:nil usingBlock:^(NSDictionary *change) {
		NSLog(@"%@", change);
	}];
	
	self.string = @"ONE";
	self.string = @"TWO";
	self.string = @"THREE";
	
	[self dgkvo_removeObserver:stringObserver];
    
    self.string = @"This should not appear.";
    
    // Use this with a nil queue to see the main thread blocking.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    numberObserver = [self dgkvo_addObserverForKeyPath:@"number" options:NSKeyValueObservingOptionNew queue:queue usingBlock:^(NSDictionary *change) {
        NSLog(@"%@", change);
        self.fibonacciField.integerValue = [self fibonacciNumber:number];
	}];
    
}


// Don't laugh. I know it's terrible - that's the whole point.
- (NSUInteger)fibonacciNumber:(NSUInteger)aNumber {
    if (aNumber < 2) {
        return aNumber;
    }
    return [self fibonacciNumber:aNumber - 2] + [self fibonacciNumber:aNumber -1];
}

@end
