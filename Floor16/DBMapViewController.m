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
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
}
*/


#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {

    
    self.annotation.coordinate = self.mapView.region.center;
    
    [self.mapView addAnnotation:self.annotation];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    static NSString* identifier = @"Annotation";
    
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinColor = MKPinAnnotationColorRed;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
    } else {
        pin.annotation = annotation;
    }
    
    return pin;
}


#pragma mark - Actions

- (IBAction)actionMapControl:(UISegmentedControl *)sender {
    
    self.mapView.mapType = sender.selectedSegmentIndex;
}

@end
