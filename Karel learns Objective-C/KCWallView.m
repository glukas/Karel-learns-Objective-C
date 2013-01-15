//
//  KCWallView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWallView.h"

@interface KCWallView()
@property (nonatomic, weak) UIImageView * imageView;
@end

@implementation KCWallView

- (id)initWithLength:(CGFloat)length orientation:(KCOrientation)orientation
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage * image;
    UIImageView * view;
    if (self) {
        self.backgroundColor = [UIColor redColor];
        if (orientation == south || orientation == north) {
            //landscape
            image = [UIImage imageNamed:@"square_wall_landscape"];
        } else {
            //portrait
            image = [UIImage imageNamed:@"square_wall_portrait"];
        }
        view = [[UIImageView alloc] initWithImage:image];
        float ratio = length/MAX(view.frame.size.height, view.frame.size.width);
        self.imageView = view;
        self.frame = CGRectMake(0, 0, view.frame.size.width*ratio, view.frame.size.height*ratio);
        [self addSubview:view];
    } return self;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}
     
- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
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
