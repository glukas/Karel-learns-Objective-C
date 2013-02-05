//
//  KCKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCKarel.h"
#import "NSString+SubstringBetweenDelimiters.h"

@interface KCKarel()

@property (nonatomic) KCCount numberOfBeepersInBag;
@property (nonatomic) int identification;

@end

@implementation KCKarel


- (id)initWithWorld:(KCWorld *)world numberOfBeepers:(KCCount)count
{
    self = [super init];
    if (self) {
        _world = world;
        _numberOfBeepersInBag = count;
        _identification = rand();
    }
    return self;
}



- (void)run
{
    
}

- (void)turnLeft
{
    [self.world nextTurn];
    [self.world setPosition:[[self front] rotateLeft] ofKarel:self];
    
}

- (void)move
{
    [self.world nextTurn];
    KCHeadedPosition * currentPosition = [self front];
    if ([self.world isWallAtHeadedPosition:currentPosition]) {
        NSLog(@"position: %@", currentPosition);
        NSAssert(false, @"moved into wall!");
    }
    [self.world setPosition:[currentPosition moveInDirectionOfOrientation] ofKarel:self];
}

#pragma mark painting

- (void)paintCorner:(UIColor *)color
{
    [self.world setColor:color atPosition:[self here]];
}

#pragma mark beepers

- (void)pickBeeper
{
    if (self.numberOfBeepersInBag != KCUnlimited) {
        self.numberOfBeepersInBag++;
    }
    KCPosition * here = [self here];
    int count = [self.world numberOfBeepersAtPosition:here];
    if (count == 0) {
        NSAssert(false, @"tried to pick beeper, but none present");
    } else {
        [self.world setNumberOfBeepers:count-1 atPosition:here];
    }
   
}

- (void)putBeeper
{
    if (self.numberOfBeepersInBag != KCUnlimited) {
        if (self.numberOfBeepersInBag > 0) {
            self.numberOfBeepersInBag--;
        } else {
            NSAssert(false, @"no beepers in bag, put tried to put beeper");
        }
    }
    KCPosition * here = [self here];
    [self.world setNumberOfBeepers:[self.world numberOfBeepersAtPosition:here]+1 atPosition:here];
    
}

- (BOOL)beepersInBag
{
    return self.numberOfBeepersInBag > 0;
}

- (BOOL)noBeepersInBag
{
    return ![self beepersInBag];
}

- (BOOL)beepersPresent
{
    return [self.world numberOfBeepersAtPosition:[self here]] > 0;
}

- (BOOL)noBeepersPresent
{
    return ![self beepersPresent];
}

#pragma mark walls


- (BOOL)frontIsBlocked
{
    return [self.world isWallAtHeadedPosition:[self front]];
}

- (BOOL)frontIsClear
{
    return ![self frontIsBlocked];
}

- (KCPosition*)here
{
    return [[self.world positionOfKarel:self] asUnheadedPosition];
}

- (KCHeadedPosition *)front
{
    return [self.world positionOfKarel:self];
}

- (KCHeadedPosition*)left
{
    return [[self front] rotateLeft];
}

- (KCHeadedPosition*)right
{
    return [[self front] rotateRight];
}

- (BOOL)leftIsBlocked
{
    return [self.world isWallAtHeadedPosition:[self left]];
}

- (BOOL)leftIsClear
{
    return ![self leftIsBlocked];
}

- (BOOL)rightIsBlocked
{
    return [self.world isWallAtHeadedPosition:[self right]];
}

- (BOOL)rightIsClear
{
    return ![self rightIsBlocked];
}

- (BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if ([object isKindOfClass:[KCKarel class]]) {
        if ([object identification] == [self identification]) {
            result = YES;
        }
    }
    return result;
}

- (NSUInteger)hash
{
    return self.identification;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (BOOL)facingEast
{
    return [self front].orientation == east;
}

- (BOOL)facingWest
{
    return [self front].orientation == west;
}

- (BOOL)facingNorth
{
    return [self front].orientation == north;
}

- (BOOL)facingSouth
{
    return [self front].orientation == south;
}


#pragma mark creation and export


- (NSString *)asString
{
    NSString * result = [NSString stringWithFormat:@"class[%@] beeperbag[%d] position[%@]", NSStringFromClass([self class]), self.numberOfBeepersInBag, [[self.world positionOfKarel:self] asString]];
    return result;
}

+ (KCKarel *)karelFromString:(NSString *)karelString inWorld:(KCWorld*)world
{
    NSString * karelPositionString = [karelString substringAfterKeyword:@"position" betweenLeftDelimiter:@"[" rightDelimiter:@"]"];
    NSString * karelBeeperBagString = [karelString substringAfterKeyword:@"beeperbag" betweenLeftDelimiter:@"[" rightDelimiter:@"]"];
    NSString * karelClass = [karelString substringAfterKeyword:@"class" betweenLeftDelimiter:@"[" rightDelimiter:@"]"];
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
        [world addKarel:karel atPosition:[KCHeadedPosition positionFromString:karelPositionString]];
    }
    return karel;
}

@end
