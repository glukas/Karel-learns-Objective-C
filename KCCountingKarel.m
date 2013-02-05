//
//  KCCountingKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCCountingKarel.h"

@implementation KCCountingKarel


- (void)run//todo: cleanup: use uniform argument passing policy
{
    [self pushNumberOfFreeSquaresInFront];
    
    [self putBeepersUsingCounter];
    
    [self moveByHalfTheValueAtTheLastSlotOfTheCounter];
    
    [self.counter popSlot];
    
    //set color at index 0 to red
    [self.counter pushSlot];//index
    [self pushRedColor];
    [self setColorUsingCounter];
    
    //paint corner using color at index 0
    [self.counter pushSlot];//index
    [self paintCornerWithColorFromPaletteUsingCounter];
}

- (void)pushRedColor
{
    [self.counter pushSlot];//blue
    [self.counter pushSlot];//green
    [self.counter pushSlot];//red
    while ([self.counter valueAtLastSlot] < 10) {
        [self.counter incrementValueAtLastSlot];
    }
}

//looks at last value of the counter and puts that many beepers down
- (void)putBeepersUsingCounter
{
    [self.counter pushSlotWithValue:[self.counter valueAtLastSlot]];
    while ([self.counter valueAtLastSlot] > 0) {
        [self putBeeper];
        [self.counter decrementValueAtLastSlot];
    }
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

//precondition: counter not empty, there must be enough space in front of karel
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


//precondition: counter not empty, there must be enough space behind karel
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
