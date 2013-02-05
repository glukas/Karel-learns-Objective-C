//
//  KCArtistKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 20.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//
//  This is an example on how to use methods that take arguments, return results and perform actions

#import "KCArtistKarel.h"

@implementation KCArtistKarel

//precondition: karel is on (1, 1) facing east in a square world
- (void)run
{
    //here we create new color objects
    //to do this, we ask the UIColor class for a new object
    //inside the run mehtod we can now refer to these objects with 'pink' and 'yellow'
    //writing '=' assigns the value on the right side to the variable on the left side (this is called assignemnt)
    //The 'UIColor *' is there to help us remember what kind of object 'pink' refers to
    UIColor * pink = [UIColor magentaColor];
    UIColor * yellow = [UIColor yellowColor];
    
    //now, we need to keep track of the color karel is currently using
    //to do this we create another variable
    UIColor * currentColor = pink;
    
    //now, karel needs to find out how big the world is
    //to do this he calls the numberOfFreeSquaresInFront method and stores the result in a new variable
    //'int' is an interger: a number like -3, 5, 20432345, -12423, 34, 0
    int currentSize = [self numberOfFreeSquaresInFront]+1;
    
    //here comes the actual painting
    //the loop will paint a square and then reduce the currentSize
    //so currentSize will refer to how big the next square should be
    while (currentSize > 0) {
        
        //methods can take arguments
        //here we pass two arguments: currentSize and currentColor
        [self paintSquareOfSize:currentSize withColor:currentColor];
        
        //move one square to the east and one to the north, facing east again
        [self moveUpDiagonally];
        
        
        //change color
        //all objects have the method isEqual:
        //note that we are sending a message to another object here! (currentColor)
        if ([currentColor isEqual:pink]) {
            currentColor = yellow;
        } else {
            currentColor = pink;
        }
        
        //change size
        //note we can do simple arithmetic on numbers by just writing the symbols '+', '-', '*' (multiply), '/'
        currentSize = currentSize-2;
    }
    
    
}


//precondition: facing east at position (a, b), frontIsClear, no wall between (a+1, b) and (a+1, b+1)
//postcondition: facing east at position (a+1, b+1)
- (void)moveUpDiagonally
{
    [self move];
    [self turnLeft];
    [self move];
    [self turnRight];
}


//precondition: enough space to paint the square
//postcondition: on same square with same orientation
- (void)paintSquareOfSize:(int)size withColor:(UIColor*)color
{
    //we further decompose the problem
    for (int i=0; i < 4; i++) {
        
        [self paintLineOfLength:size withColor:color];
        [self turnLeft];
        
    }
    
}

//precondition: enough space to paint
//postcondition: moved length-1 squares, facing same direction
- (void)paintLineOfLength:(int)length withColor:(UIColor*)color
{
    [self paintCorner:color];
    //notice that in order to paint a line of length x, we only move x-1 squares (think fenceposts)
    for (int i=0; i < length-1; i++) {
        [self move];
        [self paintCorner:color];
    }
}

//counts the number of free squares in front
//postcondition: on same square, facing same direction
- (int)numberOfFreeSquaresInFront
{
    //create variable to count
    int numberOfFreeSquares = 0;
    
    //count and move
    while ([self frontIsClear]) {
        [self move];
        numberOfFreeSquares = numberOfFreeSquares+1;
    }
    //return to initial position
    [self goBackBy:numberOfFreeSquares];
    
    //with the return statement you specify what you want to return
    //the method immediately stops executing
    //you therefore want to put the return statement(s) at the bottom of your methods
    //it is also good practice to declare the variable you want to return at the top of the method (as shown in this method)
    return numberOfFreeSquares;
}

//precondition: enough space behind
//postcondition: moved backwards, facing same direction
- (void)goBackBy:(int)numberOfSquares
{
    [self turnAround];
    for (int i = 0; i < numberOfSquares; i++) {
        [self move];
    }
    [self turnAround];
}

@end
