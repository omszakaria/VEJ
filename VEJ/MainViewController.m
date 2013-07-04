//
//  ViewController.m
//  VEJ
//
//  Created by iD Student on 7/1/13.
//  Copyright (c) 2013 Omar Zakaria. All rights reserved.
//

#import "MainViewController.h"
#import "OptionsViewController.h"
#import "PlacesPoint.h"
#import "MyMKAnnotation.h"

#define METERS_PER_MILE 1609.344
#define kGOOGLE_API_KEY @"AIzaSyDtxWghvIaNEEiw6MkA8QE3AAoMHQ9uSzM"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MainViewController ()


@end

@implementation MainViewController {
    CLLocationManager* locationManager;
    CLLocationCoordinate2D touchMapCoordinate;
    CLLocation *currentLocation;
    int searchDistance;
    NSString *pressedButtonTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = 1.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    UILongPressGestureRecognizer* longTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(processLongTouch:)];
    longTouch.minimumPressDuration = 1.0; //user needs to press for 1.0 seconds
    [self.mapView addGestureRecognizer:longTouch];
    
    // set navbar items
    [self.navigationItem setTitle:@"VEJ"];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0]];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleBordered target:self action:@selector(tweetTapped:)];
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style: UIBarButtonItemStylePlain target:self action:@selector(switchToOptionsView:)];
    self.navigationItem.leftBarButtonItem = optionsButton;
    self.navigationItem.rightBarButtonItem = tweetButton;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSDictionary *JSONData = [self populate];
    if (JSONData != nil) {
        [self populateMap:JSONData];
    }
    
    //load settings.plist
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"settings.plist"]];
    NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    if (settingsDictionary == nil) {
        settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]];
    }
    int mapType = [[settingsDictionary objectForKey:@"mapType"] intValue];
    int trackingMode = [[settingsDictionary objectForKey:@"trackingMode"] intValue];
    int settingsSearchDistance = [[settingsDictionary objectForKey:@"searchDistance"] intValue];
    if (mapType == 1) {
        self.mapView.mapType = MKMapTypeSatellite;
    } else if (mapType == 2) {
        self.mapView.mapType = MKMapTypeHybrid;
    } else {
        self.mapView.mapType = MKMapTypeStandard;
    }
    if (trackingMode == 0) {
        self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    } else if (trackingMode == 1){
        self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    } else {
        self.mapView.userTrackingMode = MKUserTrackingModeNone;
    }

    searchDistance = settingsSearchDistance;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations lastObject];
    NSLog(@"lat: %f lon: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}

-(void)populateMap:(NSDictionary*) data
{
    NSLog(@"keys: %@", [data allKeys]);
    NSLog(@"values: %@", [data allValues]);
    
    for(NSString* title in [data allKeys]){
        NSDictionary* locData = [data objectForKey:title];
        //lat
        NSString* latitude = [locData objectForKey:@"latitude"];
        //long
        NSString* longitude = [locData objectForKey:@"longitude"];
        //subtitle
        NSString* subtitle = [locData objectForKey:@"subtitle"];
            
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        MyMKAnnotation* annot = [[MyMKAnnotation alloc] initWithTitle:title subtitle:subtitle coordinate:coordinate];
        
        [self.mapView addAnnotation:annot];
    }
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
        MyMKAnnotation* annot = [[MyMKAnnotation alloc] initWithTitle:[[alertView textFieldAtIndex:0] text] subtitle:[[alertView textFieldAtIndex:1]text] coordinate:touchMapCoordinate];
        
        NSDictionary* newEntry = @{annot.title : @{
                                           @"subtitle": annot.subtitle,
                                           @"latitude": [NSString stringWithFormat:@"%f", touchMapCoordinate.latitude],
                                           @"longitude": [NSString stringWithFormat:@"%f", touchMapCoordinate.longitude]}
                                   };
        NSMutableDictionary* persistedData = [NSMutableDictionary dictionaryWithDictionary:[self populate]];
        [persistedData setValuesForKeysWithDictionary:newEntry];
        
        [self persist:persistedData];
        
        [self.mapView addAnnotation:annot];
        NSLog(@"%@", [self populate]);
    }
}



- (IBAction)toolBarButtonPressed:(UIBarButtonItem *)sender {
    pressedButtonTitle = [sender.title lowercaseString];
    [self queryGooglePlaces:pressedButtonTitle];
}

-(void) queryGooglePlaces: (NSString *) googleType {
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, [NSString stringWithFormat:@"%i", searchDistance], googleType, kGOOGLE_API_KEY];
    NSLog(@"%@", url);
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Plot points
    [self plotPositions:places];
}

-(IBAction)switchToOptionsView:(id)sender
{
    self.optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
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
            [self presentViewController:tweetSheet animated:YES completion:nil];
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
    if (data != nil) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
        [fileHandler closeFile];
        return jsonDictionary;
    } else {
        [fileHandler closeFile];
        return nil;
    }
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

-(void)plotPositions:(NSArray *)data {
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[PlacesPoint class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    // 2 - Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        // 5 - Create a new annotation.
        PlacesPoint *placePoint = [[PlacesPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [self.mapView addAnnotation:placePoint];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if ([annotation isKindOfClass:[MyMKAnnotation class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"MyCustomAnnotation";
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        
        return annotationView;
    }
    else if ([annotation isKindOfClass:[PlacesPoint class]]) // use whatever annotation class you used when creating the annotation
    {
        static NSString * const identifier = @"PlacesAnnotation";
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorRed;
        
        return annotationView;
    }
    return nil;
}

@end
