//
//  KCStoneMasonKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 16.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCStoneMasonKarel.h"

@implementation KCStoneMasonKarel

- (void)run
{
    while ([self frontIsClear]) {
        [self repairColumn];
        [self advanceToNextColumn];
    }
    [self repairColumn];
}

- (void)repairColumn
{
    [self turnLeft];
    [self ascendAndRepairColumn];
    [self turnAround];
    [self moveToWall];
    [self turnLeft];
}

- (void)turnAround
{
    [self turnLeft];
    [self turnLeft];
}

- (void)turnRight
{
    [self turnLeft];
    [self turnLeft];
    [self turnLeft];
}

- (void)ascendAndRepairColumn
{
    while ([self frontIsClear]) {
        [self checkCurrentSquare];
        [self move];
    }
    [self checkCurrentSquare];
}

- (void)checkCurrentSquare
{
    if ([self noBeepersPresent]) {
        [self putBeeper];
    }
}

- (void)moveToWall
{
    while ([self frontIsClear]) {
        [self move];
    }
}

- (void)advanceToNextColumn
{
    for (int i = 0; i < 4; i++) {
        [self move];
    }
}

@end
