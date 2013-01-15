//
//  KCTestKarelBahaviourInWorld.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 15.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCTestKarelBahaviourInWorld.h"
#import "KCWorld.h"

@interface KCTestKarelBahaviourInWorld()
@property (nonatomic, strong) KCWorld * world;
@property (nonatomic, strong) KCKarel * karel;
@end


@implementation KCTestKarelBahaviourInWorld



- (void)setUp
{
    [super setUp];
    KCWorld * world = [[KCWorld alloc] init];
    int testSize = 10;
    world.size = [[KCSize alloc] initWithWidth:testSize height:testSize];
    self.world = world;
    self.karel = [[KCKarel alloc] initWithWorld:self.world numberOfBeepers:KCUnlimited];
    [self.world addKarel:self.karel atPosition:[KCHeadedPosition positionWithX:1 Y:1 orientation:east]];
    srand(10);
}


- (void)testAssigningPositionsConsistent
{
    KCHeadedPosition * position;
    for (int i = 1; i <= self.world.size.width; i++) {
        for (int j = 1; j<= self.world.size.height; j++) {
            position = [KCHeadedPosition positionWithX:i Y:j orientation:north];
            [self.world setPosition:position ofKarel:self.karel];
            STAssertEqualObjects(position, [self.world positionOfKarel:self.karel], @"assigning positions to karel inconsistent");
        }
    }
}

- (void)testFrontIsBlockedIfActuallyWallThere
{
    
}

- (void)testBeepersPresentIfActuallyBeeperThere
{
    
}





@end
