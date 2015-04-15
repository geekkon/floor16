//
//  DBListCell.m
//  Floor16
//
//  Created by Dim on 28.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBListCell.h"
#import "DBListItem.h"

@implementation DBListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithItem:(DBListItem *)item andCache:(NSCache *)thumbsCache {
    
    UIImage *cellImage = nil;
    
    if (!item.thumb) {
        
        cellImage = [UIImage imageNamed:@"No_photo.png"];
        
    } else if ([thumbsCache objectForKey:item.thumb]) {
        
        cellImage = [thumbsCache objectForKey:item.thumb];
        
    } else {
        
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.thumb]];
//        cellImage = [UIImage imageWithData:imageData];
//        
        [self performSelectorInBackground:@selector(loadImage:) withObject:[NSURL URLWithString:item.thumb]];
        
        
//        [thumbsCache setObject:cellImage forKey:item.thumb];
        
    }


    self.picImageView.contentMode = UIViewContentModeScaleToFill;

    
    self.picImageView.image = cellImage;
    
    self.dateLabel.text = item.created;

    self.priceLabel.text = [NSString stringWithFormat:@"%.0f руб.", item.price];
    
    if (item.imgs_cnt == 0) {
        self.picsCountLabel.alpha = 0.0;
    } else {
        self.picsCountLabel.alpha = 1.0;
        self.picsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)item.imgs_cnt];
    }
    
    self.streetLabel.text = item.address;
    
    self.detailLabel.text = [NSString stringWithFormat:@"Сдается %@ %.0fм2\nна %lu этаже %lu этажного дома",
                             item.appartment_type,
                             item.total_area,
                             (unsigned long)item.floor,
                             (unsigned long)item.floors];
}


#pragma mark - Private Methods

- (void)loadImage:(NSURL *)URL {
    
    NSData *imageData = [NSData dataWithContentsOfURL:URL];
    
    self.picImageView.image = [UIImage imageWithData:imageData];
}

@end
