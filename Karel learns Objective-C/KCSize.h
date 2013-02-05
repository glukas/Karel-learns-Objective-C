//
//  KCSize.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCSize : NSObject <NSCopying>

- (id)initWithWidth:(int)width height:(int)height;

//format: @"x y"
+ (KCSize*)sizeFromString:(NSString*)string;
- (NSString *)asString;

@property (readonly) int width;
@property (readonly) int height;

@end
