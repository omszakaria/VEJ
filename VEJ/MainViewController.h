//
//  ViewController.h
//  VEJ
//
//  Created by iD Student on 7/1/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "MyMKAnnotation.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) UIViewController* optionsViewController;
@property (weak, nonatomic) IBOutlet MKMapView* mapView;


- (IBAction)switchToOptionsView :(id)sender;

- (IBAction)postToFacebook:(id)sender;

@end
