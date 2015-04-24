//
//  DBCacheManager.h
//  Floor16
//
//  Created by Dim on 25.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface DBCacheManager : NSObject

+ (DBCacheManager *)defaultManager;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;

@end
