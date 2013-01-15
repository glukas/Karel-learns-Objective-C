//
//  KCWorld.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWorld.h"

@interface KCWorld()
//values: KCHeadedPosition key: KCKarel objects
@property (nonatomic, strong) NSDictionary * karelPositions;
@end


@implementation KCWorld
@synthesize numberOfBeepersAtPositions = _numberOfBeepersAtPositions;

- (NSDictionary *)numberOfBeepersAtPositions
{
    if (!_numberOfBeepersAtPositions) {
        _numberOfBeepersAtPositions = [NSDictionary dictionary];
    } return _numberOfBeepersAtPositions;
}

- (void)setNumberOfBeepersAtPositions:(NSDictionary *)numberOfBeepersAtPositions
{
    if (_numberOfBeepersAtPositions != numberOfBeepersAtPositions) {
        _numberOfBeepersAtPositions = numberOfBeepersAtPositions;
        [self postChangeNotification];
    }
}

- (void)setPositionsOfWalls:(NSSet *)positionsOfWalls
{
    if (positionsOfWalls != _positionsOfWalls) {
        _positionsOfWalls = positionsOfWalls;
        [self postChangeNotification];
    }
}

- (void)postChangeNotification
{
    if ([[NSThread currentThread] isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KCWorldChangedNotification object:self userInfo:nil];
    } else {
        [self performSelectorOnMainThread:@selector(postChangeNotification) withObject:nil waitUntilDone:NO];
    }
}

+ (NSString *)findDescriptionOfPropertyWithName:(NSString *)propertyName inWorldDescription:(NSString *)description
{
    NSString * result;
    NSRange keywordRange = [description rangeOfString:propertyName];
    
    NSRange startOfParenthesis = [description rangeOfString:@"(" options:NSCaseInsensitiveSearch range:NSMakeRange(keywordRange.location, description.length-keywordRange.location)];
    NSRange endOfParenthesis = [description rangeOfString:@")" options:NSCaseInsensitiveSearch range:NSMakeRange(startOfParenthesis.location, description.length-startOfParenthesis.location)];
    
    NSRange resultRange = NSMakeRange(startOfParenthesis.location+startOfParenthesis.length, endOfParenthesis.location-startOfParenthesis.location-endOfParenthesis.length);
    result = [description substringWithRange:resultRange];
    return result;
}

+ (KCWorld*)worldFromString:(NSString *)description
{
    KCWorld * result = [[KCWorld alloc] init];
    //set size
    NSString * sizeString = [self findDescriptionOfPropertyWithName:@"size" inWorldDescription:description];
    result.size = [KCSize sizeFromString:sizeString];
    NSString * speedString = [self findDescriptionOfPropertyWithName:@"speed" inWorldDescription:description];
    result.turnLength = [speedString doubleValue];
    
    
    
    return result;
}

+ (NSDictionary*)beeperDictionaryFromString:(NSString *)description
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];

    //separate individual beepers
    NSArray * beepers = [description componentsSeparatedByString:@", "];
    
    for (NSString * beeperDescription in beepers) {
        NSArray * beeperComponents = [beeperDescription componentsSeparatedByString:@" "];
        KCPosition * position = [KCPosition positionFromArrayOfComponentStrings:beeperComponents];
        NSNumber * count = [NSNumber numberWithInt:[[beeperComponents objectAtIndex:2] intValue]];
        [result setObject:count forKey:position];
    }
    
    return [result copy];
}

+ (NSSet*)wallPositionsFromString:(NSString *)description
{
    NSMutableSet * result  = [NSMutableSet set];
    //separate individual walls
    NSArray * wallDescriptions = [description componentsSeparatedByString:@", "];
    //create each wall position
    for (NSString * wallDescription in wallDescriptions) {
        [result addObject:[KCHeadedPosition headedPositionFromString:wallDescription]];
    }
    return [result copy];
}


- (NSDictionary *)karelPositions
{
    if (!_karelPositions) {
        _karelPositions = [NSDictionary dictionary];
    } return _karelPositions;
}

- (void)addKarel:(KCKarel *)karel atPosition:(KCHeadedPosition *)position
{
    [self setPosition:position ofKarel:karel];
}

- (void)setPosition:(KCHeadedPosition *)position ofKarel:(KCKarel *)karel
{
    NSMutableDictionary * mutableCopy = [self.karelPositions mutableCopy];
    [mutableCopy setObject:position forKey:karel];
    self.karelPositions = [mutableCopy copy];
    [self postChangeNotification];
}

- (KCHeadedPosition*)positionOfKarel:(KCKarel *)karel
{
    KCHeadedPosition * result = [self.karelPositions objectForKey:karel];
    return result;
}

- (int)numberOfBeepersAtPosition:(KCPosition *)position
{
    NSNumber * number = [self.numberOfBeepersAtPositions objectForKey:position];
    int result;
    if (number) {
        result = [number intValue];
    } else {
        result = 0;
    }
    return result;
}

- (void)setNumberOfBeepers:(int)count atPosition:(KCPosition *)position
{
    NSAssert(count >= 0, @"beeper count must be positive");
    if (count == 0) {
        NSMutableDictionary * mutableCopy = [self.numberOfBeepersAtPositions mutableCopy];
        [mutableCopy removeObjectForKey:position];
        self.numberOfBeepersAtPositions = [mutableCopy copy];
    } else {
        NSMutableDictionary * mutableCopy = [self.numberOfBeepersAtPositions mutableCopy];
        [mutableCopy setObject:[NSNumber numberWithInt:count] forKey:position];
        self.numberOfBeepersAtPositions = [mutableCopy copy];
    }
    [self postChangeNotification];
}


- (BOOL)isWallAtHeadedPosition:(KCHeadedPosition *)position
{
    BOOL result = NO;
    if ([self.positionsOfWalls containsObject:position]) {
        result = YES;
    } else {
        KCHeadedPosition * equivalentPosition = [self equivalentWallPosition:position];
        result = [self.positionsOfWalls containsObject:equivalentPosition];
    }
    return result;
    
}

- (KCHeadedPosition*)equivalentWallPosition:(KCHeadedPosition*)position
{
    KCHeadedPosition * result;
    if (position.orientation == east) {
        result = [KCHeadedPosition positionWithX:position.x+1 Y:position.y orientation:west];
    } else if (position.orientation == west) {
        result = [KCHeadedPosition positionWithX:position.x-1 Y:position.y orientation:east];
    } else if (position.orientation == north) {
        result = [KCHeadedPosition positionWithX:position.x Y:position.y-1 orientation:south];
    } else if (position.orientation == south) {
        result = [KCHeadedPosition positionWithX:position.x Y:position.y+1 orientation:north];
    }
    
    return result;
}


- (void)nextTurn
{
    [NSThread sleepForTimeInterval:self.turnLength];
}

@end