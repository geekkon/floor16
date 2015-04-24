//
//  DBCacheManager.m
//  Floor16
//
//  Created by Dim on 25.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBCacheManager.h"

@interface DBCacheManager()

@property (strong, nonatomic) NSCache *cache;

@end

@implementation DBCacheManager

+ (DBCacheManager *) defaultManager {
    
    static DBCacheManager *manager = nil;
    
    if (!manager) {
        
        manager = [[DBCacheManager alloc] init];
        
    }
    
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.cache = [[NSCache alloc] init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    
    [self.cache setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    
    return [self.cache objectForKey:key];
}

@end
