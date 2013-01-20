//
//  KCSquareView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCSquareView.h"

UIImage * __bgImage = nil;
UIImage * __beeperImage = nil;

@interface KCSquareView()

@property (nonatomic, weak) UIImageView * bgView;

@property (nonatomic, weak) UIImageView * beeperView;
@property (nonatomic, weak) UILabel * beeperCountLabel;

@end


@implementation KCSquareView

- (UIImageView*)bgView
{
    if (!_bgView) {
        if (!__bgImage) {
            __bgImage = [UIImage imageNamed:@"square_128_bg"];
        }
        UIImageView * bgView = [[UIImageView alloc] initWithImage:__bgImage];
        bgView.frame = self.bounds;
        [self addSubview:bgView];
        _bgView = bgView;
    } return _bgView;
}

- (UIImageView*)beeperView
{
    if (!_beeperView) {
        if (!__beeperImage) {
            __beeperImage = [UIImage imageNamed:@"square_128_beeper"];
        }
        UIImageView * beeperView = [[UIImageView alloc] initWithImage:__beeperImage];
        [self addSubview:beeperView];
        _beeperView = beeperView;
    } return _beeperView;
}

- (UILabel*)beeperCountLabel
{
    if (!_beeperCountLabel) {
        UILabel * beeperLabel = [[UILabel alloc] initWithFrame:self.bounds];
        beeperLabel.opaque = NO;
        beeperLabel.backgroundColor = nil;
        beeperLabel.textAlignment = NSTextAlignmentCenter;
        beeperLabel.contentMode = UIViewContentModeCenter;
        beeperLabel.adjustsFontSizeToFitWidth = YES;
        //beeperLabel.frame = CGRectMake(self.frame.size.width/4, 0, self.frame.size.width/2, self.frame.size.height);
        [self addSubview:beeperLabel];
        _beeperCountLabel = beeperLabel;
    } return _beeperCountLabel;
}

- (void)setNumberOfBeepers:(int)numberOfBeepers
{
    NSAssert(numberOfBeepers >= 0, @"numbers of beepers positive");

    if (numberOfBeepers == 0) {
        _beeperView.hidden = YES;
    } else {
        self.beeperView.hidden = NO;
    }
    
    if (numberOfBeepers <= 1) {
        _beeperCountLabel.hidden = YES;
    } else {
        self.beeperCountLabel.hidden = NO;
        self.beeperCountLabel.text = [NSString stringWithFormat:@"%d", numberOfBeepers];
    }
}

- (void)layoutSubviews
{
    for (UIView * view in self.subviews) {
        view.frame = self.bounds;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView.hidden = NO;
    }
    return self;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    if (!backgroundColor) {
        self.bgView.hidden = NO;
    } else {
        self.bgView.hidden = YES;
    }
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
