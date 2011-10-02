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
    id stringObserver;
    id numberObserver;
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
    [self dgkvo_removeObserverWithIdentifier:numberObserver];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    number = 1;
	
    stringObserver = [self dgkvo_addObserverForKeyPath:@"string" options:NSKeyValueObservingOptionNew block:^(NSDictionary *change) {
		NSLog(@"%@", change);
	}];
	
	self.string = @"ONE";
	self.string = @"TWO";
	self.string = @"THREE";
	
	[self dgkvo_removeObserverWithIdentifier:stringObserver];
    
    self.string = @"This should not appear.";
    
    numberObserver = [self dgkvo_addObserverForKeyPath:@"number" options:NSKeyValueObservingOptionNew block:^(NSDictionary *change) {
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
