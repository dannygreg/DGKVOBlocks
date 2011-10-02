//
//  NSObject+DGKVOBlocks.m
//  DGKVOBlocks
//
//  Created by Danny Greg on 02/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import "NSObject+DGKVOBlocks.h"

NSString *DGKVOBlocksObservationContext = @"DGKVOBlocksObservationContext";

@interface DGKVOBlocksObserver : NSObject 

@property (nonatomic, copy) DGKVOObserverBlock block;

@end

@implementation DGKVOBlocksObserver

@synthesize block = _block;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    if (context == &DGKVOBlocksObservationContext) {
        self.block(change);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

@implementation NSObject (DGKVOBlocks)

@end
