//
//  KCFlexibleArray.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCFlexibleArray : NSObject
//the flexible array has no fixed size
//you can always access any position in the array
//this kind of datastructure is handy if you want to apply the lazy instanciation pattern to a series of objects
//the flexible array is indexed from 0

//this class is NOT THREADSAFE



//returns nil if no object set at that index
- (id)objectAtIndex:(NSUInteger)index;

- (void)setObject:(id)object atIndex:(NSUInteger)index;


//the number of non-nil entries;
@property (readonly) NSUInteger count;

@end