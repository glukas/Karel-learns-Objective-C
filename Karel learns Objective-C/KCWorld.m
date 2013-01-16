//
//  KCWorld.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWorld.h"
#import "KCStoneMasonKarel.h"
@interface KCWorld()
//values: KCHeadedPosition key: KCKarel objects
@property (nonatomic, strong) NSDictionary * karelPositions;
@end


@implementation KCWorld
@synthesize numberOfBeepersAtPositions = _numberOfBeepersAtPositions;

#pragma mark propertys: lazy instanciation

- (NSSet *)karelsInWorld
{
    NSMutableSet * result = [NSMutableSet set];
    for (KCKarel * karel in self.karelPositions) {
        [result addObject:karel];
    }
    return [result copy];
}

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


- (NSDictionary *)karelPositions
{
    if (!_karelPositions) {
        _karelPositions = [NSDictionary dictionary];
    } return _karelPositions;
}


#pragma mark notifications

- (void)postChangeNotification
{
    if ([[NSThread currentThread] isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KCWorldChangedNotification object:self userInfo:nil];
    } else {
        [self performSelectorOnMainThread:@selector(postChangeNotification) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark karel

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

#pragma mark beepers

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


#pragma mark walls

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


- (void)addWallBorders
{
    NSMutableSet * borders = [[NSMutableSet alloc] initWithCapacity:(2*self.size.width+2*self.size.height)];
    KCHeadedPosition * position;
    //add walls for north and south
    for (int i=1; i <= self.size.width; i++) {
        position = [KCHeadedPosition positionWithX:i Y:1 orientation:north];
        [borders addObject:position];
        position = [KCHeadedPosition positionWithX:i Y:self.size.height orientation:south];
        [borders addObject:position];
    }
    //add walls for west and east
    for (int i=1; i <= self.size.height; i++) {
        position = [KCHeadedPosition positionWithX:1 Y:i orientation:west];
        [borders addObject:position];
        position = [KCHeadedPosition positionWithX:self.size.width Y:i orientation:east];
        [borders addObject:position];
    }
    self.positionsOfWalls = [borders setByAddingObjectsFromSet:self.positionsOfWalls];
}


#pragma mark turn

- (void)nextTurn
{
    [NSThread sleepForTimeInterval:self.turnLength];
}


#pragma mark creation

+ (KCWorld*)worldWithName:(NSString *)nameOfWorld
{
    KCWorld * result;
    NSString * path = [[NSBundle mainBundle] pathForResource:nameOfWorld ofType:@"kcw"];
    NSString * worldDescription = [NSString stringWithContentsOfFile:path encoding:NSUnicodeStringEncoding error:nil];
    if (worldDescription) {
        result = [self worldFromString:worldDescription];
    }
    return result;
}

+ (NSString *)substringAfterKeyword:(NSString *)keyword betweenLeftDelimiter:(NSString*)leftDelimiter rightDelimiter:(NSString *)rightDelimiter ofString:(NSString*)original;
{
    NSString * result;
    NSRange keywordRange = [original rangeOfString:keyword options:NSCaseInsensitiveSearch];
    if (keywordRange.location != NSNotFound) {
        NSRange startOfParenthesis = [original rangeOfString:leftDelimiter options:NSCaseInsensitiveSearch range:NSMakeRange(keywordRange.location, original.length-keywordRange.location)];
        NSRange endOfParenthesis = [original rangeOfString:rightDelimiter options:NSCaseInsensitiveSearch range:NSMakeRange(startOfParenthesis.location, original.length-startOfParenthesis.location)];
        
        NSRange resultRange = NSMakeRange(startOfParenthesis.location+startOfParenthesis.length, endOfParenthesis.location-startOfParenthesis.location-endOfParenthesis.length);
        result = [original substringWithRange:resultRange];
    }
    return result;
}

+ (NSString *)findDescriptionOfPropertyWithName:(NSString *)propertyName inWorldDescription:(NSString *)description
{
    return [self substringAfterKeyword:propertyName betweenLeftDelimiter:@"(" rightDelimiter:@")" ofString:description];
}

+ (KCWorld*)worldFromString:(NSString *)description
{
    KCWorld * result = [[KCWorld alloc] init];
    //set size
    NSString * sizeString = [self findDescriptionOfPropertyWithName:@"size" inWorldDescription:description];
    result.size = [KCSize sizeFromString:sizeString];
    NSString * speedString = [self findDescriptionOfPropertyWithName:@"speed" inWorldDescription:description];
    result.turnLength = [speedString doubleValue];
    NSString * wallString = [self findDescriptionOfPropertyWithName:@"walls" inWorldDescription:description];
    result.positionsOfWalls = [self wallPositionsFromString:wallString];
    NSString * beeperString = [self findDescriptionOfPropertyWithName:@"beepers" inWorldDescription:description];
    result.numberOfBeepersAtPositions = [self beeperDictionaryFromString:beeperString];
    
    //create karel from string
    NSString * karelString = [self findDescriptionOfPropertyWithName:@"karel" inWorldDescription:description];
    NSString * karelPositionString = [self substringAfterKeyword:@"position" betweenLeftDelimiter:@"[" rightDelimiter:@"]" ofString:karelString];
    NSString * karelBeeperBagString = [self substringAfterKeyword:@"beeperbag" betweenLeftDelimiter:@"[" rightDelimiter:@"]" ofString:karelString];
    NSString * karelClass = [self substringAfterKeyword:@"class" betweenLeftDelimiter:@"[" rightDelimiter:@"]" ofString:karelString];
    if (karelClass == nil) {
        karelClass = NSStringFromClass([KCKarel class]);
    }
    KCCount beeperBagCount;
    if ([karelBeeperBagString isEqualToString:@"KCUnlimited"]) {
        beeperBagCount = KCUnlimited;
    } else {
        beeperBagCount = [karelBeeperBagString intValue];
    }
    
    KCKarel * karel = [[NSClassFromString(karelClass) alloc] initWithWorld:result numberOfBeepers:beeperBagCount];
    if (karel) {
        [result addKarel:karel atPosition:[KCHeadedPosition headedPositionFromString:karelPositionString]];
    }
    
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
        if (count) {
            [result setObject:count forKey:position];
        }
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


@end