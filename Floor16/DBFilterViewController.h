//
//  DBFilterViewController.h
//  Floor16
//
//  Created by Dim on 12.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kFilter;
extern NSString * const kFilterPhoto;
extern NSString * const kFilterPrice;
extern NSString * const kFilterAppartment;
extern NSString * const kFilterAppartmentKyes;

@interface DBFilterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *filterControl;

@property (weak, nonatomic) IBOutlet UISwitch *photoSwitch;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *appartmentTypeButtons;

- (IBAction)actionFilter:(UISegmentedControl *)sender;
- (IBAction)actionSlider:(UISlider *)sender;
- (IBAction)actionDone:(UIBarButtonItem *)sender;
- (IBAction)actionCancel:(UIBarButtonItem *)sender;
- (IBAction)actionClickButton:(UIButton *)sender;

@end
