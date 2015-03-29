//
//  DBListTableViewController.m
//  Floor16
//
//  Created by Dim on 28.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBListTableViewController.h"
#import "DBListCell.h"
#import "DBRequestManager.h"

@interface DBListTableViewController ()

@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation DBListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSMutableArray array];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods

- (void)getItems{
    
    NSArray *newItems = [[DBRequestManager sharedManager] getItemsFromServer];
    
    [self.items addObjectsFromArray:newItems];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [NSString stringWithFormat:@"Всего объявлений: %d", 1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.items count];
}

- (DBListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DBListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    [cell configureWithItem:self.items[indexPath.row]];
    
    return cell;
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
