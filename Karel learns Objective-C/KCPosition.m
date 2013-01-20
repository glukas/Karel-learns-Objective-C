//
//  KCPosition.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCPosition.h"

@implementation KCPosition

- (id)initWithX:(int)x Y:(int)y
{
    self = [super init];
    NSAssert(x > 0, @"position positive");
    NSAssert(y > 0, @"position positive");
    if (self) {
        _x = x;
        _y = y;
    } return self;
}

+ (KCPosition*)positionFromString:(NSString *)description
{
    NSArray * components = [description componentsSeparatedByString:@" "];
    KCPosition * result;
    if (components.count == 2) {
        result = [self positionFromArrayOfComponentStrings:components];
    }
    return result;
}

+ (KCPosition*)positionFromArrayOfComponentStrings:(NSArray *)components
{
    int x = [[components objectAtIndex:0] intValue];
    int y = [[components objectAtIndex:1] intValue];
    KCPosition * result = [[KCPosition alloc] initWithX:x Y:y];
    //NSLog(@"new position: %@", result);
    return result;
}

- (BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if ([object isKindOfClass:[self class]]) {
        KCPosition * otherPosition = object;
        if ((otherPosition.x == self.x) && (otherPosition.y == self.y)) {
            result = YES;
        }
        
    }
    return result;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%d %d", self.x, self.y];
}

- (NSUInteger)hash
{
    return [[NSNumber numberWithInt:self.x*10000+self.y] hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    //KCPosition * copy = [[KCPosition alloc] initWithX:self.x Y:self.y];
    return self;
}

@end
