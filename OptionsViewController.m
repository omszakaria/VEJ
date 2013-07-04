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


- (IBAction)sendFeedback:(id)sender {
    NSLog(@"send feedback button pressed");
    if([MFMailComposeViewController canSendMail] == YES){
        //set up
        myMail = [[MFMailComposeViewController alloc]init];
        myMail.mailComposeDelegate = self;
        
        //set the subject
        [myMail setSubject:@"App Feedback"];
        
        //recipients of feedback
        NSArray* toRecipients =[[NSArray alloc] initWithObjects:@"omszakaria@gmail.com", nil];
        [myMail setToRecipients:toRecipients];

        //cc recips
        NSArray* ccRecipients =[[NSArray alloc] initWithObjects:@"", nil];
        [myMail setCcRecipients:ccRecipients];
        
        //bcc recips
        NSArray* bccRecipients =[[NSArray alloc] initWithObjects:@"", nil];
        [myMail setBccRecipients:bccRecipients];
        
        //add attachment
        UIImage* iconImage = [UIImage imageNamed:@"icon@114px.png"];
        NSData* imageData = UIImagePNGRepresentation(iconImage);
        [myMail addAttachmentData:imageData mimeType:@"image/png" fileName:@"icon"];
        
        //adding text to message body
         NSString* sentFrom = @"Email sent from my app" ;
        [myMail setMessageBody:sentFrom isHTML:YES];
        
        //display theviewcontroller
        [self presentViewController:myMail animated:YES completion:Nil];

    }
    else{
       //error button
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This is device does not have email enabled" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [errorAlert show];
    }
       
}

- (IBAction)resetData:(id)sender {
    UIActionSheet* deleteConf = [[UIActionSheet alloc]initWithTitle:@"Are you sure you want to delete all your saved locations?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
    
    [deleteConf showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == actionSheet.destructiveButtonIndex){
        NSError* error;
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"data"]];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"Error deleting data: %@", error.localizedDescription);
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

@end
