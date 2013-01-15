//
//  KCBeeperPickingKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 15.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCBeeperPickingKarel.h"

@implementation KCBeeperPickingKarel

- (void)run
{
    [self move];
    [self move];
    [self pickBeeper];
    [self turnLeft];
    [self move];
    [self turnRight];
    [self move];
    [self move];
}



- (void)turnRight
{
    [self turnLeft];
    [self turnLeft];
    [self turnLeft];
}

@end
