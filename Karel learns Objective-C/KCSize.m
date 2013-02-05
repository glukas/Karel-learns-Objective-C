//
//  KCSize.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCSize.h"

@implementation KCSize

- (id)initWithWidth:(int)width height:(int)height
{
    self = [super init];
    NSAssert(width > 0, @"width must be positive");
    NSAssert(height > 0, @"height must be positive");
    if (self) {
        _width = width;
        _height = height;
    } return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %d %d", NSStringFromClass([self class]), self.width, self.height];
}

- (BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if ([object isKindOfClass:[KCSize class]]) {
        KCSize * otherObject = object;
        if (otherObject.width == self.width || otherObject.height == self.height) {
            result = YES;
        }
    }
    return result;
}

+ (KCSize*)sizeFromString:(NSString*)description
{
    NSArray * components = [description componentsSeparatedByString:@" "];
    int w = [[components objectAtIndex:0] intValue];
    int h = [[components objectAtIndex:1] intValue];
    return [[KCSize alloc] initWithWidth:w height:h];
}

- (NSString *)asString
{
    return [NSString stringWithFormat:@"%d, %d", self.width, self.height];
}

- (NSUInteger)hash
{
    return [[self description] hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
