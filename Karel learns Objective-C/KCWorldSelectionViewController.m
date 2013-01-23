//
//  KCWorldSelectionViewController.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 16.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWorldSelectionViewController.h"
#import "KCWorldLibrary.h"



@interface KCWorldSelectionViewController ()

@property (nonatomic, strong) KCWorldLibrary * bundleWorldLibrary;//worlds from the bundle
@property (nonatomic, strong) KCWorldLibrary * documentsWorldLibrary;//worlds from the documents directory
@property (nonatomic, strong) NSArray * namesOfWorlds;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KCWorldSelectionViewController

- (KCWorldLibrary*)bundleWorldLibrary
{
    if (!_bundleWorldLibrary) {
        _bundleWorldLibrary = [[KCWorldLibrary alloc] init];
        _bundleWorldLibrary.libraryURL = [[NSBundle mainBundle] bundleURL];
        _bundleWorldLibrary.extension = KCWorldFileExtension;
    } return _bundleWorldLibrary;
}

- (KCWorldLibrary*)documentsWorldLibrary
{
    if (!_documentsWorldLibrary) {
        _documentsWorldLibrary = [KCWorldLibrary defaultLibrary];
    } return _documentsWorldLibrary;
}

- (NSArray *)namesOfWorlds
{
    if (!_namesOfWorlds) {
        NSArray * filesInBundle = [self.bundleWorldLibrary matchingFiles];
        NSArray * filesInDocumentsDirectory = [self.documentsWorldLibrary matchingFiles];
        _namesOfWorlds = [filesInBundle arrayByAddingObjectsFromArray:filesInDocumentsDirectory];
    }
    return _namesOfWorlds;
}


- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.namesOfWorlds.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.presentingViewController conformsToProtocol:@protocol(KCWorldSelectionPresenterProtocol) ]) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [(id)self.presentingViewController worldSelectionViewController:self didSelectWorldWithName:cell.textLabel.text];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"worldSelectionCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"worldSelectionCell"];
    }
    cell.textLabel.text = [self.namesOfWorlds objectAtIndex:indexPath.row];
    return cell;
}



- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _namesOfWorlds = nil;
    [self.tableView reloadData];
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
