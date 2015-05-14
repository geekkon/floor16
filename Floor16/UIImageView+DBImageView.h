//
//  UIImageView+DBImageView.h
//  Floor16
//
//  Created by Dim on 04.05.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DBImageView)

@property (strong, nonatomic) NSString *path;

-(void)setImage:(UIImage *)image byPath:(NSString *)path;

@end
