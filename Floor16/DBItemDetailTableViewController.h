//
//  DBItemDetailTableViewController.h
//  Floor16
//
//  Created by Dim on 15.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBItemDetailTableViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSString  *seoid;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *navigationItemLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)actionPageControl:(UIPageControl *)sender;

@end
