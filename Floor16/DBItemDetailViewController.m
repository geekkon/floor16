//
//  DBItemDetailViewController.m
//  Floor16
//
//  Created by Dim on 04.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBItemDetailViewController.h"
#import "DBRequestManager.h"

@interface DBItemDetailViewController () <DBRequestManagerDelegate>

@end

@implementation DBItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getItemDetalis];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods

- (void)getItemDetalis {
    
    [[DBRequestManager sharedManager] getItemDetailsFromServerWithSeoid:self.seoid andDelegate:self];
}


#pragma mark - DBRequestManagerDelegate

- (void)requestManager:(DBRequestManager *)manager didGetItemDetails:(DBItemDetails *)itemDatails {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:nil delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    [alertView show];
    
    
}

- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Fail with error %@", [error localizedDescription]);
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
