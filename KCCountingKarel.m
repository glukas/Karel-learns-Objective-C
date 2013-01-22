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
    
    //set color at index 0 to red
    [self.counter pushSlot];//index
    [self.counter pushSlot];//blue
    [self.counter pushSlot];//green
    [self.counter pushSlot];//blue
    while ([self.counter valueAtLastSlot] < 10) {
        [self.counter incrementValueAtLastSlot];
    }
    [self setColorUsingCounter];
    
    //paint corner using color at index 0
    [self.counter pushSlot];//index
    [self paintCornerWithColorFromPaletteUsingCounter];
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
