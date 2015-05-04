//
//  DBCollectionViewController.h
//  Floor16
//
//  Created by Dim on 27.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *pics;

- (IBAction)actionTap:(UITapGestureRecognizer *)sender;

@end
