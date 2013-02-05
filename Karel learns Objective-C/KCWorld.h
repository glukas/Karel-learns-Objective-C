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
static NSString * const KCWorldChangedNotification = @"KCWorldChangedNotification";
//the userInfo dictionary contains:
//an NSSet with KCPositions of all the modified positions
//important: directly setting the properties will not cause a message to be sent
static NSString * const KCWorldChangedNotificationModifiedPositionsKey = @"positions";


@interface KCWorld : NSObject

//changing the size of the world has no side effects
//you are responsible for removing objects that are at illegal positions
@property (nonatomic, strong) KCSize * size;


#pragma mark world properties


- (int)numberOfBeepersAtPosition:(KCPosition*)position;

//count must be positive
- (void)setNumberOfBeepers:(int)count atPosition:(KCPosition*)position;


//get the color at that position
//if not color set, return value is nil
- (UIColor*)colorAtPosition:(KCPosition*)position;

//set the color at that position
//setting the color to nil is ok
- (void)setColor:(UIColor *)color atPosition:(KCPosition*)position;



//is there a wall at square position with that orientation
//this method also checks the equivalent side
//this is not the same as calling [[world positionOfWalls] containsObject:position]
- (BOOL)isWallAtHeadedPosition:(KCHeadedPosition*)position;

- (void)addWallAtPosition:(KCHeadedPosition*)position;

- (void)removeWallAtPosition:(KCHeadedPosition*)position;

- (void)addWallBorders;

//contains KCHeadedPositions
@property (readonly) NSSet * wallPositions;

#pragma mark turns

//pauses by turnLength time
//should ne executed on a background thread, otherwise the main thread is blocked
- (void)nextTurn;

//how long karel should pause before performing the next turn (in seconds)
@property (nonatomic) NSTimeInterval turnLength;


#pragma mark modifying karel

//nil if karel not part of world
- (KCHeadedPosition*)positionOfKarel:(KCKarel*)karel;
//empty if none in world
@property (readonly) NSSet * karelsInWorld;
//arguments must be non-nil
- (void)addKarel:(KCKarel*)karel atPosition:(KCHeadedPosition*)position;
//karel must be added first
- (void)setPosition:(KCHeadedPosition*)position ofKarel:(KCKarel*)karel;

- (void)removeKarel:(KCKarel*)karel;

#pragma mark creation

//searches the bundle for a file with the nameOfWorld and calls [world fromString] on the string created from the file
+ (KCWorld*)worldWithName:(NSString*)nameOfWorld;
+ (KCWorld*)worldWithURL:(NSURL*)url;

//format:
//name the property you want to define and in parenthesis the value you want to use
//@"propertyName(propertyContent) propertyName (propertyContent) ...."
//note: spacing outside content does not matter
//note: spacing inside content matters!
//the class argument is optional, default is KCKarel
//NSString * example = @"size(5 4) speed(0.5) karel(position[1 4 e] beeperbag[KCUnlimited] class[KCBeeperPickingKarel]) walls(1 4 s, 2 4 s, 3 4 s, 4 4 w, 4 4 n, 5 4 n) beepers(1 4 1, 2 6 1)";
+ (KCWorld*)worldFromString:(NSString*)description;

- (NSString *)asString;

- (void)saveToURL:(NSURL*)url;//saces the 


@end
