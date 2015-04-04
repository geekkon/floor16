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
#import "DBCollectionViewCell.h"

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
    [self configureView];
    
    [self.activityIndicator stopAnimating];
}

- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Fail with error %@", [error localizedDescription]);
}


#pragma mark - Private Methods

- (void)configureView {
    
    self.navigationItemLabel.text = self.itemDetails.created;
    self.textView.text = self.itemDetails.descr;
    
    self.pageControl.numberOfPages = [self.itemDetails.imgs count];
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Actions

- (IBAction)actionPageControl:(UIPageControl *)sender {
    
}

@end
