//
//  DBFilterViewController.m
//  Floor16
//
//  Created by Dim on 12.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBFilterViewController.h"
#import "DBListTableViewController.h"

NS_ENUM(NSUInteger, DBFilterSectionName) {
    
    DBFilterSectionNamePhoto,
    DBFilterSectionNamePrice,
    DBFilterSectionNameAppartment
};

NSString * const kFilter            = @"filter";
NSString * const kFilterPhoto       = @"photo";
NSString * const kFilterPrice       = @"price";
NSString * const kFilterAppartment  = @"appartment";

@interface DBFilterViewController ()

@property (strong, nonatomic) NSString *priceFooter;
@property (strong, nonatomic) UIColor *tintColor;

@end

@implementation DBFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFilterState];
    
    [self setPriceFooterWithValue:(int)self.priceSlider.value];
    
    self.tintColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:255.0 alpha:1.0];
    
    for (UIButton *sender in self.appartmentTypeButtons) {
        
        [self configureButtonView:sender];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)saveFilterState {
    
    [[NSUserDefaults standardUserDefaults] setBool:self.filterControl.selectedSegmentIndex
                                            forKey:kFilter];
    
    [[NSUserDefaults standardUserDefaults] setBool:self.photoSwitch.isOn
                                            forKey:kFilterPhoto];
    
    [[NSUserDefaults standardUserDefaults] setInteger:(int)self.priceSlider.value
                                               forKey:kFilterPrice];
    
 
    [[NSUserDefaults standardUserDefaults] setObject:self.appartmentTypeButtons forKey:kFilterAppartment];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadFilterState {
    
    self.filterControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] boolForKey:kFilter];
    
    self.photoSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kFilterPhoto];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kFilterPrice]) {

        self.priceSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kFilterPrice];
    }
    
    self.appartmentTypeButtons = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterAppartment];
}

- (void)setPriceFooterWithValue:(NSInteger)value {
    
    NSString *string = @"";
    
    if (value > 0 && value < 100) {
        
        string = [string stringByAppendingFormat:@"Не более %ld руб.", (value * 500)];

    } else {
        
        string = @"Без ограничений";
    }
    
    self.priceFooter = string;
}

- (void)configureView {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    

    
    if (self.filterControl.selectedSegmentIndex) {
        
        self.tableView.alpha = 1.0;
        self.view.userInteractionEnabled = YES;
        
    } else {
        
        self.tableView.alpha = 0.7;
        self.view.userInteractionEnabled = NO;
    }
    
    [UIView commitAnimations];
}

- (void)configureButtonView:(UIButton *)sender {
    
    sender.layer.borderColor = self.tintColor.CGColor;
    sender.layer.borderWidth = 1.0;
    sender.layer.cornerRadius = 15.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

    if (sender.selected) {
        
        [UIView setAnimationDuration:0.0];
        sender.backgroundColor = self.tintColor;
        
    } else {
        
        [UIView setAnimationDuration:0.4];
        sender.backgroundColor = [UIColor clearColor];
    }
    
    [UIView commitAnimations];
}

#pragma mark - <UITableViewDataSource>

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == DBFilterSectionNamePrice) {
        
        return self.priceFooter;
    }
    
    return nil;
}

#pragma mark - <UITableViewDelegate>

#pragma mark - Actions

- (IBAction)actionFilter:(UISegmentedControl *)sender {
 
    [self configureView];
}

- (IBAction)actionSlider:(UISlider *)sender {
    
    [self setPriceFooterWithValue:(int)sender.value];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:DBFilterSectionNamePrice] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    
    [self saveFilterState];
    
    UINavigationController *navigationController = (UINavigationController *)self.presentingViewController;
    
    DBListTableViewController *listViewController = (DBListTableViewController *)navigationController.topViewController;
    
    [listViewController getItemsFromPageOne];
    
    [self dismissViewControllerAnimated:YES completion:nil];    
}

- (IBAction)actionCancel:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionClickButton:(UIButton *)sender {
    
    sender.selected = sender.isSelected ? NO : YES;
    
    [self configureButtonView:sender];
}

@end
