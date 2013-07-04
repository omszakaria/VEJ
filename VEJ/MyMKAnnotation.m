//
//  MyMKAnnotation.m
//  VEJ
//
//  Created by iD Student on 7/3/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import "MyMKAnnotation.h"

@implementation MyMKAnnotation

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate
{
    self.coordinate = coordinate;
    self.title = title;
    self.subtitle = subtitle;
    return self;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[MyMKAnnotation class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView)
        {
            annotationView.annotation = annotation;
        }
        else
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"icon.png"];
        
        return annotationView;
    }
    return nil;
}

@end
