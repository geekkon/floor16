//
//  DBFullScreenCollectionViewCell.m
//  Floor16
//
//  Created by Dim on 27.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBFullScreenCollectionViewCell.h"
#import "DBCacheManager.h"
#import "UIImageView+DBImageView.h"

@implementation DBFullScreenCollectionViewCell

#pragma mark - Public Methods

- (void)configureWithStringURL:(NSString *)stringURL {
    
    [self.activityIndicator startAnimating];
    
    self.imageView.path = stringURL;
    
    UIImage *cellImage = [[DBCacheManager defaultManager] imageForKey:stringURL];
    
    if (!cellImage) {
        
        [self performSelectorInBackground:@selector(loadImage:) withObject:stringURL];
        
    } else {
        
        [self.activityIndicator stopAnimating];
    }
    
    [self.imageView setImage:cellImage byPath:stringURL];
}

#pragma mark - Private Methods

- (void)loadImage:(NSString *)stringURL {
    
    UIImage *cellImage = nil;
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
    
    cellImage = [UIImage imageWithData:imageData];
    
    [self.imageView setImage:cellImage byPath:stringURL];
    
    [self.activityIndicator stopAnimating];
    
    [[DBCacheManager defaultManager] setImage:cellImage forKey:stringURL];
}

@end
