//
//  DBRequestManager.m
//  Floor16
//
//  Created by Dim on 29.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBRequestManager.h"
#import "DBListItem.h"

@implementation DBRequestManager

+ (DBRequestManager *) sharedManager {
    
    static DBRequestManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBRequestManager alloc] init];
    });
    
    return manager;
}

- (NSArray *)getItemsFromServer {
    
    return nil;
}

@end
