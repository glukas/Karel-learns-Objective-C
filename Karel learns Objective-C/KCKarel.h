//
//  KCKarel.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCWorld.h"
#import "KCCounter.h"
#import "KCColorPalette.h"

typedef int KCCount;
static KCCount KCUnlimited = INT_MAX;

@class KCWorld;
@class KCCounter;

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

//first value: address of color (0-5)
- (void)paintCornerWithColorFromPaletteUsingCounter;

//first value: red (0-10)
//second value: green(0-10)
//third value: blue (0-10)
//fourth value: address of color (0-5);
- (void)setColorUsingCounter;


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


@property (readonly, strong) KCCounter * counter;
@property (readonly) KCColorPalette * colorPalette;

@end
