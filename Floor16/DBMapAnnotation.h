//
//  DBMapAnnotation.h
//  Floor16
//
//  Created by Dim on 12.04.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface DBMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end
