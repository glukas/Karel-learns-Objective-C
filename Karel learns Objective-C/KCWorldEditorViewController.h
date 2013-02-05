//
//  KCWorldEditorViewController.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 16.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCViewController.h"

@interface KCWorldEditorViewController : KCViewController

@property (nonatomic, strong) KCSize * sizeOfWorld;
@property (nonatomic, strong) NSString * nameOfWorld;
@property (nonatomic, strong) NSString * karelClassName;

@end
