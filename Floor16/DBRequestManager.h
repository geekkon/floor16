//
//  DBRequestManager.h
//  Floor16
//
//  Created by Dim on 29.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBRequestManager;
@class DBItemDetails;

@protocol DBRequestManagerDelegate <NSObject>

@optional
- (void)requestManager:(DBRequestManager *)manager didGetItems:(NSArray *)items totalCount:(NSUInteger *)totalCount;
- (void)requestManager:(DBRequestManager *)manager didGetItemDetails:(DBItemDetails *)itemDatails;
- (void)requestManager:(DBRequestManager *)manager didFailWithError:(NSError *)error;

@end


@interface DBRequestManager : NSObject

+ (DBRequestManager *) sharedManager;

- (void)getItemsFromPage:(NSUInteger)page withDelegate:(id <DBRequestManagerDelegate>)delegate;
- (void)getItemDetailsFromServerWithSeoid:(NSString *)seoid
                              andDelegate:(id <DBRequestManagerDelegate>)delegate;
@end
