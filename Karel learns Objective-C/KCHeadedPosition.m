//
//  KCHeadedPosition.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCHeadedPosition.h"

@implementation KCHeadedPosition


- (id)initWithPosition:(KCPosition *)position orientation:(KCOrientation)orientation
{
    self = [super initWithX:position.x Y:position.y];
    NSAssert(orientation == north || orientation == east || orientation == west || orientation == south, @"invalid orientation");
    if (self) {
        _orientation = orientation;
    }
    
    return self;
}

+ (KCHeadedPosition*)positionWithX:(int)x Y:(int)y orientation:(KCOrientation)orientation
{
    KCPosition * position = [[KCPosition alloc] initWithX:x Y:y];
    return [[self alloc] initWithPosition:position orientation:orientation];
}

+ (KCHeadedPosition*)headedPositionFromString:(NSString *)description
{
    NSArray * components = [description componentsSeparatedByString:@" "];
    KCPosition * position = [KCPosition positionFromArrayOfComponentStrings:components];
    KCOrientation orientation = [components objectAtIndex:2];
    if ([orientation isEqualToString:north]) {
        orientation = north;
    } else if ([orientation isEqualToString:south]) {
        orientation = south;
    } else if ([orientation isEqualToString:east]) {
        orientation = east;
    } else  if ([orientation isEqualToString:west]) {
        orientation = west;
    }
    return [[self alloc] initWithPosition:position orientation:orientation];
}

- (KCPosition*)asUnheadedPosition
{
    return [[KCPosition alloc] initWithX:self.x Y:self.y];
}

- (KCHeadedPosition*)rotateLeft
{
    KCPosition * pos = [self asUnheadedPosition];
    KCHeadedPosition * left;
    
    if (self.orientation == north) {
        left = [[KCHeadedPosition alloc] initWithPosition:pos orientation:west];
    } else if (self.orientation == west) {
        left = [[KCHeadedPosition alloc] initWithPosition:pos orientation:south];
    } else if (self.orientation == south) {
        left = [[KCHeadedPosition alloc] initWithPosition:pos orientation:east];
    } else {
        left = [[KCHeadedPosition alloc] initWithPosition:pos orientation:north];
    }
    
    return left;
}

- (KCHeadedPosition*)rotateRight
{
    KCPosition * pos = [self asUnheadedPosition];
    KCHeadedPosition * right;
    
    if (self.orientation == north) {
        right = [[KCHeadedPosition alloc] initWithPosition:pos orientation:east];
    } else if (self.orientation == east) {
        right = [[KCHeadedPosition alloc] initWithPosition:pos orientation:south];
    } else if (self.orientation == south) {
        right = [[KCHeadedPosition alloc] initWithPosition:pos orientation:west];
    } else {
        right = [[KCHeadedPosition alloc] initWithPosition:pos orientation:north];
    }
    
    return right;
}

- (KCHeadedPosition*)moveInDirectionOfOrientation
{
    KCHeadedPosition * result;
    if (self.orientation == north) {
        result = [KCHeadedPosition positionWithX:self.x Y:self.y-1 orientation:self.orientation];
    } else if (self.orientation == east) {
        result = [KCHeadedPosition positionWithX:self.x+1 Y:self.y orientation:self.orientation];
    } else if (self.orientation == south) {
        result = [KCHeadedPosition positionWithX:self.x Y:self.y+1 orientation:self.orientation];
    } else {
        result = [KCHeadedPosition positionWithX:self.x-1 Y:self.y orientation:self.orientation];
    }
    return result;
}

- (BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if ([object isKindOfClass:[self class]]) {
        KCHeadedPosition * otherPosition = object;
        if ((otherPosition.x == self.x) && (otherPosition.y == self.y) && (otherPosition.orientation == self.orientation)) {
            result = YES;
        }
        
    }
    return result;
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" %@", self.orientation];
}

- (NSUInteger)hash
{
    return [self.description hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    //KCHeadedPosition * copy = [KCHeadedPosition positionWithX:self.x Y:self.y orientation:self.orientation];
    return self;
}


@end
