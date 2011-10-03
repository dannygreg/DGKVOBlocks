//
//  DGKVOBlocksObserver.h
//  DGKVOBlocks
//
//  Created by Hamish Allan on 03/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DGKVOBlocksObservationContext;

typedef void (^DGKVOObserverBlock)(NSDictionary *change);

@interface DGKVOBlocksObserver : NSObject

@property (readonly) NSOperationQueue *queue;
@property (readonly) DGKVOObserverBlock block;

- (id)initWithQueue:(NSOperationQueue *)queue block:(DGKVOObserverBlock)block;

@end

