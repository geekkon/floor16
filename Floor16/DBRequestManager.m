//
//  DBRequestManager.m
//  Floor16
//
//  Created by Dim on 29.03.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBRequestManager.h"
#import "DBListItem.h"
#import "DBJSONParser.h"
#import "DBFilterViewController.h"

NSString const * baseURL =  @"https://floor16.ru/api/pub";

@interface DBRequestManager ()

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSCharacterSet *percentEncodingSet;

@property (weak, nonatomic) id <DBRequestManagerDelegate> delegate;

@end

@implementation DBRequestManager

+ (DBRequestManager *)sharedManager {
    
    static DBRequestManager *manager = nil;
    
    @synchronized(self) {
        
        if (!manager) {
            
            manager = [[DBRequestManager alloc] init];
        }
    }
    
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.percentEncodingSet = [NSCharacterSet characterSetWithCharactersInString:@":{},[] "];
    }
    
    return self;
}

#pragma mark - Private Methods

- (NSString *)getQueryStringFromUserDefaults {
    
    NSUserDefaults *standartUserDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL shouldFilter = [standartUserDefaults boolForKey:kFilter];
    
    if (!shouldFilter) {
        
        return nil;
    }
    
    NSMutableArray *queryComponents = [NSMutableArray array];
        
    NSDictionary *appartmentType = [standartUserDefaults objectForKey:kFilterAppartment];
    
    if (appartmentType) {
        
        NSArray *appartmentKeys = [standartUserDefaults objectForKey:kFilterAppartmentKyes];
        
        NSMutableArray *appartmentTypeComponents = [NSMutableArray array];
        
        for (NSString *key in appartmentKeys) {
            
            if ([appartmentType[key] isEqualToString:@"YES"]) {
                
                [appartmentTypeComponents addObject:key];
            }
        }
        
        if ([appartmentTypeComponents count]) {
            
            NSString *queryComponent = @":appartment-type [";
            
            queryComponent = [queryComponent stringByAppendingString:[appartmentTypeComponents componentsJoinedByString:@" "]];
            
            queryComponent = [queryComponent stringByAppendingString:@"]"];
            
            [queryComponents addObject:queryComponent];
        }
    }
    
    NSInteger price = [standartUserDefaults integerForKey:kFilterPrice];
    
    if (price > 0) {
        
        NSString *queryComponent = [NSString stringWithFormat:@":price {:top %ld, :btm 0}", (long)price * 500];
        
        [queryComponents addObject:queryComponent];
    }
    
    BOOL withPhoto = [standartUserDefaults boolForKey:kFilterPhoto];

    if (withPhoto) {

        NSString *queryComponent = @":with-photo true";
        
        [queryComponents addObject:queryComponent];
    }
    
    NSString *resultQuery = nil;
    
    if ([queryComponents count]) {
        
        resultQuery = @"{";
        
        resultQuery = [resultQuery stringByAppendingString:[queryComponents componentsJoinedByString:@", "]];
        
        resultQuery = [resultQuery stringByAppendingString:@"}"];
        
    }
    
    return [resultQuery stringByAddingPercentEncodingWithAllowedCharacters:[self.percentEncodingSet invertedSet]];
}

#pragma mark - Public Methods

- (void)getItemsFromPage:(NSUInteger)page withDelegate:(id <DBRequestManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *pathComponent = [NSString stringWithFormat:@"?page=%lu", (unsigned long)page];
    
    NSString *requestURL = [baseURL stringByAppendingPathComponent:pathComponent];
    
    NSString *query = [self getQueryStringFromUserDefaults];

    if (query) {
        
        requestURL = [requestURL stringByAppendingFormat:@"&q=%@", query];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)getItemDetailsFromServerWithSeoid:(NSString *)seoid andDelegate:(id <DBRequestManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *requestURL = [baseURL stringByAppendingPathComponent:seoid];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - <NSURLConnectionDelegate>

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(requestManager:didFailWithError:)]) {
        [self.delegate requestManager:self didFailWithError:error];
    }
}

#pragma mark - <NSURLConnectionDataDelegate>

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    DBJSONParser *parser = [[DBJSONParser alloc] init];
    
    if ([self.delegate respondsToSelector:@selector(requestManager:didGetItems:totalCount:)]) {
        
        NSUInteger totalCount = 0;
        
        NSArray *items = [parser getItemsFromData:self.responseData totalCount:&totalCount];
        
        [self.delegate requestManager:self didGetItems:items totalCount:&totalCount];
    }
    
    if ([self.delegate respondsToSelector:@selector(requestManager:didGetItemDetails:)]) {
        
        DBItemDetails *itemDetails = [parser getItemDetailsFromData:self.responseData];
                
        [self.delegate requestManager:self didGetItemDetails:itemDetails];
    }
    
    self.responseData = nil;
}

@end
