//
//  KCWorldLibrary.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 16.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWorldLibrary.h"

@interface KCWorldLibrary()
@end

@implementation KCWorldLibrary

/*
+ (KCWorldLibrary*)worldLibraryWithPath:(NSString *)path
{
    KCWorldLibrary * library = [[self alloc] init];
    library.libraryURL = [NSURL URLWi
    return library;
}
*/

+ (KCWorldLibrary*)defaultLibrary
{
    NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    KCWorldLibrary * library = [[KCWorldLibrary alloc] init];
    library.libraryURL = url;
    library.extension = KCWorldFileExtension;
    return library;
}


- (NSArray *)matchingFiles
{
    NSFileManager * filemanager = [NSFileManager defaultManager];
    NSMutableArray * result = [NSMutableArray array];
    
    NSArray * contents = [filemanager contentsOfDirectoryAtURL:self.libraryURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL * file in contents) {
        NSString * pathExtension = [file pathExtension];
        if ([pathExtension isEqualToString:self.extension]) {
            NSRange rangeOfExtension = [[file lastPathComponent] rangeOfString:@"."];
            [result addObject:[[file lastPathComponent] substringToIndex:rangeOfExtension.location]];
        }
    }
    
    return [result copy];
}

@end
