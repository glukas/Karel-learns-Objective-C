//
//  KCWorldTest.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 15.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWorldTest.h"
#import "KCWorld.h"

@interface KCWorldTest()
@property (nonatomic, strong) KCWorld * world;
@property (nonatomic) int testSize;
@end

@implementation KCWorldTest

- (void)setUp
{
    [super setUp];
    KCWorld * world = [[KCWorld alloc] init];
    int testSize = 10;
    self.testSize = testSize;
    world.size = [[KCSize alloc] initWithWidth:testSize height:testSize];
    self.world = world;
    srand(10);
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testWorldSizeSet
{
    STAssertTrue((self.world.size.width == self.testSize) && (self.world.size.height == self.testSize), @"size assignment inconsistent");
}

- (void)testWallAdditionAndRemovalConsistent
{
    //Wall test
    ////basic consistency test
    NSMutableSet * walls = [NSMutableSet set];
    for (int i = 1; i <= self.testSize; i++) {
        for (int j = 1; j <= self.testSize; j++) {
            KCHeadedPosition * position = [KCHeadedPosition positionWithX:i Y:j orientation:north];
            [walls addObject:position];
            position = [KCHeadedPosition positionWithX:i Y:j orientation:south];
            [walls addObject:position];
            position = [KCHeadedPosition positionWithX:i Y:j orientation:east];
            [walls addObject:position];
            position = [KCHeadedPosition positionWithX:i Y:j orientation:west];
            [walls addObject:position];
        }
    }
    self.world.positionsOfWalls = walls;
    for (int i = 1; i <= self.testSize; i++) {
        for (int j = 1; j <= self.testSize; j++) {
            KCHeadedPosition * position = [KCHeadedPosition positionWithX:i Y:j orientation:north];
            STAssertTrue([self.world isWallAtHeadedPosition:position], @"basic wall consistency test failed");
            position = [KCHeadedPosition positionWithX:i Y:j orientation:south];
            STAssertTrue([self.world isWallAtHeadedPosition:position], @"basic wall consistency test failed");
            position = [KCHeadedPosition positionWithX:i Y:j orientation:east];
            STAssertTrue([self.world isWallAtHeadedPosition:position], @"basic wall consistency test failed");
            position = [KCHeadedPosition positionWithX:i Y:j orientation:west];
            STAssertTrue([self.world isWallAtHeadedPosition:position], @"basic wall consistency test failed");
            
        }
    }
    
    
}

- (void)testBeeperAdditionAndRemovalConsistent
{
    //test beepers
    ////basic consistency test
    for (int i = 1; i <= self.testSize; i++) {
        for (int j = 1; j <= self.testSize; j++) {
            KCPosition * position = [[KCPosition alloc] initWithX:i Y:j];
            [self.world setNumberOfBeepers:1 atPosition:position];
            //correctly set?
            STAssertTrue([self.world numberOfBeepersAtPosition:position] == 1, @"number of beepers at position wrong: assignment failed?");
            
            //others unaffected:
            for (int k = 1; k <= self.testSize; k++) {
                for (int l = 1; l <= self.testSize; l++) {
                    if (k != i || l != j) {
                        KCPosition * otherposition = [[KCPosition alloc] initWithX:k Y:l];
                        STAssertTrue([self.world numberOfBeepersAtPosition:otherposition] == 0, @"other beeper counts should be unaffected");
                    }
                }
            }
            
            //reset
            [self.world setNumberOfBeepers:0 atPosition:position];
            STAssertTrue([self.world numberOfBeepersAtPosition:position] == 0, @"number of beepers at position wrong: removal failed?");
        }
    }
    
    ////random value test
    KCPosition * position = [[KCPosition alloc] initWithX:1 Y:1];
    int n = 0;
    for (int i = 0; i < 40; i++) {
        n = rand();
        [self.world setNumberOfBeepers:n atPosition:position];
        STAssertTrue([self.world numberOfBeepersAtPosition:position] == n, @"number of beepers at position wrong: random value assignment to 1, 1 failed");
    }
    //alternate creation test
    NSDictionary * beepers = [KCWorld beeperDictionaryFromString:@"1 1 1, 2 2 2, 3 3 3, 4 4 4"];
    self.world.numberOfBeepersAtPositions = beepers;
    STAssertTrue([self.world numberOfBeepersAtPosition:[KCPosition positionFromString:@"1 1"]] == 1, @"alternate creation test: consistency: failed");
    STAssertTrue([self.world numberOfBeepersAtPosition:[KCPosition positionFromString:@"2 2"]] == 2, @"alternate creation test: consistency: failed");
    STAssertTrue([self.world numberOfBeepersAtPosition:[KCPosition positionFromString:@"3 3"]] == 3, @"alternate creation test: consistency: failed");
    STAssertTrue([self.world numberOfBeepersAtPosition:[KCPosition positionFromString:@"4 4"]] == 4, @"alternate creation test: consistency: failed");
    
}

@end
