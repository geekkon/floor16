//
//  DBRequestManager.h
//  Floor16
//
//  Created by Dim on 29.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBRequestManager : NSObject

+ (DBRequestManager *) sharedManager;

- (NSArray *)getItemsFromServer;

@end
