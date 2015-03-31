//
//  DBRequestManager.h
//  Floor16
//
//  Created by Dim on 29.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBRequestManager;

@protocol DBRequestManagerDelegate <NSObject>

- (void)requestManager:(DBRequestManager *)manager didGetItems:(NSArray *)items;
- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error;

@end


@interface DBRequestManager : NSObject

+ (DBRequestManager *) sharedManager;

- (void)getItemsFromServerWithDelegate:(id <DBRequestManagerDelegate>)delegate;

@end
