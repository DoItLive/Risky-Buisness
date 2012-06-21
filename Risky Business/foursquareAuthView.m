//
//  foursquareAuthView.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
#import "foursquareAuthView.h"

#define kClientID         FOURSQUARE_CLIENT_ID
#define kCallbackURL      FOURSQUARE_CALLBACK_URL


@implementation foursquareAuthView

@synthesize foursquare = foursquare_;
@synthesize request = request_;
@synthesize meta = meta_;
@synthesize notifications = notifications_;
@synthesize response = response_;
@synthesize button,buttonText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    if (![foursquare_ isSessionValid]) {
        buttonText.text = [NSString stringWithFormat:@"Auth"];
    } else {
        buttonText.text = [NSString stringWithFormat:@"Check In"]; 
    }
   
    return self;
}

  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  - (void)drawRect:(CGRect)rect
  {
  // Drawing code
  }


- (void)setup
{
    NSLog(@"Token - %@", foursquare_.accessToken);
    if(!foursquare_.accessToken)
        [foursquare_ startAuthorization];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.foursquare = [[BZFoursquare alloc] initWithClientID:kClientID callbackURL:kCallbackURL];
        foursquare_.version = @"20111119";
        foursquare_.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        foursquare_.sessionDelegate = self;

    }
    return self;
}

- (void)dealloc {
    foursquare_.sessionDelegate = nil;
    [self cancelRequest];
}

-(IBAction)buttonPressed:(id)sender{
     foursquare_.accessToken = @"E0W0IUGH04Y21KTPN2HT0D0KJS104RK3GB44R1OT2OZXBA10";
    [self getUser];
    NSLog(@"%@", self.response);
}

#pragma mark -
#pragma mark BZFoursquareRequestDelegate

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
   
    self.request = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[error userInfo] objectForKey:@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark -
#pragma mark BZFoursquareSessionDelegate

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare {
    NSLog(@"Token for didAuthorize: %@",foursquare.accessToken);
    NSString *postString = [NSString stringWithFormat:@"%@", foursquare.accessToken];
    NSError *error = nil;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString* dataFilePath = [documentsDirectory stringByAppendingPathComponent:@"DBID.txt"];
    [postString writeToFile:dataFilePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    [postString release];
    [path release];
    [documentsDirectory release];
    [dataFilePath release];
}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, errorInfo);
}
#pragma mark -
#pragma mark Anonymous category



- (void)cancelRequest {
    if (request_) {
        request_.delegate = nil;
        [request_ cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest {
    [self cancelRequest];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
}

- (void)searchVenues {
    [self prepareForRequest];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"40.7,-74", @"ll", nil];
    self.request = [foursquare_ requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request_ start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)checkin {
    [self prepareForRequest];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"42377700f964a52024201fe3", @"venueId", @"public", @"broadcast", nil];
    self.request = [foursquare_ requestWithPath:@"checkins/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
    [request_ start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)getUser {
    [self prepareForRequest];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    self.request = [foursquare_ requestWithPath:@"users/self" HTTPMethod:@"GET" parameters:parameters delegate:self];
        NSLog(@"HERe");
    [request_ start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


@end*/
