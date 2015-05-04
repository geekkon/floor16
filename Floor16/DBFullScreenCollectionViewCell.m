//
//  DBFullScreenCollectionViewCell.m
//  Floor16
//
//  Created by Dim on 27.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBFullScreenCollectionViewCell.h"
#import "DBCacheManager.h"

@implementation DBFullScreenCollectionViewCell

#pragma mark - Public Methods

- (void)configureWithStringURL:(NSString *)stringURL {
    
    [self.activityIndicator startAnimating];
        
    self.imageView.image = nil;
    
    if ([[DBCacheManager defaultManager] imageForKey:stringURL]) {
        
        self.imageView.image = [[DBCacheManager defaultManager] imageForKey:stringURL];
        
        [self.activityIndicator stopAnimating];
        
    } else {
        
        [self performSelectorInBackground:@selector(loadImage:) withObject:stringURL];
    }
}

#pragma mark - Private Methods

- (void)loadImage:(NSString *)stringURL {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
    
    self.imageView.image = [UIImage imageWithData:imageData];
    
    [self.activityIndicator stopAnimating];
    
    [[DBCacheManager defaultManager] setImage:self.imageView.image forKey:stringURL];
}

@end
