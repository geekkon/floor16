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

NSString const * baseURL =  @"https://floor16.ru/api/pub";

@interface DBRequestManager ()

@property (strong, nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) id <DBRequestManagerDelegate> delegate;

@end

@implementation DBRequestManager

+ (DBRequestManager *) sharedManager {
    
    static DBRequestManager *manager = nil;
    
    if (!manager) {
        
        manager = [[DBRequestManager alloc] init];
    }
    
    return manager;
}

- (void)getItemsFromPage:(NSUInteger)page withDelegate:(id <DBRequestManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *pathComponent = [NSString stringWithFormat:@"?page=%lu", (unsigned long)page];
    
    NSString * requestURL = [baseURL stringByAppendingPathComponent:pathComponent];
    
//    NSString *requestURL = [baseURL stringByAppendingString:@"?page=1&q={:with-photo true}"];
    
//    baseURL = [baseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonBaseCharacterSet]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)getItemDetailsFromServerWithSeoid:(NSString *)seoid andDelegate:(id <DBRequestManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *requestURL = [baseURL stringByAppendingPathComponent:seoid];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(requestManager:didFailWithError:)]) {
        [self.delegate requestManager:self didFailWithError:error];
    }
}


#pragma mark - NSURLConnectionDataDelegate

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
