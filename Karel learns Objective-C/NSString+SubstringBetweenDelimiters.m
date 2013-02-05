//
//  NSString+SubstringBetweenDelimiters.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 05.02.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "NSString+SubstringBetweenDelimiters.h"

@implementation NSString (SubstringBetweenDelimiters)

- (NSString *)substringAfterKeyword:(NSString *)keyword betweenLeftDelimiter:(NSString*)leftDelimiter rightDelimiter:(NSString *)rightDelimiter
{
    NSString * result;
    NSRange keywordRange = [self rangeOfString:keyword options:NSCaseInsensitiveSearch];
    if (keywordRange.location != NSNotFound) {
        NSRange startOfParenthesis = [self rangeOfString:leftDelimiter options:NSCaseInsensitiveSearch range:NSMakeRange(keywordRange.location, self.length-keywordRange.location)];
        if (startOfParenthesis.location != NSNotFound) {
            NSRange endOfParenthesis = [self rangeOfString:rightDelimiter options:NSCaseInsensitiveSearch range:NSMakeRange(startOfParenthesis.location, self.length-startOfParenthesis.location)];
            if (endOfParenthesis.location != NSNotFound) {
                NSRange resultRange = NSMakeRange(startOfParenthesis.location+startOfParenthesis.length, endOfParenthesis.location-startOfParenthesis.location-endOfParenthesis.length);
                result = [self substringWithRange:resultRange];
            }
            
        }
    }
    return result;
}

@end
