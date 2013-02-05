//
//  KCKarelToken.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 05.02.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//
//  This class is meant to facilitate karel object archiving
//  usage:
//  export:
//  1. create token and set className and numberOfBeepersInBag propertys
//  2. export using -asString and saving the string somewhere
//  import:
//  3. load the string from file and call +karelFromString:
//      the resulting object will be of class 'className' if such a class exists, KCKarel otherwise
//      the numberOfBeepersInBag will be set accordingly

#import "KCKarel.h"

@interface KCKarelToken : KCKarel

@property (nonatomic, strong) NSString * className;

@property (nonatomic) KCCount numberOfBeepersInBag;

@end
