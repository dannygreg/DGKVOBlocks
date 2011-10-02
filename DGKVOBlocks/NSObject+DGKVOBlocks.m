//*******************************************************************************

// Copyright (c) 2011 Danny Greg

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// Created by Danny Greg on 02/10/2011

//*******************************************************************************

#import "NSObject+DGKVOBlocks.h"

#import <objc/runtime.h>

//***************************************************************************

NSString *DGKVOBlocksObservationContext = @"DGKVOBlocksObservationContext";
NSString *const DGKVOBlocksObserversAssociatedObjectsKey = @"DGKVOBlocksObserversAssociatedObjectsKey";

//***************************************************************************

@interface DGKVOBlocksObserver : NSObject 

@property (copy) DGKVOObserverBlock block;
@property (copy) NSString *keyPath;

@end

@implementation DGKVOBlocksObserver

@synthesize block = _block;
@synthesize keyPath = _keyPath;

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

@property (readonly) NSMutableArray *dgkvo_blockObservers;

@end

@implementation NSObject (DGKVOBlocksProperties) 

- (NSMutableArray *)dgkvo_blockObservers
{
    @synchronized (self) {
        
#if __has_feature(objc_arc)
        NSMutableArray *setDict = objc_getAssociatedObject(self, (__bridge const void *)DGKVOBlocksObserversAssociatedObjectsKey);
#else
        NSMutableArray *setDict = objc_getAssociatedObject(self, DGKVOBlocksObserversAssociatedObjectsKey);
#endif

        if (setDict == nil) {
            NSMutableArray *newSetDict = [NSMutableArray array];
            objc_setAssociatedObject(self, (__bridge const void *)DGKVOBlocksObserversAssociatedObjectsKey, newSetDict, OBJC_ASSOCIATION_RETAIN);
            
            return newSetDict;
        }
        
        return setDict; 
    }
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
    newBlocksObserver.keyPath = keyPath;
    
    [self addObserver:newBlocksObserver forKeyPath:keyPath options:options context:&DGKVOBlocksObservationContext];
    
    @synchronized (self.dgkvo_blockObservers) {
        [self.dgkvo_blockObservers addObject:newBlocksObserver];
    }
    
#if !__has_feature(objc_arc)
    [newBlocksObserver release];
#endif
    
    return newBlocksObserver;
}

- (void)dgkvo_removeObserverWithIdentifier:(id)identifier
{
    //Now in ARC and GC just removing this reference should be enough to kill the observation
    [self removeObserver:identifier forKeyPath:[identifier keyPath]];
    
    @synchronized (self.dgkvo_blockObservers) {
        [self.dgkvo_blockObservers removeObjectIdenticalTo:identifier];
    }
}

@end
