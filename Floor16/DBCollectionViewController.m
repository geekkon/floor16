//
//  DBCollectionViewController.m
//  Floor16
//
//  Created by Dim on 27.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBCollectionViewController.h"
#import "DBFullScreenCollectionViewCell.h"

@interface DBCollectionViewController ()

@end

@implementation DBCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

- (void)showPhotoByIndex:(NSUInteger)index {
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:3];
//    
//    [self.collectionView scrollToItemAtIndexPath:indexPath
//                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
//                                        animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.pics count];
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell
//    
//    return cell;
//}

- (DBFullScreenCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DBFullScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FullScreenImageCell" forIndexPath:indexPath];
    
    NSString *stringURL = self.pics[indexPath.row];
    
    [cell configureWithStringURL:stringURL];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - Actions

- (IBAction)actionClose:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
