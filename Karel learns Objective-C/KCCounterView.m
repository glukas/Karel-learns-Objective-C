//
//  KCCounterView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCCounterView.h"
#import "KCCounterSlotView.h"
#import "KCFlexibleArray.h"

@interface KCCounterView()

@property (nonatomic, strong) KCFlexibleArray * slotViews;

@property (nonatomic) int currentNumberOfSlots;

@end




@implementation KCCounterView

- (KCFlexibleArray *)slotViews
{
    if (!_slotViews) {
        _slotViews = [[KCFlexibleArray alloc] init];
    } return _slotViews;
}

- (void)layoutSubviews
{
    CGRect slotFrame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    KCCounterSlotView * slot;
    for (int i = 0; i < self.currentNumberOfSlots; i++) {
        slot = [self.slotViews objectAtIndex:i];
        slot.frame = slotFrame;
        slotFrame.origin.x = slotFrame.origin.x + self.frame.size.height;
    }
}


- (void)reloadSlotAtIndex:(int)index
{
    KCCounterSlotView * slot = [self.slotViews objectAtIndex:index];
    if (!slot) {
        slot = [[KCCounterSlotView alloc] init];
        slot.backgroundColor = [UIColor darkGrayColor];
        [self.slotViews setObject:slot atIndex:index];
        [self addSubview:slot];
    } else {
        slot.hidden = NO;
    }
    slot.value = [self.datasource valueAtSlotWithIndex:index forCounterView:self];
}

- (void)reloadData
{
    self.backgroundColor = [UIColor darkGrayColor];
    int numberOfSlots = [self.datasource numberOfSlotsForCounterView:self];
    self.currentNumberOfSlots = numberOfSlots;
    
    //hide extra slots
    for (int i = numberOfSlots; i < self.slotViews.count; i++) {
        [[self.slotViews objectAtIndex:i] setHidden:YES];
    }
    
    
    //update slots
    for (int i = 0; i < numberOfSlots; i++) {
        [self reloadSlotAtIndex:i];
    }
    
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
