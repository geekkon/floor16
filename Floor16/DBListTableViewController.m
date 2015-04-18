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

@property (assign, nonatomic) NSUInteger currentPage;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSCache *thumbsCache;
@property (strong, nonatomic) UIActivityIndicatorView *backgroundActivityIndicator;

@end

@implementation DBListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 1;
    
    self.backgroundActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.backgroundActivityIndicator.color = [UIColor lightGrayColor];
    
    self.tableView.backgroundView = self.backgroundActivityIndicator;
    
    [self.backgroundActivityIndicator startAnimating];
    
    [self getItemsFromPage:self.currentPage];

    self.items = [NSMutableArray array];
    self.thumbsCache = [[NSCache alloc] init];
    
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

- (void)getItemsFromPage:(NSUInteger)page {
    
    [[DBRequestManager sharedManager] getItemsFromPage:page withDelegate:self];
}

#pragma mark - DBRequestManagerDelegate

- (void)requestManager:(DBRequestManager *)manager didGetItems:(NSArray *)items totalCount:(NSUInteger *)totalCount {
    
    self.currentPage++;
    
    NSUInteger currenRows = [self.items count];
    NSUInteger addedRows  = [items count];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (NSUInteger i = currenRows; i < (currenRows + addedRows); i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.items addObjectsFromArray:items];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationTop];
    
    self.navigationItemLabel.text = [NSString stringWithFormat:@"Всего объявлений: %lu", (unsigned long)*totalCount];
    
    [self.backgroundActivityIndicator stopAnimating];
    [self.footerActivityIndicator stopAnimating];
}

- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
    
    [alert show];
    
    [self.backgroundActivityIndicator stopAnimating];
    [self.footerActivityIndicator stopAnimating];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.items count];
}

- (DBListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DBListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    [cell configureWithItem:self.items[indexPath.row] andCache:self.thumbsCache];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.items count] - 1) {
        
        [self.footerActivityIndicator startAnimating];
        [self getItemsFromPage:self.currentPage];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DBListItem *item = self.items[indexPath.row];
        
       [[segue destinationViewController] setSeoid:item.seoid];
        
    } else if ([[segue identifier] isEqualToString:@"showFilter"]) {
        
    }
}

#pragma mark - Actions

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    self.currentPage = 1;
    
    [self.items removeAllObjects];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationTop];
    
    [self getItemsFromPage:self.currentPage];

    [refreshControl endRefreshing];
}

@end
