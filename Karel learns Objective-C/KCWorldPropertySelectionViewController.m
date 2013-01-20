//
//  KCWorldPropertySelectionViewController.m
//  Karel learns Objective-C
//
//  Created by Lukas Gianinazzi on 16.01.13.
//  Copyright (c) 2013 Lukas Gianinazzi. All rights reserved.
//

#import "KCWorldPropertySelectionViewController.h"
#import "KCWorldEditorViewController.h"

@interface KCWorldPropertySelectionViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *createWorldCell;
@property (weak, nonatomic) IBOutlet UISlider *heightSlider;
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation KCWorldPropertySelectionViewController

- (IBAction)cancelTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (BOOL)validProperties
{
    return self.nameField.text.length > 0;
}

- (IBAction)nameOfWorldChanged:(id)sender {
    [self updateTitle];
    [self updateViewState];
}



- (IBAction)heightChanged:(id)sender {
    [self updateTitle];
}


- (IBAction)widthChanged:(id)sender {
    [self updateTitle];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updateTitle
{
    NSString * name = self.nameField.text;
    if (name.length == 0) name = @"New World";
    self.title = [NSString stringWithFormat:@"%@ %d x %d", name, (int)self.widthSlider.value, (int)self.heightSlider.value];
}

- (void)updateViewState
{
    if ([self validProperties]) {
        
        self.createWorldCell.textLabel.textColor = [UIColor blackColor];
        self.createWorldCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.createWorldCell.textLabel.textColor = [UIColor lightGrayColor];
        self.createWorldCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.nameField resignFirstResponder];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.nameField resignFirstResponder];
    BOOL result = NO;
    if (indexPath.row == 2) {
        if ([self validProperties]) {
            result = YES;
        }
    }
    
    return result;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateViewState];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (KCSize*)currentSize
{
    return [[KCSize alloc] initWithWidth:(int)self.widthSlider.value height:(int)self.heightSlider.value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] respondsToSelector:@selector(setNameOfWorld:)]) {
        [(id)[segue destinationViewController] setNameOfWorld:self.nameField.text];
    }
    if ([[segue destinationViewController] respondsToSelector:@selector(setSizeOfWorld:)]) {
       
        [(id)[segue destinationViewController] setSizeOfWorld:[self currentSize]];
    }
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
