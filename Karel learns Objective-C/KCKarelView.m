//
//  KCKarelView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 15.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCKarelView.h"
#import <QuartzCore/QuartzCore.h>

@interface KCKarelView()
@property (nonatomic, weak) UIImageView * imageView;
@end

@implementation KCKarelView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage * image = [UIImage imageNamed:@"karel_128"];
        UIImageView * view = [[UIImageView alloc] initWithImage:image];
        self.imageView = view;
        [self addSubview:self.imageView];
        [self setNeedsLayout];
        
    }
    return self;
}

- (void)setOrientation:(KCOrientation)orientation
{
    CGAffineTransform transform;
    if (orientation == east) {
        transform = CGAffineTransformIdentity;
    } else if (orientation == south) {
        transform = CGAffineTransformMakeRotation(M_PI*0.5);
    } else if (orientation == west) {
        transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        transform = CGAffineTransformMakeRotation(M_PI*1.5);
    }
    [self.imageView.layer setAffineTransform:transform];
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
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
