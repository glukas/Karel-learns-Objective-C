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

@property (nonatomic, weak) KCWorld * world;

//subclass Karel and overwrite run
- (void)run;

//basic operations:

- (void)move;//precondition: frontIsClear
- (void)turnLeft;
- (void)pickBeeper;//precondition: beepersPresent
- (void)putBeeper;//precondition: beepersInBag

//colors

- (void)paintCorner:(UIColor*)color;

//conditions

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


//orientation

- (BOOL)facingEast;
- (BOOL)facingWest;
- (BOOL)facingNorth;
- (BOOL)facingSouth;


@end
