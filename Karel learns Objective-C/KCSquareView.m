//
//  KCSquareView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCSquareView.h"

@interface KCSquareView()

@property (nonatomic, weak) UIImageView * bgView;

@property (nonatomic, weak) UIImageView * beeperView;
@property (nonatomic, weak) UILabel * beeperCountLabel;

@end


@implementation KCSquareView

- (UIImageView*)bgView
{
    if (!_bgView) {
        UIImage * bgImage = [UIImage imageNamed:@"square_128_bg"];
        UIImageView * bgView = [[UIImageView alloc] initWithImage:bgImage];
        bgView.frame = self.bounds;
        [self addSubview:bgView];
        _bgView = bgView;
    } return _bgView;
}

- (UIImageView*)beeperView
{
    if (!_beeperView) {
        UIImage * image = [UIImage imageNamed:@"square_128_beeper"];
        UIImageView * beeperView = [[UIImageView alloc] initWithImage:image];
        beeperView.frame = self.bounds;
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
        beeperLabel.frame = CGRectMake(self.frame.size.width/4, 0, self.frame.size.width/2, self.frame.size.height);
        [self addSubview:beeperLabel];
        _beeperCountLabel = beeperLabel;
    } return _beeperCountLabel;
}

- (void)setNumberOfBeepers:(int)numberOfBeepers
{
    NSAssert(numberOfBeepers >= 0, @"numbers of beepers positive");
    self.beeperView.hidden = (numberOfBeepers == 0);
    self.beeperCountLabel.hidden = (numberOfBeepers <= 1);
    self.beeperCountLabel.text = [NSString stringWithFormat:@"%d", numberOfBeepers];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView.hidden = NO;
        self.backgroundColor = [UIColor blackColor];
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
