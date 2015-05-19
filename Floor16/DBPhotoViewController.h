//
//  DBPhotoViewController.h
//  Floor16
//
//  Created by Dim on 19.05.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBPhotoViewController : UIViewController

@property (strong, nonatomic) NSArray *photoURLs;
@property (assign, nonatomic) NSUInteger photoCount;
@property (assign, nonatomic) NSUInteger currentIndex;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;

- (IBAction)showPrevious:(UIBarButtonItem *)sender;
- (IBAction)showNext:(UIBarButtonItem *)sender;
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;

@end
