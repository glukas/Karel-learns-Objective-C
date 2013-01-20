//
//  KCHeadedPositionTest.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 15.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCHeadedPositionTest.h"
#import "KCHeadedPosition.h"

@implementation KCHeadedPositionTest

- (void)t_positionsWithX:(int)x Y:(int)y
{
    NSArray * allorientations = [NSArray arrayWithObjects:south, north, east, west, nil];
    for (KCOrientation orientation in allorientations) {
    
        KCPosition * position = [[KCPosition alloc] initWithX:x Y:y];
        KCHeadedPosition * headedP = [[KCHeadedPosition alloc] initWithPosition:position orientation:orientation];
        STAssertEquals(x, headedP.x, @"KCHeadedPosition: creation inconsistent");
        STAssertEquals(y, headedP.y, @"KCHeadedPosition: creation inconsistent");
        STAssertEquals(orientation, headedP.orientation, @"KCHeadedPosition: creation inconsistent");
        
        headedP = [KCHeadedPosition positionWithX:x Y:y orientation:orientation];
        STAssertEquals(x, headedP.x, @"KCPosition: creation using [KCHeadedPosition positionWithX:x Y:y orientation:orientation] inconsistent");
        STAssertEquals(y, headedP.y, @"KCPosition: creation using [KCHeadedPosition positionWithX:x Y:y orientation:orientation] inconsistent");
        STAssertEquals(orientation, headedP.orientation, @"KCHeadedPosition: creation using [KCHeadedPosition positionWithX:x Y:y orientation:orientation] inconsistent");
        
        headedP = [KCHeadedPosition headedPositionFromString:[NSString stringWithFormat:@"%d %d %@", x, y, orientation]];
        STAssertEquals(x, headedP.x, @"KCHeadedPosition: creation inconsistent");
        STAssertEquals(y, headedP.y, @"KCHeadedPosition: creation inconsistent");
        STAssertEquals(orientation, headedP.orientation, @"KCHeadedPosition: creation inconsistent");
        
    
        STAssertTrue([[headedP copy] isEqual:headedP], @"copy should equal the original");
        STAssertTrue([[headedP copy] hash] == [headedP hash], @"copies should have the same hash value");
    }
}


- (void)testPositionCreationConsistent
{
    //basic consistency
    for (int i = 1; i < 10; i++) {
        [self t_positionsWithX:i Y:i];
    }

    //random values
    int x = 0;
    int y = 0;
    for (int i = 0; i < 10; i++) {
        x = rand();
        y = rand();
        [self t_positionsWithX:x Y:y];
    }
}

- (void)testHeadedPositionCanBeUsedAsAKeyInADictionary
{
    NSMutableDictionary * testDictionary = [NSMutableDictionary dictionary];
    int testSize = 40;
    for (int i = 1; i < testSize; i++) {
        for (int j = 1; j < testSize; j++) {
            KCHeadedPosition * pos = [KCHeadedPosition positionWithX:i Y:j orientation:north];
            [testDictionary setObject:[NSNumber numberWithInt:[pos hash]] forKey:pos];
        }
    }
    
    for (int i = 1; i < testSize; i++) {
        for (int j = 1; j < testSize; j++) {
            KCHeadedPosition * pos = [KCHeadedPosition positionWithX:i Y:j orientation:north];
            STAssertTrue([testDictionary objectForKey:pos] != nil, @"value key pair present");
            STAssertTrue([[testDictionary objectForKey:pos] isEqual:[NSNumber numberWithInt:[pos hash]]], @"value key pair consistent");
        }
    }
}


@end