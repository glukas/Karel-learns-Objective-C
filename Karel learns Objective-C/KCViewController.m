//
//  KCViewController.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 14.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCViewController.h"
#import "KCWorldLibrary.h"
#import "KCSlotContainerView.h"
#import "KCCounterSlotView.h"

static NSString * KCLastWorldOpenedUserDefaultsKey = @"KCLastWorldOpened";

@interface KCViewController () <KCSlotContainerViewDatasource>

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

- (void)setCounterView:(KCSlotContainerView *)counterView
{
    if (counterView != _counterView) {
        _counterView = counterView;
        [counterView setBackgroundColor:[UIColor darkGrayColor]];
        counterView.datasource = self;
    }
}

- (void)setPalletteView:(KCSlotContainerView *)palletteView
{
    if (palletteView != _palletteView) {
        _palletteView = palletteView;
        [palletteView setBackgroundColor:[UIColor darkGrayColor]];
        palletteView.datasource = self;
    }
}

#pragma mark KCCounterViewDatasource

- (int)numberOfSlotsForContainer:(KCSlotContainerView *)container
{
    int result;
    if (container == self.counterView) {
        result = self.karel.counter.numberOfSlots;
    } else if (container == self.palletteView) {
        result = self.karel.colorPalette.capacity;
    }
    return result;
}

- (UIView*)slotViewForContainer:(KCSlotContainerView *)container atIndex:(NSUInteger)index
{
    UIView * result;
    if (container == self.counterView) {
        result =  [[KCCounterSlotView alloc] init];
        [result setBackgroundColor:[UIColor blackColor]];
    } else if (container == self.palletteView) {
        result = [[UIView alloc] init];
    }
    return result;
}

- (void)updateSlotView:(UIView *)view fromContainer:(KCSlotContainerView *)container atIndex:(NSUInteger)index
{
    if (container == self.counterView) {
        KCCounterSlotView * slot = (id)view;
        [slot setValue:[self.karel.counter valueAtSlotWithIndex:index]];
    } else if (container == self.palletteView) {
        view.backgroundColor = [self.karel.colorPalette colorAtIndex:index];
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

- (IBAction)runButtonPressed:(id *)sender {
    [self.karel performSelectorInBackground:@selector(run) withObject:nil];
}

#pragma mark world selection

- (void)worldSelectionViewController:(KCWorldSelectionViewController *)controller didSelectWorldWithName:(NSString *)world
{
    [self loadWorldWithName:world];
    [[NSUserDefaults standardUserDefaults] setObject:world forKey:KCLastWorldOpenedUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)loadWorldWithName:(NSString *)world
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
    if (!_world) {
        NSString * lastWorldOpened = [[NSUserDefaults standardUserDefaults] objectForKey:KCLastWorldOpenedUserDefaultsKey];
        if (lastWorldOpened) {
            [self loadWorldWithName:lastWorldOpened];
        }
    }
    [self.worldView reloadWorld];
    [self.counterView reloadData];
    [self.palletteView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.world) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(worldModelChanged:) name:KCWorldChangedNotification object:self.world];
    }
    [self.worldView setNeedsLayout];
    [self.counterView setNeedsLayout];
}

- (void)worldModelChanged:(NSNotification*)notification
{
    NSSet * modifiedPositions = [notification.userInfo objectForKey:KCWorldChangedNotificationModifiedPositionsKey];
    for (KCPosition * position in modifiedPositions) {
        [self.worldView reloadSquareAtPosition:position];
    }
    [self.worldView reloadKarel];
    [self.counterView reloadData];
    [self.palletteView reloadData];
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
