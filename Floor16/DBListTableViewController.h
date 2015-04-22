//
//  DBListTableViewController.h
//  Floor16
//
//  Created by Dim on 28.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBListTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *navigationItemLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *footerActivityIndicator;

- (IBAction)actionInfo:(UIBarButtonItem *)sender;

- (void)getItemsWithFilter:(NSDictionary *)filter;

@end
