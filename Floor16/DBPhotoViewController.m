//
//  DBPhotoViewController.m
//  Floor16
//
//  Created by Dim on 19.05.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBPhotoViewController.h"
#import "DBCacheManager.h"
#import "UIImageView+DBImageView.h"

@interface DBPhotoViewController ()

@end

@implementation DBPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
}

#pragma mark - Private Methods

- (void)configureView {
    
    if (self.photoURLs) {
        
        [self loadImageByIndex:self.currentIndex];
        
        self.photoLabel.text = [NSString stringWithFormat:@"%lu / %lu",
                                (unsigned long)self.currentIndex + 1, (unsigned long)self.photoCount];

        [self configureButtons];
    }
}

- (void)loadImageByIndex:(NSUInteger)index {

    [self.activityIndicator startAnimating];
    
    if (index < self.photoCount) {
        
        NSString *photoURL = self.photoURLs[index];
        
        self.imageView.path = photoURL;
        
        UIImage *image = [[DBCacheManager defaultManager] imageForKey:photoURL];
        
        if (!image) {
            
            [self performSelectorInBackground:@selector(loadImage:) withObject:photoURL];
            
        } else {
            
            [self.activityIndicator stopAnimating];
        }
        
        [self.imageView setImage:image byPath:photoURL];
    }
}

- (void)loadImage:(NSString *)photoURL {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    [self.imageView setImage:image byPath:photoURL];
        
    [self.activityIndicator stopAnimating];
    
    [[DBCacheManager defaultManager] setImage:image forKey:photoURL];
}

- (void)configureButtons {
    
    self.leftButton.enabled = self.currentIndex == 0 ? NO : YES;
    self.rightButton.enabled = self.currentIndex == self.photoCount - 1 ? NO : YES;
}

#pragma mark - Actions

- (IBAction)showPrevious:(UIBarButtonItem *)sender {
    
    self.currentIndex--;
    
    [self configureView];
}

- (IBAction)showNext:(UIBarButtonItem *)sender {
    
    self.currentIndex++;
    
    [self configureView];
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {

    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
