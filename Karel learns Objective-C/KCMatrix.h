//
//  KCMatrix.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCSize.h"
#import "KCPosition.h"

@interface KCMatrix : NSObject

- (id)initWithSize:(KCSize*)size;

//object must be non-nil
- (void)setObject:(id)object AtPosition:(KCPosition*)position;

//result is nil if no object at position
- (id)objectAtPosition:(KCPosition*)position;


@end
