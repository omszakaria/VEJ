//
//  PlacesPoint.m
//  VEJ
//
//  Created by iD Student on 7/4/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import "PlacesPoint.h"


@implementation PlacesPoint

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate  {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        
    }
    return self;
}

-(NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

-(NSString *)subtitle {
    return _address;
}

@end
