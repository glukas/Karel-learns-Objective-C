#import "KCStoneMasonKarel.h"
@implementation KCStoneMasonKarel
//precondition: Karel is at (1, 1) facing east
- (void)run
{
    while ([self frontIsClear]) {
        [self repairColumn];
        [self advanceToNextColumn];
    }
    [self repairColumn];
}

//precondtion: facing east at bottom of column
//postcondition: facing east at bottom of column, column repaired
- (void)repairColumn
{
    [self ascendAndRepairColumn];
    [self turnAround]; //descend column
    [self moveToWall];
    [self turnLeft];
}

//precondition: facing east at bottom of column
//postcondition: facing north at top of column, column repaired
- (void)ascendAndRepairColumn
{
    [self turnLeft];
    while ([self frontIsClear]) {
        [self checkCurrentSquare];
        [self move];
    }
    [self checkCurrentSquare];
}

//postcondition: beepersPresent
- (void)checkCurrentSquare
{
    if ( [self noBeepersPresent] ) {
        [self putBeeper];
    } else {
        
    }
}

//postcondition: frontIsBlocked
- (void)moveToWall
{
    while ([self frontIsClear]) {
        [self move];
    }
}

//precondition: at bottom of column, there is a next column
//postcondition: at bottom of next column
- (void)advanceToNextColumn
{
    for (int i = 0; i < 4; i++) {
        [self move];
    }
}
@end