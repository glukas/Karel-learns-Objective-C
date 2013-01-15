//
//  KCPositionTest.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 15.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCPositionTest.h"
#import "KCPosition.h"

@implementation KCPositionTest

- (void)t_positionsWithX:(int)x Y:(int)y
{
    KCPosition * position = [[KCPosition alloc] initWithX:x Y:y];
    STAssertEquals(x, position.x, @"KCPosition: creation using alloc init with x y failed");
    STAssertEquals(y, position.y, @"KCPosition: creation using alloc init with x y failed");
    
    position = [KCPosition positionFromString:[NSString stringWithFormat:@"%d %d", x, y]];
    STAssertEquals(x, position.x, @"KCPosition: creation using positionFromString failed");
    STAssertEquals(y, position.y, @"KCPosition: creation using positionFromString failed");
    
    NSArray * components = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", x],[NSString stringWithFormat:@"%d", y], nil];
    position = [KCPosition positionFromArrayOfComponentStrings:components];
    STAssertEquals(x, position.x, @"KCPosition: creation using positionFromArrayOfComponentsStrings failed");
    STAssertEquals(y, position.y, @"KCPosition: creation using positionFromArrayOfComponentsStrings failed");
    
    STAssertTrue([[position copy] isEqual:position], @"copy should equal the original");
    STAssertTrue([[position copy] hash] == [position hash], @"copies should have the same hash value");
}


- (void)testPositionCreationConsistent
{
    //basic consistency
    for (int i = 0; i < 10; i++) {
        [self t_positionsWithX:i Y:i];
    }
    
    //random values
    int x = 0;
    int y = 0;
    for (int i = 0; i < 30; i++) {
        x = rand();
        y = rand();
        [self t_positionsWithX:x Y:y];
    }
}

- (void)testPositionIsUsableInASet
{
    NSMutableSet * testSet = [NSMutableSet set];
    int testSize = 20;
    for (int i = 0; i < testSize; i++) {
        for (int j = 0; j < testSize; j++) {
            KCPosition * pos = [[KCPosition alloc] initWithX:i Y:j];
            [testSet addObject:pos];
        }
    }
    
    for (int i = 0; i < testSize; i++) {
        for (int j = 0; j < testSize; j++) {
            KCPosition * pos = [[KCPosition alloc] initWithX:i Y:j];
            STAssertTrue([testSet containsObject:pos], @"NSSet did not contain position, but actually should have");
        }
    }
}


- (void)testPositionIsUsableAsAKeyForADictionary
{
    NSMutableDictionary * testDictionary = [NSMutableDictionary dictionary];
    int testSize = 20;
    for (int i = 0; i < testSize; i++) {
        for (int j = 0; j < testSize; j++) {
            KCPosition * pos = [[KCPosition alloc] initWithX:i Y:j];
            [testDictionary setObject:[NSNumber numberWithInt:[pos hash]] forKey:pos];
        }
    }
    
    for (int i = 0; i < testSize; i++) {
        for (int j = 0; j < testSize; j++) {
            KCPosition * pos = [[KCPosition alloc] initWithX:i Y:j];
            STAssertTrue([testDictionary objectForKey:pos] != nil, @"value key pair present");
            STAssertTrue([[testDictionary objectForKey:pos] isEqual:[NSNumber numberWithInt:[pos hash]]], @"value key pair consistent");
        }
    }
}

@end
