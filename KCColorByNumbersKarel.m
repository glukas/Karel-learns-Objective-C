//
//  KCColorByNumbersKarel.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 20.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCColorByNumbersKarel.h"

@implementation KCColorByNumbersKarel

- (void)run
{

    UIColor * currentColor = nil;
    
    BOOL notInCorner = YES;
    
    while (notInCorner) {
        
        if ([self beepersPresent]) {
            currentColor = [self colorFromNumberOfBeepersPresent];
        }
        
        [self paintCorner:currentColor];
        
        notInCorner = [self advance];
        
    }
    
    if ([self beepersPresent]) {
        currentColor = [self colorFromNumberOfBeepersPresent];
    }
    
    [self paintCorner:currentColor];
    
    
}


/*
- (BOOL)notInCorner
{
    BOOL result = NO;
    
    if ([self frontIsClear]) {
        result = YES;
    } else if ([self facingEast]) {
        
        if ([self leftIsClear]) {
            result = YES;
        }

        
    } else if ([self facingWest]) {
        if ([self rightIsClear]) {
            result = YES;
        }
    }
    return result;
}*/


- (BOOL)advance
{
    BOOL result = YES;
    
    if ([self frontIsClear]) {
        [self move];
    } else if ([self facingEast]) {
     
        if ([self leftIsClear]) {
            [self flipUpLeftwards];
        }
        
    } else if ([self facingWest]) {
        if ([self rightIsClear]) {
            [self flipUpRightwards];
        }

    } else {
        result = NO;
    }
    
    return result;
}

- (void)flipUpRightwards
{
    [self turnRight];
    [self move];
    [self turnRight];
}

- (void)flipUpLeftwards
{
    [self turnLeft];
    [self move];
    [self turnLeft];
}


- (UIColor*)colorFromNumberOfBeepersPresent
{
    int colorIndex = 0;
    
    while ([self beepersPresent]) {
        [self pickBeeper];
        colorIndex = colorIndex+1;
    }
    UIColor * result = [self colorWithIndex:colorIndex];
    
    return result;
}


- (UIColor *)colorWithIndex:(int)colorIndex
{
    UIColor * result = nil;
    
    if (colorIndex == 1) {
        result = [UIColor blackColor];
    } else if (colorIndex == 2) {
        result = [UIColor whiteColor];
    } else if (colorIndex == 3) {
        result  = [UIColor redColor];
    } else if (colorIndex == 4) {
        result = [UIColor blueColor];
    } else if (colorIndex == 5) {
        result = [UIColor greenColor];
    } else if (colorIndex == 6) {
        result = [UIColor yellowColor];
    } else if (colorIndex == 7) {
        result = [UIColor colorWithRed:244/255.0 green:164/255.0 blue:96/255.0 alpha:1];
    } else if (colorIndex == 8) {
        result = [UIColor colorWithRed:47/255.0 green:49/255.0 blue:49/255.0 alpha:1];
    }
    
    return result;
}



@end
