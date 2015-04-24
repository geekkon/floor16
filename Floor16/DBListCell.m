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

- (void)configureWithItem:(DBListItem *)item {
    
    UIImage *cellImage = nil;
    
    if (!item.thumb) {
        
        cellImage = [UIImage imageNamed:@"No_photo.png"];
        
    } else if ([[DBCacheManager defaultManager] imageForKey:item.thumb]) {
                
        cellImage = [[DBCacheManager defaultManager] imageForKey:item.thumb];
        
    } else {

        [self performSelectorInBackground:@selector(loadImage:) withObject:item.thumb];
    }

    self.picImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.picImageView.image = cellImage;
    
    self.dateLabel.text = item.created;

    self.priceLabel.text = [NSString stringWithFormat:@"%.0f руб.", item.price];
    
    self.picsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)item.imgs_cnt];
    
    self.picsCountLabel.alpha = item.imgs_cnt ? 1.0 : 0.0;

    self.streetLabel.text = item.address;
    
    self.detailLabel.text = [NSString stringWithFormat:@"Сдается %@ %.0fм2\nна %lu этаже %lu этажного дома",
                             item.appartment_type,
                             item.total_area,
                             (unsigned long)item.floor,
                             (unsigned long)item.floors];
}

#pragma mark - Private Methods

- (void)loadImage:(NSString *)itemThumb {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:itemThumb]];
    
    self.picImageView.image = [UIImage imageWithData:imageData];
    
    [[DBCacheManager defaultManager] setImage:self.picImageView.image forKey:itemThumb];
}

@end
