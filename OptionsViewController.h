//
//  OptionsViewController.h
//  VEJ
//
//  Created by iD Student on 7/1/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface OptionsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) MFMailComposeViewController* myMail;


- (IBAction)sendFeedback:(id)sender;
@end
