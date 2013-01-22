//
//  KCCounter.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCKarel.h"

@class KCKarel;

@interface KCCounter : NSObject

- (id)initWithKarel:(KCKarel*)karel;


- (void)pushSlot;

//precondition: not empty
- (void)popSlot;


//precondition: not empty
- (int)valueAtLastSlot;//value is 0 if no value set

//precondition: not empty
- (void)setValueAtLastSlot:(int)value;


//indeces start with 0
//precondition: index < self.numberOfSlots
- (int)valueAtSlotWithIndex:(int)index;



- (BOOL)empty;

- (BOOL)notEmpty;

- (int)numberOfSlots;

@end
