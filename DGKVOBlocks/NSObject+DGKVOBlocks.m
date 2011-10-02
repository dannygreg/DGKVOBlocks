//
//  NSObject+DGKVOBlocks.m
//  DGKVOBlocks
//
//  Created by Danny Greg on 02/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import "NSObject+DGKVOBlocks.h"

#import <objc/runtime.h>

//***************************************************************************

NSString *DGKVOBlocksObservationContext = @"DGKVOBlocksObservationContext";
NSString *const DGKVOBlocksObserversAssociatedObjectsKey = @"DGKVOBlocksObserversAssociatedObjectsKey";

//***************************************************************************

@interface DGKVOBlocksObserver : NSObject 

@property (copy) DGKVOObserverBlock block;

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

//***************************************************************************

@interface NSObject (DGKVOBlocksProperties) 

@property (nonatomic, readonly) NSMutableDictionary *dgkvo_blockObservers;

@end

@implementation NSObject (DGKVOBlocksProperties) 

- (NSMutableDictionary *)dgkvo_blockObservers
{
    NSMutableDictionary *setDict = objc_getAssociatedObject(self, (__bridge const void *)DGKVOBlocksObserversAssociatedObjectsKey);
    if (setDict == nil) {
        NSMutableDictionary *newSetDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, (__bridge const void *)DGKVOBlocksObserversAssociatedObjectsKey, newSetDict, OBJC_ASSOCIATION_RETAIN);
        
        return newSetDict;
    }
    
    return setDict;
}

@end

//***************************************************************************

@implementation NSObject (DGKVOBlocks)

- (id)dgkvo_addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(DGKVOObserverBlock)block
{
    if (block == nil)
        return nil;
    
    DGKVOBlocksObserver *newBlocksObserver = [[DGKVOBlocksObserver alloc] init];
    newBlocksObserver.block = block;
    
    [self addObserver:newBlocksObserver forKeyPath:keyPath options:options context:&DGKVOBlocksObservationContext];
    NSObject *newKey = [[NSProcessInfo processInfo] globallyUniqueString];
    [self.dgkvo_blockObservers setObject:newBlocksObserver forKey:newKey];
    
    return newKey;
}

- (void)dgkvo_removeObserverWithIdentifier:(id)identifier
{
    
}

@end
