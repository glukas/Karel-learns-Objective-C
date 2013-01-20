//
//  KCSquareView.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCHeadedPosition.h"

@interface KCSquareView : UIView
//if the background color is nil, a background image is displayed
//if the background color is any color, this color is used as a background instead

//must be positive
@property (nonatomic) int numberOfBeepers;

@end