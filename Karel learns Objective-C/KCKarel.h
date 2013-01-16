//
//  KCKarel.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCWorld.h"


typedef int KCCount;
static KCCount KCUnlimited = INT_MAX;

@class KCWorld;

@interface KCKarel : NSObject <NSCopying>

- (id)initWithWorld:(KCWorld *)world numberOfBeepers:(KCCount)count;

//subclass Karel and overwrite run
//to run karel, execute on a background thread, otherwise your main thread will be blocked
- (void)run;

//basic operations:

- (void)move;
- (void)turnLeft;
- (void)pickBeeper;
//must have at least one beeper in bag
- (void)putBeeper;

- (BOOL)beepersPresent;
- (BOOL)noBeepersPresent;

@property (readonly) BOOL beepersInBag;
@property (readonly) BOOL noBeepersInBag;

- (BOOL)frontIsClear;
- (BOOL)leftIsClear;
- (BOOL)rightIsClear;

- (BOOL)frontIsBlocked;
- (BOOL)leftIsBlocked;
- (BOOL)rightIsBlocked;

@end
