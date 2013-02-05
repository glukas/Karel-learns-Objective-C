//
//  KCKarelToken.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 05.02.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCKarelToken.h"

@implementation KCKarelToken

- (NSString *)asString
{
    NSString * result = [NSString stringWithFormat:@"class[%@] beeperbag[%d] position[%@]", self.className, self.numberOfBeepersInBag, [[self.world positionOfKarel:self] asString]];
    return result;
}

@end
