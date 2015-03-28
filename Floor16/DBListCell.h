//
//  DBListCell.h
//  Floor16
//
//  Created by Dim on 28.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *picsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
