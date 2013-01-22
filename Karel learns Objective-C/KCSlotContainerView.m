//
//  KCSlotContainerView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCSlotContainerView.h"
#import "KCFlexibleArray.h"

@interface KCSlotContainerView()
@property (nonatomic, strong) KCFlexibleArray * slotViews;

@property (nonatomic) int currentNumberOfSlots;
@end

@implementation KCSlotContainerView

- (KCFlexibleArray *)slotViews
{
    if (!_slotViews) {
        _slotViews = [[KCFlexibleArray alloc] init];
    } return _slotViews;
}

- (void)layoutSubviews
{
    CGRect slotFrame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    UIView * slot;
    for (int i = 0; i < self.currentNumberOfSlots; i++) {
        slot = [self.slotViews objectAtIndex:i];
        slot.frame = slotFrame;
        slotFrame.origin.x = slotFrame.origin.x + self.frame.size.height;
    }
}


- (void)reloadSlotAtIndex:(int)index
{
    UIView * slot = [self.slotViews objectAtIndex:index];
    if (!slot) {
        slot = [self.datasource slotViewForContainer:self atIndex:index];
        [self.slotViews setObject:slot atIndex:index];
        [self addSubview:slot];
    }
    
    slot.hidden = NO;
    
    if ([self.datasource respondsToSelector:@selector(updateSlotView:fromContainer:atIndex:)]) {
        [self.datasource updateSlotView:slot fromContainer:self atIndex:index];
    }
}

- (void)reloadData
{
    //self.backgroundColor = [UIColor darkGrayColor];
    int numberOfSlots = [self.datasource numberOfSlotsForContainer:self];
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
