//
//  KCSuperKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 19.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCSuperKarel.h"

@implementation KCSuperKarel


- (void)turnRight
{
    [self turnLeft];
    [self turnLeft];
    [self turnLeft];
}


- (void)turnAround
{
    [self turnLeft];
    [self turnLeft];
}

@end
