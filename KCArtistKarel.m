//
//  KCArtistKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 20.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCArtistKarel.h"

@implementation KCArtistKarel

- (void)run
{
    UIColor * pink = [UIColor magentaColor];
    UIColor * yellow = [UIColor yellowColor];
    
    UIColor * currentColor = pink;
    
    int currentSize = [self numberOfFreeSquaresInFront];
    
    while (currentSize > 0) {
        
        [self paintSquareOfSize:currentSize withColor:currentColor];
        
        [self moveUpDiagonally];
        
        //change color
        if ([currentColor isEqual:pink]) {
            currentColor = yellow;
        } else {
            currentColor = pink;
        }
        
        //change size
        currentSize = currentSize-2;
    }
    
    
}


- (void)moveUpDiagonally
{
    [self move];
    [self turnLeft];
    [self move];
    [self turnRight];
}


- (void)paintSquareOfSize:(int)size withColor:(UIColor*)color
{
    
    for (int i=0; i < 4; i = i+1) {
        
        [self paintLineOfLength:size withColor:color];
        [self turnLeft];
        
    }
    
}


- (void)paintLineOfLength:(int)length withColor:(UIColor*)color
{
    [self paintCorner:color];
    for (int i=0; i < length-1; i++) {
        [self paintCorner:color];
        [self move];
    }
}


- (int)numberOfFreeSquaresInFront
{
    int numberOfFreeSquares = 1;
    
    while ([self frontIsClear]) {
        [self move];
        numberOfFreeSquares = numberOfFreeSquares+1;
    }
    
    [self goBackBy:numberOfFreeSquares];
    
    return numberOfFreeSquares;
}


- (void)goBackBy:(int)numberOfSquares
{
    [self turnAround];
    for (int i = 0; i < numberOfSquares-1; i++) {
        [self move];
    }
    [self turnAround];
}

@end
