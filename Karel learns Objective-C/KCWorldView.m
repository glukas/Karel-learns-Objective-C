//
//  KCWorldView.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWorldView.h"
#import "KCMatrix.h"
#import "KCSquareView.h"
#import "KCWallView.h"
#import "KCKarelView.h"

@interface KCWorldView()
@property (nonatomic) CGSize squareSize;
@property (nonatomic, strong) KCMatrix * squareViews;
@property (nonatomic, strong) KCSize * currentSizeOfWorld;
@property (nonatomic, strong) NSMutableSet * walls;
@property (nonatomic) CGPoint contentOffset;

@property (nonatomic, weak) KCKarelView * karelView;
@end


@implementation KCWorldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (NSMutableSet*)walls
{
    if (!_walls) {
        _walls = [NSMutableSet set];
    } return _walls;
}

- (KCKarelView*)karelView
{
    if (!_karelView) {
        KCKarelView * karel =  [[KCKarelView alloc] initWithFrame:CGRectMake(0, 0, self.squareSize.width, self.squareSize.height)];
        [self addSubview:karel];
        _karelView = karel;
    } return _karelView;
}


- (void)reloadSquareAtPosition:(KCPosition *)position
{
    KCSquareView * square = [self.squareViews objectAtPosition:position];
    if (!square) {
        CGRect sqrect = CGRectMake((position.x-1)*self.squareSize.width+self.contentOffset.x, (position.y-1)*self.squareSize.height+self.contentOffset.y, self.squareSize.width, self.squareSize.height);
        square= [[KCSquareView alloc] initWithFrame:sqrect];
        [self addSubview:square];
        [self.squareViews setObject:square AtPosition:position];
    }
    square.numberOfBeepers = [self.datasource numberOfBeepersAtPosition:position forWorldView:self];
}

- (void)reloadWorld
{
    self.backgroundColor = [UIColor darkGrayColor];
    //todo: what if sizeOfWorld changes?
    KCSize * sizeOfWorld = [self.datasource sizeOfWorldForWorldView:self];
    self.currentSizeOfWorld = sizeOfWorld;
    
    if ([self.currentSizeOfWorld isEqual:sizeOfWorld]) {
        [self clearSquareViews];
    }
    
    if (!self.squareViews) {
        self.squareViews = [[KCMatrix alloc] initWithSize:sizeOfWorld];
    }
    
    float sqsize = self.frame.size.width / sizeOfWorld.width;
    self.squareSize = CGSizeMake(sqsize, sqsize);
    float resultingHeight = self.squareSize.height*self.currentSizeOfWorld.height;
    self.contentOffset = CGPointMake(0, (self.frame.size.height-resultingHeight)/2);
    
    for (int row = 1; row <= sizeOfWorld.height; row++) {
        for (int column = 1; column <= sizeOfWorld.width; column++) {
            KCPosition * position = [[KCPosition alloc] initWithX:column Y:row];
            [self reloadSquareAtPosition:position];
        }
        
    }

    [self reloadKarel];
    [self reloadWalls];
    
    
}

- (void)clearSquareViews
{
    //todo:
}

- (void)reloadWalls
{
    [self removeAllWalls];
    NSSet * positionOfWalls = [self.datasource positionsOfWallsForWorldView:self];
    
    for (KCHeadedPosition * position in positionOfWalls) {
        [self addWallAtPosition:position];
    }
}

- (void)removeAllWalls
{
    for (KCWallView * wall in self.walls) {
        [wall removeFromSuperview];
    }
    [self.walls removeAllObjects];
}

- (CGPoint)viewPositionOfWall:(KCWallView*)wall fromGamePosition:(KCHeadedPosition*)position
{
    float x = self.contentOffset.x+position.x*self.squareSize.width;
    float y = self.contentOffset.y+position.y*self.squareSize.height;
    
    //correct positioning depending on orientation
    if (position.orientation == south || position.orientation == north) {
        x = x-self.squareSize.width;
        y = y-wall.frame.size.height/2-(position.orientation == north)*self.squareSize.height;
    } else {
        x = x-wall.frame.size.width/2-(position.orientation == west)*self.squareSize.width;
        y = y-self.squareSize.height;
    }
    
    return CGPointMake(x, y);
}


- (void)addWallAtPosition:(KCHeadedPosition*)position
{
    KCWallView * wall = [[KCWallView alloc] initWithLength:self.squareSize.width orientation:position.orientation];
    [self addSubview:wall];
    CGPoint vpoint = [self viewPositionOfWall:wall fromGamePosition:position];
    
    wall.frame = CGRectMake(vpoint.x, vpoint.y, wall.frame.size.width, wall.frame.size.height);
    [self.walls addObject:wall];
}


- (CGPoint)positionOfKarelInViewfromGamePosition:(KCHeadedPosition*)position
{
    CGPoint result;
    
    result.x = self.contentOffset.x+(position.x-1)*self.squareSize.width;
    result.y = self.contentOffset.y+(position.y-1)*self.squareSize.height;
    
    return result;
}



- (void)reloadKarel
{
    KCHeadedPosition * position= [self.datasource positionOfKarelForWorldView:self];
    
    
    CGPoint positionInView = [self positionOfKarelInViewfromGamePosition:position];
    self.karelView.frame = CGRectMake(positionInView.x, positionInView.y, self.squareSize.width, self.squareSize.height);
    self.karelView.orientation = position.orientation;
    self.karelView.hidden = !position;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    
}*/


@end
