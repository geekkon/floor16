//
//  DBItemDetailViewController.m
//  Floor16
//
//  Created by Dim on 04.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBItemDetailViewController.h"
#import "DBRequestManager.h"
#import "DBItemDetails.h"

@interface DBItemDetailViewController () <DBRequestManagerDelegate>

@property (strong, nonatomic) DBItemDetails *itemDetails;

@end

@implementation DBItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[DBRequestManager sharedManager] getItemDetailsFromServerWithSeoid:self.seoid andDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DBRequestManagerDelegate

- (void)requestManager:(DBRequestManager *)manager didGetItemDetails:(DBItemDetails *)itemDatails {
    
    self.itemDetails = itemDatails;
    [self.activityIndicator stopAnimating];
    [ UIView animateWithDuration:1.3
                      animations:^{
                          self.view.backgroundColor = [UIColor whiteColor];
                          [self configureView];
                      }];
}

- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Fail with error %@", [error localizedDescription]);
}


#pragma mark - Private Methods

- (void)configureView {
    
    self.navigationItemLabel.text = self.itemDetails.created;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
