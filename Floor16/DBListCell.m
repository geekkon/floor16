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

- (void)configureWithItem:(DBListItem *)item {
    
    if (item.thumb) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.thumb]];
        self.picImageView.image = [UIImage imageWithData:imageData];
    } else {
        self.picImageView.image = [UIImage imageNamed:@"No_photo.png"];
        self.picImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
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

@end
