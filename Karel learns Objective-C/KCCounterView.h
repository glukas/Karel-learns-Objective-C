//
//  KCCounterView.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 22.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KCCounterView;


@protocol KCounterViewDatasource <NSObject>
- (int)numberOfSlotsForCounterView:(KCCounterView*)counterView;
//slots are indexed from 0
- (int)valueAtSlotWithIndex:(int)indexOfSlot forCounterView:(KCCounterView*)counterView;
@end



@interface KCCounterView : UIView

@property (nonatomic, weak) id <KCounterViewDatasource> datasource;

- (void)reloadData;

@end
