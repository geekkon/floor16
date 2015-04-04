//
//  DBItemDetails.h
//  Floor16
//
//  Created by Dim on 04.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface DBItemDetails : NSObject

@property (strong, nonatomic) NSString      *appartment_type;
@property (strong, nonatomic) NSString      *created;

@property (assign, nonatomic) CGFloat       price;

@property (strong, nonatomic) NSString      *address;

@property (assign, nonatomic) CGFloat       total_area;

@property (assign, nonatomic) NSUInteger    floor;
@property (assign, nonatomic) NSUInteger    floors;

@property (strong, nonatomic) NSString      *building_type;

@property (strong, nonatomic) NSString      *person_name;

@property (strong, nonatomic) NSString      *seoid;

@property (assign, nonatomic) NSUInteger    imgs_cnt;
@property (strong, nonatomic) NSArray       *imgs;

@property (strong, nonatomic) NSString      *descr;

@property (assign, nonatomic) CGFloat       lng;
@property (assign, nonatomic) CGFloat       lat;

+ (DBItemDetails *)itemWithDictionary:(NSDictionary *)dictionary;

@end
