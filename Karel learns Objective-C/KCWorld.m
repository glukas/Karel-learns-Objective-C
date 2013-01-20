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

//contains KCPositions
@property (nonatomic, strong) NSSet * modifiedPositions;

//contains KCHeadedPositions
@property (nonatomic, strong) NSSet * positionsOfWalls;

//keys: KCPosition values: NSNumber
@property (nonatomic, strong) NSDictionary * numberOfBeepersAtPositions;

@property (nonatomic, strong) NSDictionary * colorsAtPositions;

@end


@implementation KCWorld
@synthesize numberOfBeepersAtPositions = _numberOfBeepersAtPositions;
@synthesize modifiedPositions = _modifiedPositions;

- (void)setModifiedPositions:(NSSet *)modifiedPositions
{
    _modifiedPositions = modifiedPositions;
    if (modifiedPositions.count) {
        [self postChangeNotification];
    }
}

- (NSSet *)wallPositions
{
    return self.positionsOfWalls;
}

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
    }
}

- (void)setPositionsOfWalls:(NSSet *)positionsOfWalls
{
    if (positionsOfWalls != _positionsOfWalls) {
        _positionsOfWalls = positionsOfWalls;
    }
}


- (NSDictionary *)karelPositions
{
    if (!_karelPositions) {
        _karelPositions = [NSDictionary dictionary];
    } return _karelPositions;
}

- (NSSet*)modifiedPositions
{
    if (!_modifiedPositions) {
        _modifiedPositions = [NSSet set];
    } return _modifiedPositions;
}


- (NSDictionary *)colorsAtPositions
{
    if (!_colorsAtPositions) {
        _colorsAtPositions = [NSDictionary dictionary];
    } return _colorsAtPositions;
}

#pragma mark notifications

- (void)postChangeNotification
{
    if ([[NSThread currentThread] isMainThread]) {
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.modifiedPositions, KCWorldChangedNotificationModifiedPositionsKey, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:KCWorldChangedNotification object:self userInfo:userInfo];
    } else {
        [self performSelectorOnMainThread:@selector(postChangeNotification) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark karel

- (void)addKarel:(KCKarel *)karel atPosition:(KCHeadedPosition *)position
{
    [self setPosition:position ofKarel:karel];
}

- (void)setPosition:(KCHeadedPosition *)position ofKarel:(KCKarel *)karel
{
    //note modifications
    KCPosition * previous = [[self.karelPositions objectForKey:karel] asUnheadedPosition];
    if (previous) {
        self.modifiedPositions = [self.modifiedPositions setByAddingObject:previous];
    }
    self.modifiedPositions = [self.modifiedPositions setByAddingObject:[position asUnheadedPosition]];
    
    //change position
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


- (void)removeKarel:(KCKarel *)karel
{
    if (karel) {
        NSMutableDictionary * karelPositionsMutable = [self.karelPositions mutableCopy];
        [karelPositionsMutable removeObjectForKey:karel];
        karel.world = nil;
        self.karelPositions = [karelPositionsMutable copy];
    }
}

#pragma mark colors

- (UIColor*)colorAtPosition:(KCPosition *)position
{
    return [self.colorsAtPositions objectForKey:position];
}


- (void)setColor:(UIColor *)color atPosition:(KCPosition *)position
{
    NSMutableDictionary * mutableDictionary = [self.colorsAtPositions mutableCopy];
    
    if (color) {
        [mutableDictionary setObject:color forKey:position];
    } else {
        [mutableDictionary removeObjectForKey:position];
    }
    self.colorsAtPositions = [mutableDictionary copy];
    
    self.modifiedPositions = [self.modifiedPositions setByAddingObject:position];
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
    self.modifiedPositions = [self.modifiedPositions setByAddingObject:position];
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
    int x;
    int y;
    KCOrientation orientation;
    if (position.orientation == east) {
        x = position.x+1;
        y = position.y;
        orientation = west;
    } else if (position.orientation == west) {
        x = position.x-1;
        y = position.y;
        orientation = east;
    } else if (position.orientation == north) {
        x = position.x;
        y = position.y-1;
        orientation = south;
    } else if (position.orientation == south) {
        x = position.x;
        y = position.y+1;
        orientation = north;
    }
    if (x > 0 && y > 0) {
        result = [KCHeadedPosition positionWithX:x Y:y orientation:orientation];
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

- (void)addWallAtPosition:(KCHeadedPosition *)position
{
    //modify model
    self.positionsOfWalls = [self.positionsOfWalls setByAddingObject:position];
    //mark down change
    self.modifiedPositions = [self.modifiedPositions setByAddingObject:[position asUnheadedPosition]];
}

- (void)removeWallAtPosition:(KCHeadedPosition *)position
{
    //remove position
    NSMutableSet * mutableCopy = [self.positionsOfWalls mutableCopy];
    [mutableCopy removeObject:position];
    self.modifiedPositions = [self.modifiedPositions setByAddingObject:[position asUnheadedPosition]];
    
    //remove equivalent poistion (there are two coordinates mapping to the same wall)
    KCHeadedPosition * equivalentPosition = [self equivalentWallPosition:position];
    if (equivalentPosition) {
        [mutableCopy removeObject:equivalentPosition];
        self.modifiedPositions = [self.modifiedPositions setByAddingObject:equivalentPosition];
    }
    
    //commit changes
    self.positionsOfWalls = [mutableCopy copy];    
}

#pragma mark turn

- (void)nextTurn
{
    //notify subscribers of change
    if (self.modifiedPositions.count) {
        [self postChangeNotification];
    }
    [NSThread sleepForTimeInterval:self.turnLength];
}


#pragma mark creation

+ (KCWorld*)worldWithName:(NSString *)nameOfWorld
{
    KCWorld * result;
    NSString * path = [[NSBundle mainBundle] pathForResource:nameOfWorld ofType:@"kcw"];
    if (!path) {
        path = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:nameOfWorld] stringByAppendingPathExtension:@"kcw"];
    }
    NSString * worldDescription = [NSString stringWithContentsOfFile:path encoding:NSUnicodeStringEncoding error:nil];
    if (worldDescription) {
        result = [self worldFromString:worldDescription];
    }
    return result;
}

+ (KCWorld*)worldWithURL:(NSURL*)url
{
    KCWorld * result;
    NSString * worldDescription = [NSString stringWithContentsOfURL:url encoding:NSUnicodeStringEncoding error:nil];
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
        if (startOfParenthesis.location != NSNotFound) {
            NSRange endOfParenthesis = [original rangeOfString:rightDelimiter options:NSCaseInsensitiveSearch range:NSMakeRange(startOfParenthesis.location, original.length-startOfParenthesis.location)];
            if (endOfParenthesis.location != NSNotFound) {
                NSRange resultRange = NSMakeRange(startOfParenthesis.location+startOfParenthesis.length, endOfParenthesis.location-startOfParenthesis.location-endOfParenthesis.length);
                result = [original substringWithRange:resultRange];
            }
            
        }
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
    if (karelString) {
        [self karelFromString:karelString inWorld:result];
    }
    
    return result;
}

+ (KCKarel *)karelFromString:(NSString *)karelString inWorld:(KCWorld*)world
{
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
    
    KCKarel * karel = [[NSClassFromString(karelClass) alloc] initWithWorld:world numberOfBeepers:beeperBagCount];
    if (karel) {
        [world addKarel:karel atPosition:[KCHeadedPosition headedPositionFromString:karelPositionString]];
    }
    return karel;
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
        KCHeadedPosition * position = [KCHeadedPosition headedPositionFromString:wallDescription];
        if (position) {
            [result addObject:position];
        }
    }
    return [result copy];
}

- (NSString *)asString
{
    NSString * world;
    //define size
    world = [NSString stringWithFormat:@"size(%d %d) ", self.size.width, self.size.height];
    
    //define speed
    world = [world stringByAppendingFormat:@"speed(%f) ", self.turnLength];
    
    //add karel
    //todo
    
    //add walls
    world = [world stringByAppendingFormat:@"walls("];
    for (KCHeadedPosition * position in self.positionsOfWalls) {
        world = [world stringByAppendingFormat:@"%@, ", position.description];
    }
    world = [world substringToIndex:world.length-2];//remove last comma
    world = [world stringByAppendingString:@") "];
    
    //add beepers
    world = [world stringByAppendingString:@"beepers("];
    
    for (KCPosition * position in self.numberOfBeepersAtPositions) {
        int count = [[self.numberOfBeepersAtPositions objectForKey:position] intValue];
        world = [world stringByAppendingFormat:@"%@ %d, ", position.description, count];
        
    }
    world = [world substringToIndex:world.length-2];//remove last comma
    world = [world stringByAppendingString:@") "];
    
    return world;
}


- (void)saveToURL:(NSURL *)url
{
    NSString * asString = [self asString];
    NSError * error;
    [asString writeToURL:url atomically:NO encoding:NSUnicodeStringEncoding error:&error];
    if (error) {
        NSLog(@"%@ %@", NSStringFromClass([self class]), error);
    }
}


@end