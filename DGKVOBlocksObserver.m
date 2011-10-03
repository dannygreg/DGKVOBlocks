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

//  Created by Hamish Allan on 03/10/2011.

//*******************************************************************************

#import "DGKVOBlocksObserver.h"

//***************************************************************************

static NSString *const DGKVOBlocksObservationContext = @"DGKVOBlocksObservationContext";

//***************************************************************************

@implementation DGKVOBlocksObserver

@synthesize queue = _queue, block = _block;

+ (id)observerWithQueue:(NSOperationQueue *)queue block:(DGKVOObserverBlock)block
{
    id observer = [[self alloc] initWithQueue:queue block:block];
#if !__has_feature(objc_arc)
    [observer autorelease];
#endif
    
    return observer;
}

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

- (void *)context
{
    return DGKVOBlocksObservationContext;
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
