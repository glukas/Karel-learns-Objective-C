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

/*
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self reloadWorld];
}*/


- (void)reloadSquareAtPosition:(KCPosition *)position
{
    KCSquareView * square = [self.squareViews objectAtPosition:position];
    if (!square) {
        CGRect sqrect = [self frameForSquareViewAtPosition:position];
        square= [[KCSquareView alloc] initWithFrame:sqrect];
        [self addSubview:square];
        [self.squareViews setObject:square AtPosition:position];
    } else {
        square.hidden = NO;
    }
    square.backgroundColor = [self.datasource colorForSquareAtPosition:position forWorldView:self];
    square.numberOfBeepers = [self.datasource numberOfBeepersAtPosition:position forWorldView:self];
    [square setNeedsDisplay];
}

- (CGRect)frameForSquareViewAtPosition:(KCPosition*)position
{
    return CGRectMake((position.x-1)*self.squareSize.width+self.contentOffset.x, (position.y-1)*self.squareSize.height+self.contentOffset.y, self.squareSize.width, self.squareSize.height);
}

- (void)layoutSubviews
{
    
    if (!self.squareViews) {
        [self reloadWorld];
    } else {
        [self updateDimensions];
    }
    if (!self.currentSizeOfWorld) return;
    if (self.squareSize.width== 0) return;
    for (int row = 1; row <= self.currentSizeOfWorld.height; row++) {
        for (int column = 1; column <= self.currentSizeOfWorld.width; column++) {
            KCPosition * position = [[KCPosition alloc] initWithX:column Y:row];
            KCSquareView * squareView = [self.squareViews objectAtPosition:position];
            [squareView setFrame:[self frameForSquareViewAtPosition:position]];
        }
    }
}

- (void)updateDimensions
{
    float sqsize = self.bounds.size.width / self.currentSizeOfWorld.width;
    self.squareSize = CGSizeMake(sqsize, sqsize);
    //the resulting height is the height of the playing field
    float resultingHeight = self.squareSize.height*self.currentSizeOfWorld.height;
    //how much the playing field is set off from the top of the view (the field is centered)
    self.contentOffset = CGPointMake(0, (self.frame.size.height-resultingHeight)/2);
}



- (void)reloadWorld
{
    self.backgroundColor = [UIColor darkGrayColor];
    [self clearSquareViews];//need to be performed before the new size is set
    
    KCSize * sizeOfWorld = [self.datasource sizeOfWorldForWorldView:self];
    //update dimensions
    self.currentSizeOfWorld = sizeOfWorld;
    
    if (!sizeOfWorld) return; //0 sizes are not allowed
    
    float sqsize = self.frame.size.width / sizeOfWorld.width;
    
    if (sqsize == 0) return; //0 sizes are not allowed
    
    
    
    if (!self.squareViews) {//create storage if necessary
        self.squareViews = [[KCMatrix alloc] init];
    }
    

    self.squareSize = CGSizeMake(sqsize, sqsize);
    //the resulting height is the height of the playing field 
    float resultingHeight = self.squareSize.height*self.currentSizeOfWorld.height;
    //how much the playing field is set off from the top of the view (the field is centered)
    self.contentOffset = CGPointMake(0, (self.frame.size.height-resultingHeight)/2);

    //update/create square views and update beeper count
    for (int row = 1; row <= sizeOfWorld.height; row++) {
        for (int column = 1; column <= sizeOfWorld.width; column++) {
            KCPosition * position = [[KCPosition alloc] initWithX:column Y:row];
            [self reloadSquareAtPosition:position];
        }
        
    }

    [self reloadKarel];
    
    //remove and re-create all walls
    //this is pretty bruteforce
    [self reloadWalls];
}

//precondition: old size of world (the size you want to clean)
- (void)clearSquareViews
{
    for (int row = 1; row <= self.currentSizeOfWorld.height; row++) {
        for (int column = 1; column <= self.currentSizeOfWorld.width; column++) {
            KCPosition * position = [[KCPosition alloc] initWithX:column Y:row];
            KCSquareView * squareView = [self.squareViews objectAtPosition:position];
            [squareView setHidden:YES];
            //[squareView removeFromSuperview];
        }
    }
    //self.squareViews = nil;
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

- (KCPosition*)positionFromPointInView:(CGPoint)location
{
    KCPosition * position;
    int x;
    int y;
    x = (location.x -self.contentOffset.x)/self.squareSize.width + 1;
    y = (location.y -self.contentOffset.y)/self.squareSize.height + 1;
    if (x > 0 && x <= self.currentSizeOfWorld.width && y > 0 && y <= self.currentSizeOfWorld.height) {
        position = [[KCPosition alloc] initWithX:x Y:y];
    }
    
    return position;
}

- (void)reloadKarel
{
    KCHeadedPosition * position= [self.datasource positionOfKarelForWorldView:self];
    
    if (position) {
        CGPoint positionInView = [self positionOfKarelInViewfromGamePosition:position];
        self.karelView.frame = CGRectMake(positionInView.x, positionInView.y, self.squareSize.width, self.squareSize.height);
        self.karelView.orientation = position.orientation;
        self.karelView.hidden = NO;
        [self bringSubviewToFront:self.karelView];
    } else {
        self.karelView.hidden = YES;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    
}*/


@end
