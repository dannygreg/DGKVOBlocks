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

#import <objc/runtime.h>

#import "NSObject+DGKVOBlocks.h"

//***************************************************************************

static NSString *const DGKVOBlocksBlockObserversKey = @"DGKVOBlocksBlockObserversKey";
static NSString *const DGKVOBlocksKeyPathKey = @"DGKVOBlocksKeyPathKey";

#if __has_feature(objc_arc)
#define DGKVOBlocksBlockObserversKey ((__bridge const void *)DGKVOBlocksBlockObserversKey)
#define DGKVOBlocksKeyPathKey ((__bridge const void *)DGKVOBlocksKeyPathKey)
#endif

//***************************************************************************

@implementation NSObject (DGKVOBlocks)

- (NSMutableSet *)dgkvo_blockObservers
{
    @synchronized (self) {
        
        NSMutableSet *set = objc_getAssociatedObject(self, DGKVOBlocksBlockObserversKey);
        
        if (set == nil) {
            set = [NSMutableSet set];
            objc_setAssociatedObject(self, DGKVOBlocksBlockObserversKey, set, OBJC_ASSOCIATION_RETAIN);
        }
        
        return set;
    }
}

- (id)dgkvo_addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options queue:(NSOperationQueue *)queue usingBlock:(DGKVOObserverBlock)block
{
    NSAssert(block != nil, @"You cannot add a block observer without a block.");
    
    DGKVOBlocksObserver *observer = [DGKVOBlocksObserver observerWithQueue:queue block:block];

    objc_setAssociatedObject(observer, DGKVOBlocksKeyPathKey, keyPath, OBJC_ASSOCIATION_COPY);

    [self addObserver:observer forKeyPath:keyPath options:options context:observer.context];

    @synchronized (self.dgkvo_blockObservers) {
        [self.dgkvo_blockObservers addObject:observer];
    }
    
    return observer;
}

- (void)dgkvo_removeObserver:(id)observer
{
    NSString *keyPath = objc_getAssociatedObject(observer, DGKVOBlocksKeyPathKey);
    [self removeObserver:observer forKeyPath:keyPath];
    
    @synchronized (self.dgkvo_blockObservers) {
        [self.dgkvo_blockObservers removeObject:observer];
    }
}

@end
