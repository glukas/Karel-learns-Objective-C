//
//  KCViewController.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCViewController.h"
#import "KCWorldLibrary.h"
@interface KCViewController () 

@property (nonatomic) BOOL karelRunning;
@end

@implementation KCViewController


- (void)setWorld:(KCWorld *)world
{
    if (world != _world) {
        if (_world) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldModelChanged:) name:KCWorldChangedNotification object:world];
        }
        //[self.worldView reloadWorld];
        _world = world;
    }
}


- (void)setWorldView:(KCWorldView *)worldView
{
    if (worldView != _worldView) {
        _worldView = worldView;
        worldView.datasource = self;
    }
}



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
    return self.world.wallPositions;
}

- (KCSize*)sizeOfWorldForWorldView:(KCWorldView *)worldView
{
    return self.world.size;
}

- (UIColor*)colorForSquareAtPosition:(KCPosition *)position forWorldView:(KCWorldView *)worldView
{
    return [self.world colorAtPosition:position];
}

#pragma mark actions

- (IBAction)runButtonPressed:(UIButton *)sender {
    [self.karel performSelectorInBackground:@selector(run) withObject:nil];
}

#pragma mark world selection

- (void)worldSelectionViewController:(KCWorldSelectionViewController *)controller didSelectWorldWithName:(NSString *)world
{
    [self.world removeKarel:self.karel];
    self.world = [KCWorld worldWithName:world];
    if (!self.world) {
        KCWorldLibrary * library = [KCWorldLibrary defaultLibrary];
        NSURL * url = [[library.libraryURL URLByAppendingPathComponent:world] URLByAppendingPathExtension:library.extension];
        self.world = [KCWorld worldWithURL:url];
    }
    [self.world addWallBorders];
    self.karel = [[self.world karelsInWorld] anyObject];
}

#pragma mark lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.worldView reloadWorld];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.world) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldModelChanged:) name:KCWorldChangedNotification object:self.world];
    }
    [self.worldView setNeedsLayout];
}

- (void)worldModelChanged:(NSNotification*)notification
{
    NSSet * modifiedPositions = [notification.userInfo objectForKey:KCWorldChangedNotificationModifiedPositionsKey];
    for (KCPosition * position in modifiedPositions) {
        [self.worldView reloadSquareAtPosition:position];
    }
    [self.worldView reloadKarel];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //setup world
    /*
    if (!self.world) {
        self.world = [KCWorld worldWithName:@"StoneMasonWorld"];
        [self.world addWallBorders];
        //setup karel
        self.karel = [[self.world karelsInWorld] anyObject];
    }*/
    
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

/*
- (void)testPositionIsUsableAsAKeyForADictionary
{
    NSMutableDictionary * testDictionary = [NSMutableDictionary dictionary];
    int testSize = 1000;
    for (int i = 0; i < testSize; i++) {
        for (int j = 0; j < testSize; j++) {
            KCPosition * pos = [[KCPosition alloc] initWithX:i Y:j];
            [testDictionary setObject:[NSNumber numberWithInt:[pos hash]] forKey:pos];
        }
    }
    
    for (int i = 0; i < testSize; i++) {
        for (int j = 0; j < testSize; j++) {
            KCPosition * pos = [[KCPosition alloc] initWithX:i Y:j];
            [testDictionary objectForKey:pos];
            [[testDictionary objectForKey:pos] isEqual:[NSNumber numberWithInt:[pos hash]]];
        }
    }
}

- (void)testHeadedPositionCanBeUsedAsAKeyInADictionary
{
    NSMutableDictionary * testDictionary = [NSMutableDictionary dictionary];
    int testSize = 1000;
    for (int i = 0; i < testSize; i++) {
        for (int j = 0; j < testSize; j++) {
            KCHeadedPosition * pos = [KCHeadedPosition positionWithX:i Y:j orientation:north];
            [testDictionary setObject:[NSNumber numberWithInt:[pos hash]] forKey:pos];
        }
    }
    
    for (int i = 0; i < testSize; i++) {
        for (int j = 0; j < testSize; j++) {
            KCHeadedPosition * pos = [KCHeadedPosition positionWithX:i Y:j orientation:north];
            [testDictionary objectForKey:pos];
            [[testDictionary objectForKey:pos] isEqual:[NSNumber numberWithInt:[pos hash]]];
        }
    }
}*/

@end
