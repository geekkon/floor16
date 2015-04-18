//
//  DBJSONParser.m
//  Floor16
//
//  Created by Dim on 29.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBJSONParser.h"
#import "DBListItem.h"
#import "DBItemDetails.h"

@implementation DBJSONParser

- (NSArray *)getItemsFromData:(NSMutableData *)data totalCount:(NSUInteger *)totalCount {
    
    NSError *error = nil;
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        
        NSLog(@"Error while parsing %@", [error localizedDescription]);
        return nil;
    }
        
    *totalCount = [dictionary[@"total"] integerValue];
    
    NSMutableArray *listItems = [NSMutableArray array];
    
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        
        NSDictionary *items = dictionary[@"items"];
        
        for (NSDictionary *item in items) {
            
            [listItems addObject:[DBListItem itemWithDictionary:item]];
        }
    }
    
    return listItems;
}

- (DBItemDetails *)getItemDetailsFromData:(NSMutableData *)data {
   
    NSError *error = nil;
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        
        NSLog(@"Error while parsing %@", [error localizedDescription]);
        
        return nil;
    }
    
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        
        DBItemDetails *itemDetails = [DBItemDetails itemWithDictionary:dictionary];
        
        return itemDetails;
    }
    
    return nil;
}

@end
