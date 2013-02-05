//
//  NSString+SubstringBetweenDelimiters.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 05.02.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SubstringBetweenDelimiters)

- (NSString *)substringAfterKeyword:(NSString *)keyword betweenLeftDelimiter:(NSString*)leftDelimiter rightDelimiter:(NSString *)rightDelimiter;

@end
