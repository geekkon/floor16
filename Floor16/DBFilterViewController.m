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

NSString * const kFilter                = @"filter";
NSString * const kFilterPhoto           = @"photo";
NSString * const kFilterPrice           = @"price";
NSString * const kFilterAppartment      = @"appartment";
NSString * const kFilterAppartmentKyes  = @"appartment-keys";

@interface DBFilterViewController ()

@property (strong, nonatomic) NSString *priceFooter;
@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) NSArray *appartmentKeys;
@property (strong, nonatomic) UIView *labelView;

@end

@implementation DBFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appartmentKeys = @[@"room", @"studio", @"appartment1", @"appartment2", @"appartment3", @"appartment4"];
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:self.appartmentKeys
                                              forKey:kFilterAppartmentKyes];
    
    NSMutableDictionary *buttonsState = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [self.appartmentTypeButtons count]; i++) {
        
        NSString *key = self.appartmentKeys[i];
        
        UIButton *button = self.appartmentTypeButtons[i];
        
        NSString *state = button.isSelected ? @"YES" : @"NO";
        
        buttonsState[key] = state;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:buttonsState
                                                  forKey:kFilterAppartment];
    
    [[NSUserDefaults standardUserDefaults] setBool:self.filterControl.selectedSegmentIndex
                                            forKey:kFilter];
    
    [[NSUserDefaults standardUserDefaults] setBool:self.photoSwitch.isOn
                                            forKey:kFilterPhoto];
    
    [[NSUserDefaults standardUserDefaults] setInteger:(int)self.priceSlider.value
                                               forKey:kFilterPrice];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadFilterState {
    
    self.filterControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] boolForKey:kFilter];
    
    self.photoSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kFilterPhoto];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kFilterPrice]) {

        self.priceSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kFilterPrice];
    }
    
    NSDictionary *buttonsState = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterAppartment];
    
    if (buttonsState) {
        
        for (int i = 0; i < [self.appartmentTypeButtons count]; i++) {
            
            UIButton *button = self.appartmentTypeButtons[i];
            
            NSString *key = self.appartmentKeys[i];
            
            NSString *state = buttonsState[key];
            
            button.selected = [state isEqualToString:@"YES"] ? YES : NO;
        }
    }
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
    
    if (self.filterControl.selectedSegmentIndex) {
        
        if (self.labelView) {
            
            [self.labelView removeFromSuperview];
        }
    
    } else {
        
        if (!self.labelView) {
            
            self.labelView = [[UIView alloc] initWithFrame:self.tableView.bounds];
            
            self.labelView.backgroundColor = [UIColor lightGrayColor];
            self.labelView.alpha = 0.8;
            
            UILabel *label = [[UILabel alloc] initWithFrame:self.labelView.bounds];
            
            label.text = @"Фильтр выключен";
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:20.0];
            
            [self.labelView addSubview:label];
        }
        
        [self.tableView addSubview:self.labelView];
    }
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
