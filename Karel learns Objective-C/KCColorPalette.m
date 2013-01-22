//
//  KCColorPalette.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCColorPalette.h"


@interface KCColorPalette()
@property (nonatomic, strong) NSArray * internalColors;
@end

@implementation KCColorPalette

- (id)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    if (self) {
        
        _capacity = capacity;
        
        NSMutableArray * colors = [NSMutableArray array];
        for (int i = 0; i < capacity; i++) {
            [colors addObject:[UIColor whiteColor]];
        }
        self.internalColors = colors;
        
        
    } return self;
}


- (UIColor*)colorAtIndex:(NSUInteger)index
{
    UIColor * color = [self.internalColors objectAtIndex:index];
    //NSLog(@"color: %@", color);
    return color;
}

- (void)setColor:(UIColor *)color atIndex:(NSUInteger)index
{
    NSMutableArray * mutableCopy = [self.internalColors mutableCopy];
    [mutableCopy setObject:color atIndexedSubscript:index];
    self.internalColors = [mutableCopy copy];
}

@end
