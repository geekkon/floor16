//
//  DBFullScreenCollectionViewCell.h
//  Floor16
//
//  Created by Dim on 27.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBFullScreenCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)configureWithStringURL:(NSString *)stringURL;

@end
