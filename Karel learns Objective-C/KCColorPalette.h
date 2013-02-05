//
//  KCColorPalette.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCColorPalette : NSObject

- (id)initWithCapacity:(NSUInteger)capacity;


- (UIColor*)colorAtIndex:(NSUInteger)index;

- (void)setColor:(UIColor*)color atIndex:(NSUInteger)index;


@property (readonly) int capacity;

@end
