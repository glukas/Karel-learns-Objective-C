//
//  KCCountingArtistKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCCountingArtistKarel.h"

@implementation KCCountingArtistKarel

- (void)run
{
    [self.counter pushSlotWithValue:0];
    [self putPinkColorInPalette];
    [self.counter pushSlotWithValue:1];
    [self putYellowColorInPalette];
    
    [self.counter pushSlot];//slot for index of color (push color)
    
    [self pushSizeOfWorld];//push size
    
    while ([self.counter valueAtLastSlot] > 0) {
        
        
        [self.counter pushSlotWithValue:[self.counter valueAtSlotWithInverseIndex:0]];//push size
        [self.counter pushSlotWithValue:[self.counter valueAtSlotWithInverseIndex:2]];//push color
        [self paintSquareUsingColorAndSize];
        
        //switch color
        [self.counter pushSlotWithValue:[self.counter valueAtSlotWithInverseIndex:1]];//push color index
        [self switchColors];
        [self.counter copyLastValueToSlotWithInverseIndex:2];
        [self.counter popSlot];;//pop color index
        
        
        [self moveUpDiagonally];
        
        
        //decrement size
        [self.counter decrementValueAtLastSlot];
        [self.counter decrementValueAtLastSlot];
        
    }
    
    [self.counter popSlot];
    [self.counter popSlot];
}

- (void)moveUpDiagonally
{
    [self move];
    [self turnLeft];
    [self move];
    [self turnRight];
}


- (void)switchColors
{
    if ([self.counter valueAtLastSlot] == 0) {
        [self.counter setValueAtLastSlot:1];
    } else {
        [self.counter setValueAtLastSlot:0];
    }
}

//arguments:
//last one: color
//before last one: size
- (void)paintSquareUsingColorAndSize
{
    [self.counter pushSlot];//loop counter
    
    while ([self.counter valueAtLastSlot] <  4) {
        
        [self.counter pushSlotWithValue:[self.counter valueAtSlotWithInverseIndex:2]];//push size
        [self.counter pushSlotWithValue:[self.counter valueAtSlotWithInverseIndex:2]];//push color
        [self paintLineUsingColorAndLength];
        
        [self turnLeft];
        [self.counter incrementValueAtLastSlot];
    }
    
    [self.counter popSlot];//loop counter
    
    [self.counter popSlot];//arg1
    [self.counter popSlot];//arg2
    
}

//arguments:
//last one: color
//before last one: length
- (void)paintLineUsingColorAndLength
{
    [self.counter pushSlot];
    [self.counter incrementValueAtLastSlot];
    while ([self.counter valueAtLastSlot] <  [self.counter valueAtSlotWithInverseIndex:2]) {
        [self.counter pushSlotWithValue:[self.counter valueAtSlotWithInverseIndex:1]];
        [self paintCornerWithColorFromPaletteUsingCounter];
        [self move];
        [self.counter incrementValueAtLastSlot];
    }
    [self.counter pushSlotWithValue:[self.counter valueAtSlotWithInverseIndex:1]];
    [self paintCornerWithColorFromPaletteUsingCounter];
    
    [self.counter popSlot];//counter
    [self.counter popSlot];//arg1
    [self.counter popSlot];//arg2
}

//arg1: color pallette index
- (void)putPinkColorInPalette
{
    //set color to red
    [self.counter pushSlot];//blue
    while ([self.counter valueAtLastSlot] < 10) {
        [self.counter incrementValueAtLastSlot];
    }
    [self.counter pushSlot];//green
    [self.counter pushSlot];//red
    while ([self.counter valueAtLastSlot] < 10) {
        [self.counter incrementValueAtLastSlot];
    }
    [self setColorUsingCounter];
}

//arg1: color pallette index
- (void)putYellowColorInPalette
{
    //set color to red
    [self.counter pushSlot];//blue
    [self.counter pushSlot];//green
    while ([self.counter valueAtLastSlot] < 10) {
        [self.counter incrementValueAtLastSlot];
    }
    [self.counter pushSlot];//red
    while ([self.counter valueAtLastSlot] < 10) {
        [self.counter incrementValueAtLastSlot];
    }
    [self setColorUsingCounter];
}

- (void)pushSizeOfWorld
{
    [self pushNumberOfFreeSquaresInFront];
    [self.counter incrementValueAtLastSlot];
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
