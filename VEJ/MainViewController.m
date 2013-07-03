//
//  ViewController.m
//  VEJ
//
//  Created by iD Student on 7/1/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import "MainViewController.h"



#define METERS_PER_MILE 1609.344


@interface MainViewController ()


@end

@implementation MainViewController {
    CLLocationManager* locationManager;
    CLLocationCoordinate2D touchMapCoordinate;
}

@synthesize optionsViewController, mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = 1.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    UILongPressGestureRecognizer* longTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(processLongTouch:)];
    longTouch.minimumPressDuration = 1.5; //user needs to press for 1.5 seconds
    [mapView addGestureRecognizer:longTouch];
    NSLog(@"Hello World");
    
    NSDictionary *JSONData = [self populate];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"lat: %f lon: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}

-(void)processLongTouch:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    UIAlertView *annotationInfoAlert = [[UIAlertView alloc] initWithTitle:@"Add Location" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [annotationInfoAlert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[annotationInfoAlert textFieldAtIndex:1] setSecureTextEntry:NO];
    
    UITextField *annotationTitleTextField = [annotationInfoAlert textFieldAtIndex:0];
    annotationTitleTextField.placeholder = @"Name";
    
    UITextField *annotationSubtitleTextField = [annotationInfoAlert textFieldAtIndex:1];
    annotationSubtitleTextField.placeholder = @"Description";
    
    [annotationInfoAlert show];
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    NSString *titleText = [[alertView textFieldAtIndex:0] text];
    NSString *subtitleText = [[alertView textFieldAtIndex:1] text];
    if ([titleText length] > 0 && [subtitleText length] > 0) {
        return YES;
    } else {
        return NO;
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        MyMKAnnotation* annot = [[MyMKAnnotation alloc] initWithCoordinate:touchMapCoordinate];
        annot.coordinate = touchMapCoordinate;
        annot.title = [[alertView textFieldAtIndex:0] text];
        annot.subtitle = [[alertView textFieldAtIndex:1]text];
        [self persist:@{annot.title : @{
         @"subtitle": annot.subtitle,
         @"latitude": [NSString stringWithFormat:@"%f", touchMapCoordinate.latitude],
         @"longitude": [NSString stringWithFormat:@"%f", touchMapCoordinate.longitude]}
         }];
        
        [self.mapView addAnnotation:annot];
        NSLog(@"%@", [self populate]);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setTitle:@"VEJ"];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleBordered target:self action:@selector(tweetTapped:)];
    UIBarButtonItem *optionsButton =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Options"
     style: UIBarButtonItemStylePlain
     target:self action:@selector(switchToOptionsView:)];
    self.navigationItem.leftBarButtonItem = optionsButton;
    self.navigationItem.rightBarButtonItem = tweetButton;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}


-(IBAction)switchToOptionsView:(id)sender
{
    self.optionsViewController = [[UIViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.optionsViewController.title=@"Options";
    [self.navigationController pushViewController:self.optionsViewController animated:YES];
}

- (IBAction)postToFacebook:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
        [facebookPost setInitialText:@""];
        
        [self presentViewController:facebookPost animated:YES completion:nil];
    }

}

- (IBAction)getFeedback:(id)sender {
    if([MFMailComposeViewController canSendMail] == YES){
        //set up
        _myMail = [[MFMailComposeViewController alloc]init];
        _myMail.mailComposeDelegate = self;
        
        //set the subject
        [_myMail setSubject:@"App Feedback"];
        
        //recipients of feedback
        NSArray* toRecipients =[[NSArray alloc] initWithObjects:@"omszakaria@gmail.com", nil];
        [_myMail setToRecipients:toRecipients];
        
        //cc recips
        NSArray* ccRecipients =[[NSArray alloc] initWithObjects:@"", nil];
        [_myMail setCcRecipients:ccRecipients];
        
        //bcc recips
        NSArray* bccRecipients =[[NSArray alloc] initWithObjects:@"", nil];
        [_myMail setBccRecipients:bccRecipients];
        
        //add attachment
        UIImage* iconImage = [UIImage imageNamed:@"icon@114px.png"];
        NSData* imageData = UIImagePNGRepresentation(iconImage);
        [_myMail addAttachmentData:imageData mimeType:@"image/png" fileName:@"icon"];
        
        //adding text to message body
        NSString* sentFrom = @"Email sent from my app" ;
        [_myMail setMessageBody:sentFrom isHTML:YES];
        
        //display theviewcontroller
        [self presentViewController:_myMail animated:YES completion:Nil];
        
    }
    else{
        //error button
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This is device does not have email enabled" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [errorAlert show];
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)tweetTapped:(id)sender {
    {
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            [tweetSheet setInitialText:
             @""];
            [self presentModalViewController:tweetSheet animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"                                                   
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

-(BOOL) userHasAccessToTwitter{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

-(NSDictionary *)populate
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"data"]];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:path];
    
    NSError *error;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    [fileHandler closeFile];
    
    return jsonDictionary;
}

-(BOOL)persist:(NSDictionary*)info
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"data"]];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:path];
    //build an info object and convert to json
    
    //convert object to data
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [jsonData writeToFile:path options:NSDataWritingAtomic error:&error];
    [fileHandler closeFile];
    return true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
