//
//  KCWallView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWallView.h"

UIImage * __square_wall_landscape_image = nil;
UIImage * __square_wall_portrait_image = nil;

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
        if (orientation == south || orientation == north) {
            //landscape
            if (!__square_wall_landscape_image) {
                __square_wall_landscape_image = [UIImage imageNamed:@"square_wall_landscape"];
            }
            image = __square_wall_landscape_image;
        } else {
            //portrait
            if (!__square_wall_portrait_image) {
                __square_wall_portrait_image = [UIImage imageNamed:@"square_wall_portrait"];
            }
            image = __square_wall_portrait_image;
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
