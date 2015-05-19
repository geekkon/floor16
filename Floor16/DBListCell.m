//
//  DBListCell.m
//  Floor16
//
//  Created by Dim on 28.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBListCell.h"
#import "DBListItem.h"
#import "DBCacheManager.h"
#import "UIImageView+DBImageView.h"

NSString * const kNoPhoto = @"No_photo.png";

@interface DBListCell ()

@end

@implementation DBListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureWithItem:(DBListItem *)item {
    
    [self.activityIndicator startAnimating];
    
    NSString *itemThumb = item.thumb ? item.thumb : kNoPhoto;

    self.picImageView.path = itemThumb;
    
    UIImage *cellImage = [[DBCacheManager defaultManager] imageForKey:itemThumb];
    
    if (!cellImage) {
        
        [self performSelectorInBackground:@selector(loadImage:) withObject:itemThumb];
        
    } else {
        
        [self.activityIndicator stopAnimating];
    }
    
    self.picImageView.contentMode = UIViewContentModeScaleToFill;
        
    [self.picImageView setImage:cellImage byPath:itemThumb];
    
    self.dateLabel.text = item.created;
    self.priceLabel.text = [NSString stringWithFormat:@"%.0f руб.", item.price];
    self.picsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)item.imgs_cnt];
    self.picsCountLabel.alpha = item.imgs_cnt ? 1.0 : 0.0;
    self.streetLabel.text = item.address;
    self.detailLabel.text = [NSString stringWithFormat:@"Сдается %@ %.0fм2\nна %lu этаже %lu этажного дома", item.appartment_type,
                        item.total_area,
                        (unsigned long)item.floor,
                        (unsigned long)item.floors];
}

#pragma mark - Private Methods

- (void)loadImage:(NSString *)itemThumb {
    
    UIImage *cellImage = nil;
    
    if ([itemThumb isEqualToString:kNoPhoto]) {
        
        cellImage = [UIImage imageNamed:kNoPhoto];
        
    } else {
    
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:itemThumb]];
        
        cellImage = [UIImage imageWithData:imageData];
    }
    
    [self.picImageView setImage:cellImage byPath:itemThumb];
    
    [self.activityIndicator stopAnimating];
    
    [[DBCacheManager defaultManager] setImage:cellImage forKey:itemThumb];
}

@end
