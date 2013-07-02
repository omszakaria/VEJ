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

@interface MainViewController : UIViewController <CLLocationManagerDelegate>


@property (strong, nonatomic) UIViewController* optionsViewController;

-(IBAction)switchToOptionsView :(id)sender;
-(IBAction)tweetTapped:(id)sender;

@end
