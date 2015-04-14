//
//  DBMapViewController.h
//  Floor16
//
//  Created by Dim on 12.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DBMapAnnotation;
@class MKMapView;

@interface DBMapViewController : UIViewController

@property (strong, nonatomic) DBMapAnnotation *annotation;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)actionMapControl:(UISegmentedControl *)sender;
- (IBAction)actionSearch:(UIBarButtonItem *)sender;

@end
