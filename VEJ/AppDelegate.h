//
//  AppDelegate.h
//  VEJ
//
//  Created by iD Student on 7/1/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainViewController;

@property (strong, nonatomic) UINavigationController* navigationViewController;

@end
