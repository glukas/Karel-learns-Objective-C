//
//  KCMatrix.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCMatrix.h"

@interface KCMatrix()
@property (nonatomic, strong) KCSize * size;

//contains positions as keys and objects as values
@property (nonatomic, strong) NSMutableDictionary * positionObjectDictionary;


@end

@implementation KCMatrix

- (NSMutableDictionary *)positionObjectDictionary
{
    if (!_positionObjectDictionary) {
        _positionObjectDictionary = [NSMutableDictionary dictionaryWithCapacity:self.size.width+self.size.height];
    } return _positionObjectDictionary;
}

- (id)initWithSize:(KCSize *)size
{
    self = [super init];
    if (self) {
        _size = size;
    } return self;
}

- (NSUInteger)count
{
    return self.positionObjectDictionary.count;
}

- (void)setObject:(id)object AtPosition:(KCPosition *)position
{
    [self.positionObjectDictionary setObject:object forKey:position];
}

- (id)objectAtPosition:(KCPosition *)position
{
    return [self.positionObjectDictionary objectForKey:position];
}



- (BOOL)isEqual:(id)object
{
    BOOL result = NO;
    if ([object isKindOfClass:[self class]]) {
        result = (self.hash == [object hash]);
    } return result;
}

- (NSUInteger)hash
{
    return self.positionObjectDictionary.hash;
}


@end
