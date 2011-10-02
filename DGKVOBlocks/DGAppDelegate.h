//
//  DGAppDelegate.h
//  DGKVOBlocks
//
//  Created by Danny Greg on 02/10/2011.
//  Copyright (c) 2011 No Thirst Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DGAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, copy) NSString *string;
@property (weak) IBOutlet NSTextField *fibonacciField;
@property (assign) NSUInteger number;

@end
