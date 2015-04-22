//
//  DBWebViewController.m
//  Floor16
//
//  Created by Dim on 20.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBWebViewController.h"

@interface DBWebViewController () <UIWebViewDelegate>

@end

@implementation DBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *mechURL = @"https://floor16.ru/mech/";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:mechURL]];
    
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    
    [self.activityIndicator stopAnimating];
}

- (IBAction)actionClose:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
