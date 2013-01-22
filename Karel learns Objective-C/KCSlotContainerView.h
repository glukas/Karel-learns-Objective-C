//
//  KCSlotContainerView.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KCSlotContainerView;



@protocol  KCSlotContainerViewDatasource <NSObject>

- (int)numberOfSlotsForContainer:(KCSlotContainerView*)container;
- (UIView*)slotViewForContainer:(KCSlotContainerView*)container atIndex:(NSUInteger)index;
@optional
- (void)updateSlotView:(UIView*)view fromContainer:(KCSlotContainerView*)container atIndex:(NSUInteger)index;
@end


@interface KCSlotContainerView : UIView

@property (nonatomic, weak) id <KCSlotContainerViewDatasource> datasource;

- (void)reloadData;

@end