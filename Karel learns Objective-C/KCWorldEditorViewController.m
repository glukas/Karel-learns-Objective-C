//
//  KCWorldEditorViewController.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 16.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWorldEditorViewController.h"
#import "KCWorldLibrary.h"
@interface KCWorldEditorViewController ()

@end

@implementation KCWorldEditorViewController

- (void)setNameOfWorld:(NSString *)nameOfWorld
{
    self.title = nameOfWorld;
    _nameOfWorld = nameOfWorld;
}


- (void)setSizeOfWorld:(KCSize *)sizeOfWorld
{
    _sizeOfWorld = sizeOfWorld;
    self.world = [[KCWorld alloc] init];
    self.world.size = sizeOfWorld;
    [self.world addWallBorders];
}


- (void)swipeRight:(UISwipeGestureRecognizer*)sender
{
    
    KCPosition * position = [self.worldView positionFromPointInView:[sender locationInView:self.worldView]];
    KCHeadedPosition * headedPosition = [[KCHeadedPosition alloc] initWithPosition:position orientation:north];
    if (![self.world isWallAtHeadedPosition:headedPosition]) {
        [self.world addWallAtPosition:headedPosition];
    } else {
        [self.world removeWallAtPosition:headedPosition];
    }
    [self.worldView reloadWalls];
}

- (void)swipeDown:(UISwipeGestureRecognizer*)sender
{
    KCPosition * position = [self.worldView positionFromPointInView:[sender locationInView:self.worldView]];
    KCHeadedPosition * headedPosition = [[KCHeadedPosition alloc] initWithPosition:position orientation:west];
    if (![self.world isWallAtHeadedPosition:headedPosition]) {
        [self.world addWallAtPosition:headedPosition];
    } else {
        [self.world removeWallAtPosition:headedPosition];
    }
    [self.worldView reloadWalls];
}


- (void)tap:(UITapGestureRecognizer *)sender
{
    KCPosition * position = [self.worldView positionFromPointInView:[sender locationInView:self.worldView]];
    
    int cur = [self.world numberOfBeepersAtPosition:position];
    if (cur == 0) {
        [self.world setNumberOfBeepers:1 atPosition:position];
    } else {
        [self.world setNumberOfBeepers:0 atPosition:position];
    }
    
    
}


- (IBAction)saveButtonTapped:(id)sender
{
    NSURL * documentsURL = [KCWorldLibrary defaultLibrary].libraryURL;
    NSURL * path = [[documentsURL URLByAppendingPathComponent:self.nameOfWorld] URLByAppendingPathExtension:@"kcw"];
    [self.world saveToURL:path];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setUpGestures
{

    
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [self.worldView addGestureRecognizer:right];
    
    UISwipeGestureRecognizer * down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    [down setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.worldView addGestureRecognizer:down];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tap requireGestureRecognizerToFail:right];
    [tap requireGestureRecognizerToFail:down];
    [self.worldView addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUpGestures];
    //[self.worldView reloadWorld];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
