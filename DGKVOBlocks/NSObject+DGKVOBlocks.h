//
//  NSObject+DGKVOBlocks.h
//  DGKVOBlocks
//
//  Created by Danny Greg on 02/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DGKVOObserverBlock)(NSDictionary *change);

@interface NSObject (DGKVOBlocks)

- (id)dgkvo_addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(DGKVOObserverBlock)block;
- (void)dgkvo_removeObserverWithIdentifier:(id)identifier;

@end
