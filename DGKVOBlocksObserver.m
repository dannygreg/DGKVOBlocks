//
//  DGKVOBlocksObserver.m
//  DGKVOBlocks
//
//  Created by Hamish Allan on 03/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import "DGKVOBlocksObserver.h"

NSString *const DGKVOBlocksObservationContext = @"DGKVOBlocksObservationContext";

#if __has_feature(objc_arc)
#define DGKVOBlocksObserversAssociatedObjectsKey ((__bridge const void *)DGKVOBlocksObserversAssociatedObjectsKey)
#endif

@implementation DGKVOBlocksObserver

@synthesize queue = _queue, block = _block;

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_queue release];
    [_block release];
    
    [super dealloc];
}
#endif

- (id)initWithQueue:(NSOperationQueue *)queue block:(DGKVOObserverBlock)block
{
    self = [super init];
    
    if (self) {
#if __has_feature(objc_arc)
        _queue = queue;
#else
        _queue = [queue retain];
#endif
        _block = [block copy];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    if (context == DGKVOBlocksObservationContext) {

        if (self.queue) {
            NSDictionary *copiedChange = [change copy];

            [self.queue addOperationWithBlock: ^ {
                self.block(copiedChange);
            }];
            
#if !__has_feature(objc_arc)
            [copiedChange release];
#endif
        } else {
            self.block(change);
        }

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
