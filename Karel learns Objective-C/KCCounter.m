//
//  KCCounter.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCCounter.h"

@interface KCCounter()

@property (nonatomic, strong) NSArray * internalCount;
@property (nonatomic, weak) KCKarel * karel;

@end



@implementation KCCounter

- (id)initWithKarel:(KCKarel *)karel
{
    self = [super init];
    if (self) {
        _karel = karel;
    } return self;
}

- (NSArray *)internalCount
{
    if (!_internalCount) {
        _internalCount = [NSArray array];
    } return _internalCount;
}


- (void)pushSlot
{
    NSMutableArray * mutableCopy = [self.internalCount mutableCopy];
    
    [mutableCopy addObject:[NSNumber numberWithInt:0]];
    self.internalCount = [mutableCopy copy];
    [self.karel.world nextTurn];
}


- (void)popSlot
{
    NSAssert([self notEmpty], @"precondition: not empty");
    NSMutableArray * mutableCopy = [self.internalCount mutableCopy];
    [mutableCopy removeLastObject];
    self.internalCount = [mutableCopy copy];
    [self.karel.world nextTurn];
}



- (int)valueAtLastSlot
{
    NSAssert([self notEmpty], @"precondition: not empty");
    NSLog(@"counter: valueAtLastSlot: %d", [[self.internalCount lastObject] intValue]);
    [self.karel.world nextTurn];
    return [[self.internalCount lastObject] intValue];
}

- (void)setValueAtLastSlot:(int)value
{
    NSAssert([self notEmpty], @"precondition: not empty");
    NSMutableArray * mutableCopy = [self.internalCount mutableCopy];
    
    [mutableCopy setObject:[NSNumber numberWithInt:value] atIndexedSubscript:self.internalCount.count-1];
    self.internalCount = [mutableCopy copy];
    [self.karel.world nextTurn];
}


- (int)valueAtSlotWithIndex:(int)index
{
    return [[self.internalCount objectAtIndex:index] intValue];
}


- (BOOL)empty
{
    return self.internalCount.count == 0;
}

- (BOOL)notEmpty
{
    return ![self empty];
}


- (int)numberOfSlots
{
    return self.internalCount.count;
}
@end
