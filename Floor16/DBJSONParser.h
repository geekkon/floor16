//
//  DBJSONParser.h
//  Floor16
//
//  Created by Dim on 29.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBItemDetails;

@interface DBJSONParser : NSObject

- (NSArray *)getItemsFromData:(NSMutableData *)data;
- (DBItemDetails *)getItemDetailsFromData:(NSMutableData *)data;

@end
