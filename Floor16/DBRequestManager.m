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
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBRequestManager alloc] init];
    });
    
    return manager;
}

- (void)getItemsFromServerWithDelegate:(id <DBRequestManagerDelegate>)delegate {
    
    self.delegate = delegate;
    
    NSString *requestURL = [baseURL stringByAppendingString:@"?page=1"];

    
    
//    NSString *requestURL = [baseURL stringByAppendingString:@"?page=1&q={:with-photo true}"];
    
//    baseURL = [baseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonBaseCharacterSet]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}


#pragma mark - NSURLConnectionDataDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    
    NSLog(@"willSendRequest %@", request);
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.responseData = [NSMutableData data];
    
    NSLog(@"didReceiveResponse %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSLog(@"didReceiveData");
    
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"connectionDidFinishLoading");
    
    DBJSONParser *parser = [[DBJSONParser alloc] init];
        
    NSArray *items = [parser getItemsFromData:self.responseData];
    
    [self.delegate requestManager:self didGetItems:items];
    
    self.responseData = nil;
}

@end
