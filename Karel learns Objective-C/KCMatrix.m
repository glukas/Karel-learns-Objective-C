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

- (void)setObject:(id)object AtPosition:(KCPosition *)position
{
    [self.positionObjectDictionary setObject:object forKey:position];
}

- (id)objectAtPosition:(KCPosition *)position
{
    return [self.positionObjectDictionary objectForKey:position];
}




@end
