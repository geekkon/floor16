//
//  DBListItem.h
//  Floor16
//
//  Created by Dim on 28.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface DBListItem : NSObject

@property (strong, nonatomic) NSString   *thumb;
@property (assign, nonatomic) NSUInteger imgs_cnt;

@property (strong, nonatomic) NSString  *created;

@property (strong, nonatomic) NSString  *address;

@property (strong, nonatomic) NSString  *appartment_type;
@property (assign, nonatomic) CGFloat   total_area;

@property (assign, nonatomic) NSUInteger floor;
@property (assign, nonatomic) NSUInteger floors;
@property (strong, nonatomic) NSString   *building_type;

@property (assign, nonatomic) CGFloat   price;

@property (strong, nonatomic) NSString  *seoid;

+ (DBListItem *)itemWithDictionary:(NSDictionary *)dictionary;

@end
