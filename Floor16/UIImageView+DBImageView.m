//
//  UIImageView+DBImageView.m
//  Floor16
//
//  Created by Dim on 04.05.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "UIImageView+DBImageView.h"
//#import <objc/runtime.h>
@import ObjectiveC;

@implementation UIImageView (DBImageView)

//@dynamic path;

- (NSString *)path {
    
    return objc_getAssociatedObject(self, @selector(path));
}

- (void)setPath:(NSString *)path {
    
    objc_setAssociatedObject(self, @selector(path), path, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setImage:(UIImage *)image byPath:(NSString *)path {
    
    if ([path isEqualToString:self.path]) {
        
        [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
//        self.image = image;
    }
}

@end
