//
//  KCWorldSelectionViewController.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 16.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KCWorldSelectionViewController;

//presenting view controllers should implement this protocol to receive the name of the selected world
//if no selection is made, nothing happens
@protocol  KCWorldSelectionPresenterProtocol <NSObject>
- (void)worldSelectionViewController:(KCWorldSelectionViewController*)controller didSelectWorldWithName:(NSString*)world;
@end

@interface KCWorldSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@end
