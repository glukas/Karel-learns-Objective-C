//
//  KCCounterSlotView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCCounterSlotView.h"

@interface KCCounterSlotView()
@property (nonatomic, weak) UILabel * label;

@end

@implementation KCCounterSlotView


- (UILabel *)label
{
    if (!_label) {
        UILabel * label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:20];
        label.opaque = NO;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = nil;
        [self addSubview:label];
        self.label = label;
    } return _label;
}

- (void)layoutSubviews
{
    self.label.frame = self.bounds;
}

- (void)setValue:(int)value
{
    _value = value;
    self.label.text = [NSString stringWithFormat:@"%i", value];
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
