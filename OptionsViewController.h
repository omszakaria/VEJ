//
//  OptionsViewController.h
//  VEJ
//
//  Created by iD Student on 7/1/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface OptionsViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *searchDistanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *searchDistanceSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *trackingModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (strong, nonatomic) MFMailComposeViewController* myMail;
@property (weak, nonatomic) IBOutlet UIImageView *optionsViewIcon;

- (IBAction)changeMapType:(UISegmentedControl *)sender;
- (IBAction)changeSearchDistance:(UISlider *)sender;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)resetData:(id)sender;

- (IBAction)changeTrackingMode:(UISegmentedControl *)sender;

@end
