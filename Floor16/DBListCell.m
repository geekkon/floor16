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
    
    self.streetLabel.text = item.address;
    
    if (item.img_cnt == 0) {
        self.picsCountLabel.alpha = 0.0;
    }
}

@end
