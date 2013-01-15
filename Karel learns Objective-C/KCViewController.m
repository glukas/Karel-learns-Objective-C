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
@end

@implementation KCViewController





#pragma mark KCWorldViewDatasource

- (int)numberOfBeepersAtPosition:(KCPosition *)position forWorldView:(KCWorldView *)worldView
{
    //return 1;
    int result = [self.world numberOfBeepersAtPosition:position];
    NSLog(@"position: %@, beepers: %d", position, result);
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


#pragma mark lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.karel performSelectorInBackground:@selector(run) withObject:nil];
}

- (void)worldModelChanged:(NSNotification*)notification
{
    [self.worldView reloadWorld];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //setup world
    NSString * worldDescription = @"size(5 4) speed(0.5) karel(1 4 e KCUnlimited) walls(1 4 s, 2 4 s, 3 4 s, 4 4 w, 4 4 n, 5 4 n) beepers(1 4 1, 2 6 1)";
    self.world = [KCWorld worldFromString:worldDescription];
    
    
    self.world = [[KCWorld alloc] init];
    self.world.size = [[KCSize alloc] initWithWidth:5 height:4];
    self.world.turnLength = 0.5;
    NSString * wallString = @"1 4 s, 2 4 s, 3 4 s, 4 4 w, 4 4 n, 5 4 n";
    NSSet * walls = [KCWorld wallPositionsFromString:wallString];
    self.world.positionsOfWalls = walls;
	
    NSDictionary * beepers = [KCWorld beeperDictionaryFromString:@"3 4 1"];
    self.world.numberOfBeepersAtPositions = beepers;
    //setup karel
    self.karel = [[KCBeeperPickingKarel alloc] initWithWorld:self.world numberOfBeepers:KCUnlimited];
    [self.world addKarel:self.karel atPosition:[KCHeadedPosition headedPositionFromString:@"1 4 e"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldModelChanged:) name:KCWorldChangedNotification object:self.world];
    
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
