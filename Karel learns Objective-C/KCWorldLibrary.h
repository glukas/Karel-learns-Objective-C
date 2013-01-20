//
//  KCWorldLibrary.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 16.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * KCWorldFileExtension = @"kcw";

@interface KCWorldLibrary : NSObject

//+ (KCWorldLibrary *)worldLibraryWithPath:(NSString*)path;

+ (KCWorldLibrary*)defaultLibrary;

//the directoy in which to search for files
@property (nonatomic, strong) NSURL * libraryURL;

//all files with this extension will be returned
@property (nonatomic, strong) NSString * extension;

//contains NSString objects that correspond to a file with matching extension found in the libraryPath
- (NSArray *)matchingFiles;

@end