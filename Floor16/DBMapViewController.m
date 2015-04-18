//
//  DBMapViewController.m
//  Floor16
//
//  Created by Dim on 12.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "DBMapViewController.h"
#import "DBMapAnnotation.h"
@import MapKit;

@interface DBMapViewController () <MKMapViewDelegate>

@end

@implementation DBMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)configureMapView {
    
    static double delta = 5000.0;

    CLLocationCoordinate2D location = self.annotation.coordinate;
    
    MKMapPoint center = MKMapPointForCoordinate(location);
        
    MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
    
    rect = [self.mapView mapRectThatFits:rect];
    
    [self.mapView setVisibleMapRect:rect animated:YES];
    
    [self.mapView addAnnotation:self.annotation];
    
    [self.mapView selectAnnotation:self.annotation animated:YES];

}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    static NSString *identifier = @"Annotation";

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:identifier];
    pin.animatesDrop = YES;
    pin.canShowCallout = YES;
    
    return pin;
}

#pragma mark - Actions

- (IBAction)actionMapControl:(UISegmentedControl *)sender {
    
    self.mapView.mapType = sender.selectedSegmentIndex;
}

- (IBAction)actionFind:(UIBarButtonItem *)sender {
    
    [self.mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
}

@end
