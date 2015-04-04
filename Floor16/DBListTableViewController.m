//
//  DBListTableViewController.m
//  Floor16
//
//  Created by Dim on 28.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBListTableViewController.h"
#import "DBRequestManager.h"
#import "DBListCell.h"
#import "DBListItem.h"

@interface DBListTableViewController () <DBRequestManagerDelegate>

@property (strong, nonatomic) NSMutableArray *items;

@end


@implementation DBListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSMutableArray array];
    
    [self getItems];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refresh:)
              forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods

- (void)getItems{
    
    [[DBRequestManager sharedManager] getItemsFromServerWithDelegate:self];
}

#pragma mark - DBRequestManagerDelegate

- (void)requestManager:(DBRequestManager *)manager didGetItems:(NSArray *)items {
    
    [self.items addObjectsFromArray:items];

    [self.tableView reloadData];
    
    self.navigationItemLabel.text = [NSString stringWithFormat:@"Всего объявлений %d", 20];
}

- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Fail with error %@", [error localizedDescription]);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.items count];
}

- (DBListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DBListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    [cell configureWithItem:self.items[indexPath.row]];
    
    return cell;
}


#pragma mark - UITableViewDelegate


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DBListItem *item = self.items[indexPath.row];
        
       [[segue destinationViewController] setSeoid:item.seoid];
    }
}


#pragma mark - Actions

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (int i = 0; i < [self.items count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.items removeAllObjects];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
    [self getItems];
    [refreshControl endRefreshing];
}

@end
