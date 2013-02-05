//
//  KCMemoryKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 05.02.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCMemoryKarel.h"

@interface KCMemoryKarel()
@property (nonatomic, strong) KCColorPalette * internalColorPalette;
@end



@implementation KCMemoryKarel


@synthesize counter = _counter;

- (KCCounter *)counter
{
    if (!_counter) {
        _counter = [[KCCounter alloc] initWithKarel:self];
    } return _counter;
}

- (KCColorPalette*)colorPalette
{
    return self.internalColorPalette;
}


- (KCColorPalette*)internalColorPalette
{
    if (!_internalColorPalette) {
        _internalColorPalette = [[KCColorPalette alloc] initWithCapacity:6];
    } return _internalColorPalette;
}

- (void)paintCornerWithColorFromPaletteUsingCounter
{
    int index = [self.counter valueAtLastSlot];
    [self.counter popSlot];
    UIColor * color  = [self.colorPalette colorAtIndex:index];
    [self paintCorner:color];
}


- (void)setColorUsingCounter
{
    int red = [self.counter valueAtLastSlot];
    [self.counter popSlot];
    int green = [self.counter valueAtLastSlot];
    [self.counter popSlot];
    int blue = [self.counter valueAtLastSlot];
    [self.counter popSlot];
    int index = [self.counter valueAtLastSlot];
    [self.counter popSlot];
    
    UIColor * color = [UIColor colorWithRed:red/10.0 green:green/10.0 blue:blue/10.0 alpha:1];
    [self.colorPalette setColor:color atIndex:index];
    
    [self.world nextTurn];
}

@end
