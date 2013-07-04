//
//  MyMKAnnotation.h
//  VEJ
//
//  Created by iD Student on 7/3/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MyMKAnnotation : NSObject <MKAnnotation>

@property CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate;

@end
