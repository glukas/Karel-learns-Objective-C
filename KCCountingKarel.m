//
//  KCCountingKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCCountingKarel.h"

@implementation KCCountingKarel


- (void)run
{
    
    [self pushNumberOfFreeSquaresInFront];
    
    [self.counter setValueAtLastSlot:[self.counter valueAtLastSlot]/2];
    
    [self moveByLastValueOnCounter];
    
    [self.counter pushSlot];
}


- (void)pushNumberOfFreeSquaresInFront
{
    [self.counter pushSlot];
    
    while ([self frontIsClear]) {
        [self.counter setValueAtLastSlot:[self.counter valueAtLastSlot]+1];
        [self move];
    }
    
    [self goBackByLastValueOnCounter];
    
}



- (void)moveByLastValueOnCounter
{
    for (int i = 0; i < [self.counter valueAtLastSlot]; i++) {
        [self move];
    }
}


- (void)goBackByLastValueOnCounter
{
    [self turnAround];
    for (int i = 0; i < [self.counter valueAtLastSlot]; i++) {
        [self move];
    }
    [self turnAround];
}

@end
