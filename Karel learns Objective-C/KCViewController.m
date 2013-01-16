//
//  KCViewController.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCViewController.h"
#import "KCWorldView.h"
#import "KCWorld.h"
#import "KCKarel.h"
#import "KCBeeperPickingKarel.h"
@interface KCViewController () <KCWorldViewDatasource>
//view
@property (weak, nonatomic) IBOutlet KCWorldView *worldView;

//model
@property (nonatomic, strong) KCWorld * world;
@property (nonatomic, strong) KCKarel * karel;
@property (nonatomic) BOOL karelRunning;
@end

@implementation KCViewController





#pragma mark KCWorldViewDatasource

- (int)numberOfBeepersAtPosition:(KCPosition *)position forWorldView:(KCWorldView *)worldView
{
    int result = [self.world numberOfBeepersAtPosition:position];
    return result;
}

- (KCHeadedPosition*)positionOfKarelForWorldView:(KCWorldView *)worldView
{
    return [self.world positionOfKarel:self.karel];
}

- (NSSet*)positionsOfWallsForWorldView:(KCWorldView *)worldView
{
    return self.world.positionsOfWalls;
}

- (KCSize*)sizeOfWorldForWorldView:(KCWorldView *)worldView
{
    return self.world.size;
}

- (void)setWorldView:(KCWorldView *)worldView
{
    if (worldView != _worldView) {
        _worldView = worldView;
        worldView.datasource = self;
    }
}

- (IBAction)runButtonPressed:(UIButton *)sender {
    //run karel
    if (!self.karelRunning) {
        self.karelRunning = YES;
        [self.karel performSelectorInBackground:@selector(run) withObject:nil];
    }
}

#pragma mark lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.worldView reloadWorld];
    //observe model for changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldModelChanged:) name:KCWorldChangedNotification object:self.world];
    

}

- (void)worldModelChanged:(NSNotification*)notification
{
    [self.worldView reloadWorld];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //setup world
    self.world = [KCWorld worldWithName:@"StoneMasonWorld"];
    [self.world addWallBorders];
    //setup karel
    self.karel = [[self.world karelsInWorld] anyObject];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
