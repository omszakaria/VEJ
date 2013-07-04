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

@end
