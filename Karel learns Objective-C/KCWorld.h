//
//  KCWorld.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCHeadedPosition.h"
#import "KCKarel.h"
#import "KCSize.h"

@class KCKarel;

#pragma mark change of model notifications

//Posted after any change in model
static NSString * KCWorldChangedNotification = @"KCWorldChangedNotification";



@interface KCWorld : NSObject

#pragma mark creation

//format:
//name the property you want to define and in parenthesis the value you want to use
//@"propertyName(propertyContent) propertyName (propertyContent) ...."
//note: spacing outside content does not matter
//note: spacing inside content matters!
//NSString * example = @"size(5 4) speed(0.5) karel(1 4 e KCUnlimited) walls(1 4 s, 2 4 s, 3 4 s, 4 4 w, 4 4 n, 5 4 n) beepers(1 4 1, 2 6 1)";
+ (KCWorld*)worldFromString:(NSString*)description;


//format: @"x1 y1 s, x2 y2 e, x3 y3 s, ..."
+ (NSSet*)wallPositionsFromString:(NSString *)description;

//format: @"x1 y1 count1, x2 y2 count2, ..."
+ (NSDictionary*)beeperDictionaryFromString:(NSString*)description;

#pragma mark world properties

@property (nonatomic, strong) KCSize * size;

- (int)numberOfBeepersAtPosition:(KCPosition*)position;

//count must be positive
- (void)setNumberOfBeepers:(int)count atPosition:(KCPosition*)position;

//only use for creating a new world
@property (nonatomic, strong) NSDictionary * numberOfBeepersAtPositions;


//is there a wall at square position with that orientation
//this method also checks the equivalent side
//this is not the same as calling [[world positionOfWalls] containsObject:position]
- (BOOL)isWallAtHeadedPosition:(KCHeadedPosition*)position;

//contains KCHeadedPositions
@property (nonatomic, strong) NSSet * positionsOfWalls;




#pragma mark turns

//pauses by turnLength time
- (void)nextTurn;

//how long karel should pause before performing the next turn (in seconds)
@property (nonatomic) NSTimeInterval turnLength;


#pragma mark modify karel

//nil if karel not part of world
- (KCHeadedPosition*)positionOfKarel:(KCKarel*)karel;

- (void)addKarel:(KCKarel*)karel atPosition:(KCHeadedPosition*)position;
//karel must be added first
- (void)setPosition:(KCHeadedPosition*)position ofKarel:(KCKarel*)karel;
@end
