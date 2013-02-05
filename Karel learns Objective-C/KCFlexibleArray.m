//
//  KCFlexibleArray.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCFlexibleArray.h"
#import "KCMatrix.h"

@interface KCFlexibleArray()
//currently the array is implemented as a 1xn matrix
@property (nonatomic, strong) KCMatrix * internalMatrix;
@end


@implementation KCFlexibleArray

- (KCMatrix *)internalMatrix
{
    if (!_internalMatrix) {
        _internalMatrix = [[KCMatrix alloc] init];
    } return _internalMatrix;
}


- (void)setObject:(id)object atIndex:(NSUInteger)index
{
    KCPosition * position = [[KCPosition alloc] initWithX:1 Y:index+1];
    [self.internalMatrix setObject:object atPosition:position];
}


- (id)objectAtIndex:(NSUInteger)index
{
    KCPosition * position = [[KCPosition alloc] initWithX:1 Y:index+1];
    return [self.internalMatrix objectAtPosition:position];
}

- (NSUInteger)count
{
    return self.internalMatrix.count;
}

@end
