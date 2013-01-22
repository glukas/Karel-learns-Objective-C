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

//the KCMatrix maps positions in two dimenstion to objects
//it has no fixed size
//imagine it as a very large matrix initialized with nil
//(this is of course not how it is implemented)


//if object is nil, the position will be 'cleared'
- (void)setObject:(id)object atPosition:(KCPosition*)position;

//result is nil if no object at position
- (id)objectAtPosition:(KCPosition*)position;


//the number of non-nil entries
@property (readonly) NSUInteger count;

@end
