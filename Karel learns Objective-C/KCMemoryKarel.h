//
//  KCMemoryKarel.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 05.02.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCSuperKarel.h"

@interface KCMemoryKarel : KCSuperKarel

//first value: address of color (0-5)
- (void)paintCornerWithColorFromPaletteUsingCounter;

//first value: red (0-10)
//second value: green(0-10)
//third value: blue (0-10)
//fourth value: address of color (0-5);
- (void)setColorUsingCounter;

@property (readonly, strong) KCCounter * counter;
@property (readonly) KCColorPalette * colorPalette;

@end
