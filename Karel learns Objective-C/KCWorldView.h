//
//  KCWorldView.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//
//  supports one karel, beepers and walls

#import <UIKit/UIKit.h>
#import "KCSize.h"
#import "KCHeadedPosition.h"

@class KCWorldView;

@protocol KCWorldViewDatasource <NSObject>
//general
- (KCSize*)sizeOfWorldForWorldView:(KCWorldView*)worldView;
//beepers
//must be positive
- (int)numberOfBeepersAtPosition:(KCPosition*)position forWorldView:(KCWorldView*)worldView;
//karel
- (KCHeadedPosition*)positionOfKarelForWorldView:(KCWorldView*)worldView;;

//walls
//all members must be of type KCHeadedOrientation
- (NSSet*)positionsOfWallsForWorldView:(KCWorldView*)worldView;;

@end



@interface KCWorldView : UIView
//to start using the view, set datasource and call reloadWorld
//when reload world is called, the frame must be set to the desired size


@property (nonatomic, weak) id <KCWorldViewDatasource> datasource;


//if you change the model, update the view by calling these methods:

//beepers at position changed
- (void)reloadSquareAtPosition:(KCPosition*)position;

//will reposition karel
- (void)reloadKarel;

//reload all walls
- (void)reloadWalls;

//load all data and
//clear everything
//will cause the datsource to be queried for new information
//new size possible
- (void)reloadWorld;

@end
