//
//  OptionsViewController.m
//  VEJ
//
//  Created by iD Student on 7/1/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

@synthesize myMail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"OptionsViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)sendFeedback:(id)sender {
//   
//    if([MFMailComposeViewController canSendMail] == YES){
//        //set up
//        myMail = [[MFMailComposeViewController alloc]init];
//        myMail.mailComposeDelegate = self;
//        
//        //set the subject
//        [myMail setSubject:@"App Feedback"];
//        
//        //recipients of feedback
//        NSArray* toRecipients =[[NSArray alloc] initWithObjects:@"omszakaria@gmail.com", nil];
//        [myMail setToRecipients:toRecipients];
//        
//        //cc recips
//        NSArray* ccRecipients =[[NSArray alloc] initWithObjects:@"", nil];
//        [myMail setCcRecipients:ccRecipients];
//        
//        //bcc recips
//        NSArray* bccRecipients =[[NSArray alloc] initWithObjects:@"", nil];
//        [myMail setBccRecipients:bccRecipients];
//        
//        //add image
//        
//        
//        //adding text to message body
//         NSString* sentFrom = @"Email sent from my app" ;
//        [myMail setMessageBody:sentFrom isHTML:YES];
//        
//        //display theviewcontroller
//        [self presentViewController:myMail animated:YES completion:Nil];
//
//    }
//    else{
//       //error button
//        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This is device does not have email enabled" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//        [errorAlert show];
//    }
//       
//}
@end
