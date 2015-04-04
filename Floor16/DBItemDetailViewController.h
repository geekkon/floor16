//
//  DBItemDetailViewController.h
//  Floor16
//
//  Created by Dim on 04.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBItemDetailViewController : UIViewController

@property (strong, nonatomic) NSString  *seoid;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *navigationItemLabel;

@end
