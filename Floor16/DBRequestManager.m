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
@property (weak, nonatomic) id <DBRequestManagerDelegate> delegate;
@property (strong, nonatomic) NSCharacterSet *percentEncodingSet;

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
    
    BOOL shouldFilter = [[NSUserDefaults standardUserDefaults] boolForKey:kFilter];
    
    if (!shouldFilter) {
        
        return nil;
    }
    
    NSString *query = [NSString string];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFilterPhoto]) {
        
        query = [query stringByAppendingPathComponent:@"%7B%3Awith-photo%20true%7D"];
    }
    
    
    return query.length ? query : nil;

//    
//    self.photoSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kFilterPhoto];
//    
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:kFilterPrice]) {
//        
//        self.priceSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kFilterPrice];
//    }
}


#pragma mark - Public Methods

- (void)getItemsFromPage:(NSUInteger)page withDelegate:(id <DBRequestManagerDelegate>)delegate {
    
    NSString *query = [self getQueryStringFromUserDefaults];
    
    if (query) {
        
        query = [@"{:price {:top 10000, :btm 0}, :with-photo true}" stringByAddingPercentEncodingWithAllowedCharacters:[self.percentEncodingSet invertedSet]];
    }
    
    /*
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"with-photo"] = @"true";
    
    NSURLComponents *components = [NSURLComponents componentsWithString:baseURL];
   
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"with-photo" value:@"true"];
    
    components.queryItems = @[queryItem];
    
    NSURL *url = components.URL;
    
    NSLog(@"%@",url);
    */
    
    self.delegate = delegate;
    
    NSString *pathComponent = [NSString stringWithFormat:@"?page=%lu", (unsigned long)page];
    
    NSString *requestURL = [baseURL stringByAppendingPathComponent:pathComponent];
    
    if (query) {
        
        requestURL = [requestURL stringByAppendingFormat:@"&q=%@", query];
    }

    /*
    NSString *addedString = @"";
    
    if ([params count]) {
        
        addedString = [[addedString stringByAppendingString:@"&q: {"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonBaseCharacterSet]];
        
        requestURL = [requestURL stringByAppendingString:addedString];
    }

    for (NSString *key in params) {
        
        requestURL = [requestURL stringByAppendingFormat:@":%@ %@", key, params[key]];
        
    }
    
    if ([params count]) {
        requestURL = [requestURL stringByAppendingString:@"}"];
    }
    
//    requestURL = [requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonBaseCharacterSet]];
    
    NSLog(@"%@", requestURL);
    
    NSLog(@"%@", [@"%7B%3A" stringByRemovingPercentEncoding]);
    NSLog(@"%@", [@"{:" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonBaseCharacterSet]]);
    NSLog(@"%@", [@" " stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonBaseCharacterSet]]);
    NSLog(@"%@", [@"}" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonBaseCharacterSet]]);

    
  

    */
    
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
