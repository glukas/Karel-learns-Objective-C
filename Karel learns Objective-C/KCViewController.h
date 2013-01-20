//
//  KCViewController.h
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCWorldSelectionViewController.h"
#import "KCWorldView.h"
#import "KCWorld.h"
#import "KCKarel.h"
@interface KCViewController : UIViewController <KCWorldSelectionPresenterProtocol, KCWorldViewDatasource>

//view
@property (weak, nonatomic) IBOutlet KCWorldView *worldView;

//model
@property (nonatomic, strong) KCWorld * world;
@property (nonatomic, strong) KCKarel * karel;

@end
