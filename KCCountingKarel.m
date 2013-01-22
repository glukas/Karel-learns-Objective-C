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
    
    [self moveByHalfTheValueAtTheLastSlotOfTheCounter];
    
    [self.counter popSlot];
}


- (void)pushNumberOfFreeSquaresInFront
{
    [self.counter pushSlot];
    
    while ([self frontIsClear]) {
        [self.counter incrementValueAtLastSlot];
        [self move];
    }
    
    [self goBackByLastValueOnCounter];
    
}

- (void)moveByHalfTheValueAtTheLastSlotOfTheCounter
{
    [self.counter pushSlotWithValue:[self.counter valueAtLastSlot]];
    while ([self.counter valueAtLastSlot] > 0) {
        [self move];
        [self.counter decrementValueAtLastSlot];
        [self.counter decrementValueAtLastSlot];
    }
    [self.counter popSlot];
}


- (void)goBackByLastValueOnCounter
{
    [self.counter pushSlotWithValue:[self.counter valueAtLastSlot]];
    
    [self turnAround];
    while ([self.counter valueAtLastSlot] > 0) {
        [self move];
        [self.counter decrementValueAtLastSlot];
    }
    [self turnAround];
    
    [self.counter popSlot];
}

@end
