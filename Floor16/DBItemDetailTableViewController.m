//
//  DBItemDetailTableViewController.m
//  Floor16
//
//  Created by Dim on 15.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBItemDetailTableViewController.h"
#import "DBRequestManager.h"
#import "DBItemDetails.h"
#import "DBCollectionViewCell.h"
#import "DBMapAnnotation.h"

@interface DBItemDetailTableViewController () <DBRequestManagerDelegate>

@property (strong, nonatomic) DBItemDetails *itemDetails;

@end

@implementation DBItemDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[DBRequestManager sharedManager] getItemDetailsFromServerWithSeoid:self.seoid andDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DBRequestManagerDelegate

- (void)requestManager:(DBRequestManager *)manager didGetItemDetails:(DBItemDetails *)itemDatails {
    
    self.itemDetails = itemDatails;
    [self configureView];
    
    [self.activityIndicator stopAnimating];
}

- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - Private Methods

- (void)configureView {
    
    self.navigationItemLabel.text = self.itemDetails.created;
    self.textLabel.text = self.itemDetails.descr;
    
    self.pageControl.numberOfPages = [self.itemDetails.imgs count];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.itemDetails.imgs count];
}

- (DBCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    NSString *stringURL = self.itemDetails.imgs[indexPath.row];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
    
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.itemDetails.lat, self.itemDetails.lng);
        
        DBMapAnnotation *annotation = [[DBMapAnnotation alloc] init];
        annotation.title = self.itemDetails.address;
        annotation.coordinate = coordinate;
        
        [[segue destinationViewController] setAnnotation:annotation];
    }
}

#pragma mark - Actions

- (IBAction)actionPageControl:(UIPageControl *)sender {
    
}

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    
    
}

@end
