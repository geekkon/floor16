//
//  DBItemDetails.m
//  Floor16
//
//  Created by Dim on 04.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBItemDetails.h"

@implementation DBItemDetails

+ (DBItemDetails *)itemWithDictionary:(NSDictionary *)dictionary {
    
    DBItemDetails *itemDetails = [[DBItemDetails alloc] init];
    
    itemDetails.appartment_type = dictionary[@"appartment_type"];
    itemDetails.created = dictionary[@"created"];

    itemDetails.price = [dictionary[@"price"] floatValue];
        
    itemDetails.address = dictionary[@"address"];
    
    itemDetails.total_area = [dictionary[@"total-area"] floatValue];

    itemDetails.floor   = [dictionary[@"floor"] integerValue];
    itemDetails.floors  = [dictionary[@"floors"] integerValue];
    
    itemDetails.address = dictionary[@"building_type"];
    
    itemDetails.person_name = dictionary[@"person-name"];

    itemDetails.seoid = dictionary[@"seoid"];
    
    itemDetails.imgs_cnt = [dictionary[@"imgs-cnt"] integerValue];
    
    itemDetails.imgs = dictionary[@"imgs"];

    itemDetails.descr = dictionary[@"description"];

    itemDetails.lng = [dictionary[@"lng"] floatValue];
    itemDetails.lat = [dictionary[@"lat"] floatValue];

    return itemDetails;
}

@end
