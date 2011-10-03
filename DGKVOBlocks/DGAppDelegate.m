//
//  DGAppDelegate.m
//  DGKVOBlocks
//
//  Created by Danny Greg on 02/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import "DGAppDelegate.h"
#import "NSObject+DGKVOBlocks.h"

@interface DGAppDelegate () {
@private
    DGKVOBlocksObserver *numberObserver;
}

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
    [numberObserver stopObserving];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
	[DGKVOBlocksObserver observerForObject:self
								   keyPath:@"string"
								   options:NSKeyValueObservingOptionNew
									 queue:nil
								usingBlock:^(DGKVOBlocksObserver *observer, NSDictionary *change) {
		
		NSLog(@"%@", change);
		
		if ([self.string isEqualToString:@"THREE"])
			[observer stopObserving];
		
	}];
	
	self.string = @"ONE";
	self.string = @"TWO";
	self.string = @"THREE";
    self.string = @"This should not appear.";
    
    // Use this with a nil queue to see the main thread blocking.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    numberObserver = [DGKVOBlocksObserver observerForObject:self 
													keyPath:@"number"
													options:NSKeyValueObservingOptionNew
													  queue:queue
												 usingBlock:^(DGKVOBlocksObserver *observer, NSDictionary *change) {
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
