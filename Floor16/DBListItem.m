//
//  DBListItem.m
//  Floor16
//
//  Created by Dim on 28.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBListItem.h"

@implementation DBListItem

+ (DBListItem *)itemWithDictionary:(NSDictionary *)dictionary {
    
    DBListItem *listItem = [[DBListItem alloc] init];
    
    listItem.thumb = dictionary[@"thumb"];
    listItem.imgs_cnt = [dictionary[@"imgs-cnt"] integerValue];
    
    listItem.created = dictionary[@"created"];
    
    listItem.address = dictionary[@"address"];
    
    listItem.appartment_type = dictionary[@"appartment-type"];
    listItem.total_area = [dictionary[@"total-area"] floatValue];
    
    listItem.floor   = [dictionary[@"floor"] integerValue];
    listItem.floors  = [dictionary[@"floors"] integerValue];
    
    listItem.price = [dictionary[@"price"] floatValue];
    
    listItem.seoid = dictionary[@"seoid"];
    
    return listItem;
}


@end
