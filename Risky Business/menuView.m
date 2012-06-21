//
//  menuView.m
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "menuView.h"

#define kClientID         FOURSQUARE_CLIENT_ID
#define kCallbackURL      FOURSQUARE_CALLBACK_URL
#define numVenues 10

@implementation menuView

@synthesize checkInButton, mapButton, storeButton, manageVenuesButton, optionsButton, token, user, leftBuilding, rightBuilding, shadow, selection;
////////////////////////
@synthesize foursquare = foursquare_;
@synthesize request = request_;
@synthesize meta = meta_;
@synthesize notifications = notifications_;
@synthesize response = response_;
@synthesize s;
@synthesize name;
@synthesize info;
@synthesize venue;
/////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithPlayer:(Player*)u{
    
    user = u;
    return self;
    
}

- (void)setup
{
    s = 0;
    foursquare_.accessToken = token;
    
    NSLog(@"Token - %@", foursquare_.accessToken);
    if(!foursquare_.isSessionValid)
        [foursquare_ startAuthorization];
    
    
    self.info = [[NSMutableArray alloc] init];
    venue = [[NSDictionary alloc] init];
    
    [self setUpAnimations];

}

-(void)setUpAnimations{
    leftBuilding.frame =  CGRectMake(-50, leftBuilding.frame.size.height,leftBuilding.frame.size.width,leftBuilding.frame.size.height);  
    [UIView beginAnimations: @"lB" context: nil];
    [UIView setAnimationDelegate: self];   
    [UIView setAnimationDuration: 1.0];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];  
    leftBuilding.frame =  CGRectMake(-50, 0,leftBuilding.frame.size.width,leftBuilding.frame.size.height);  
    [UIView commitAnimations]; 
    
    rightBuilding.frame =  CGRectMake(300, 81,rightBuilding.frame.size.width,rightBuilding.frame.size.height);
    [UIView beginAnimations: @"rB" context: nil];   
    [UIView setAnimationDelegate: self];   
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];  
    rightBuilding.frame =  CGRectMake(180, 81,rightBuilding.frame.size.width,rightBuilding.frame.size.height);  
    [UIView commitAnimations];

    checkInButton.frame =  CGRectMake(0, 460,64,64);
    mapButton.frame =  CGRectMake(64, 460,64,64);
    manageVenuesButton.frame =  CGRectMake(128, 460,64,64);
    storeButton.frame =  CGRectMake(192, 460,64,64);
    optionsButton.frame =  CGRectMake(256, 460,64,64);
    shadow.frame = CGRectMake(0, 438, 320, 22);

    [UIView beginAnimations: @"cIB" context: nil];   
    [UIView setAnimationDelegate: self];   
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];  
    checkInButton.frame =  CGRectMake(0, 396,64,64);  
    mapButton.frame =  CGRectMake(64, 396,64,64);
    manageVenuesButton.frame =  CGRectMake(128, 396,64,64);
    storeButton.frame =  CGRectMake(192, 396,64,64);
    optionsButton.frame =  CGRectMake(256, 396,64,64);
    shadow.frame = CGRectMake(0, 374, 320, 22);
    [UIView commitAnimations];
    
}



-(IBAction)checkInPressed:(id)sender{
    
    if( [user.armySize intValue] > 0)
        [self getUser];
    else{
        NSLog(@"army size is 0 bro");        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You need an army..." message:@"Your army size is 0" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

}
-(void)checkInPressedDone{
    
    switch (s) {
        case 0:{
            //NSDictionary *dict = [[self.response objectForKey:@"venues"] objectAtIndex:0];
            //NSLog(@"%d", [dict count]);

           // NSLog(@"%@",self.response);
            NSString *data = [[NSString alloc] initWithFormat:@"%@", self.response];
            NSMutableArray  *items = [[NSMutableArray alloc] initWithArray:[data componentsSeparatedByString:(@"firstName = ")]];
            NSUInteger i = 0;
            while([[items objectAtIndex:(1)] characterAtIndex:(i++)] != ';');
            NSString *first = [[NSString alloc] initWithString:[[items objectAtIndex:(1)] substringToIndex:(i-1)]];
            NSLog(@"%@", first);
            [items removeAllObjects];
            [items release];
            items = [[NSMutableArray alloc] initWithArray:[data componentsSeparatedByString:(@"lastName = ")]];
            i = 0;
            while([[items objectAtIndex:(items.count - 1)] characterAtIndex:(i++)] != ';');
            NSString *last = [[NSString alloc] initWithString:[[items objectAtIndex:(items.count - 1)] substringToIndex:(i-1)]];
            NSLog(@"%@", last);
            name = [[NSString alloc] initWithFormat:@"%@_%@", first, last];
            s++;
            NSLog(@"lat = %lf, long = %lf", latitude, longitude);
            [self searchVenues];
            
            [data release];
            [items release];
            [first release];
            [last release];
            break;}
        case 1:{
            //NSString *tmp = [[NSString alloc] initWithFormat:@"%@", self.response];
            //NSLog(@"%@", [[tmp stringByReplacingOccurrencesOfString:@" " withString:@"#"] stringByReplacingOccurrencesOfString:@"\n" withString:@"~\n"]);
            [self parseVenues];
            
            s++;
            
            NSInteger checkInViewNum = 7;
            NSNumber *newMode = [[NSNumber alloc] initWithInt:checkInViewNum];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:newMode, @"switchView",info, @"venues", nil];
            NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            break;}
        default:{
            NSLog(@"reset s");
            
            s = 0;
            
            break;
        }
           
    }
    
}

-(void) setSelection:(NSInteger)incoming{
    selection = incoming;
    [venue release];
    venue = [[NSDictionary alloc] initWithDictionary:[info objectAtIndex:selection]];
    [self checkin];
}

-(void)parseVenues{
    NSString *fullString = [[NSString alloc] initWithFormat:@"%@", self.response];
    NSString *data = [[NSString alloc] initWithString:[[fullString componentsSeparatedByString:@"{\n    venues =     (\n                "] objectAtIndex:1]];
    [fullString release];
    NSString *venueData[numVenues];
    int j;
    NSUInteger k = 0;
    NSUInteger base;
    NSUInteger limit;
    for (int i = 0; i < numVenues; i++) {
        while([data characterAtIndex:k++] != '{');
        base = k;
        limit = 0;
        j = 1;
        while(j != 0){
            if([data characterAtIndex:k] == '{')
                j++;
            else if([data characterAtIndex:k] == '}')
                j--;
            k++;
            limit++;
        }
        venueData[i] = [[NSString alloc] initWithString:[data substringWithRange:NSMakeRange(base+1, limit-2)]];
        
    }
 
    
    NSString *venueName, *ident, *lat, *lon;
    //NSLog(@"%@", venueData[0]);
    //NSLog(@"%@", venueData[1]);
    for (int i = 0; i < numVenues; i++) {
        
        k = 0;
        while ([venueData[i] characterAtIndex:k] == ' ')
            k++;
        while(k < [venueData[i] length]){
            base = k;
            limit = 0;
            while ([venueData[i] characterAtIndex:k] != ' ') {
                limit++;
                k++;
            }
            if ([[venueData[i] substringWithRange:NSMakeRange(base, limit)] isEqualToString:@"categories"] || [[venueData[i] substringWithRange:NSMakeRange(base, limit)] isEqualToString:@"specials"]) {  
                while ([venueData[i] characterAtIndex:k++] != '(');
                j = 1;
                while(j != 0){
                    if([venueData[i] characterAtIndex:k] == '(')
                        j++;
                    else if([venueData[i] characterAtIndex:k] == ')')
                        j--;
                    k++;
                }
                k++;

            }
            else if ([[venueData[i] substringWithRange:NSMakeRange(base, limit)] isEqualToString:@"name"]) {
                while ([venueData[i] characterAtIndex:k] == ' ' || [venueData[i] characterAtIndex:k] == '='){
                    k++;
                };
                base = k;
                limit = 0;
                while ([venueData[i] characterAtIndex:k++] != ';') {
                    limit++;
                }
                if ([venueData[i] characterAtIndex:k-2] == '"')
                    venueName = [[NSString alloc] initWithString:[venueData[i] substringWithRange:NSMakeRange(base + 1, limit - 2)]];
                else
                    venueName = [[NSString alloc] initWithString:[venueData[i] substringWithRange:NSMakeRange(base, limit)]];
                //NSLog(@"%@", venueName);

            }
            else if([[venueData[i] substringWithRange:NSMakeRange(base, limit)] isEqualToString:@"id"]){
                while ([venueData[i] characterAtIndex:k] == ' ' || [venueData[i] characterAtIndex:k] == '='){
                    k++;
                };
                base = k;
                limit = 0;
                while ([venueData[i] characterAtIndex:k++] != ';') {
                    limit++;
                }
                ident = [[NSString alloc] initWithString:[venueData[i] substringWithRange:NSMakeRange(base, limit)]];
                //NSLog(@"%@", ident);
            }
            else if([[venueData[i] substringWithRange:NSMakeRange(base, limit)] isEqualToString:@"location"]){
                NSUInteger start = k;
                NSUInteger c;
                while (!([venueData[i] characterAtIndex:k-1] == '}' && [venueData[i] characterAtIndex:k] == ';')){
                    k++;
                };
                k++;
                NSUInteger end = k;
                NSRange l = [venueData[i] rangeOfString:@"lat = \"" options:NSLiteralSearch range:NSMakeRange(start, end-start)];
                base = l.location + l.length;
                //NSLog(@"%c", [venueData[i] characterAtIndex:base]);
                c = base;
                limit = 0;
                while ([venueData[i] characterAtIndex:c++] != ';') {
                    limit++;
                }
                lat = [[NSString alloc] initWithString:[venueData[i] substringWithRange:NSMakeRange(base, limit-1)]];
                l = [venueData[i] rangeOfString:@"lng = \"" options:NSLiteralSearch range:NSMakeRange(start, end-start)];
                base = l.location + l.length;
                //NSLog(@"%c", [venueData[i] characterAtIndex:base]);
                c = base;
                limit = 0;
                while ([venueData[i] characterAtIndex:c++] != ';') {
                    limit++;
                }
                lon = [[NSString alloc] initWithString:[venueData[i] substringWithRange:NSMakeRange(base, limit-1)]];
                //NSLog(@"%@, %@",lat, lon);
                //NSLog(@"%@", [venueData[i] substringWithRange:NSMakeRange(start, end-start)]);
                
            }
            else if([[venueData[i] substringWithRange:NSMakeRange(base, limit)] isEqualToString:@"verified"] || [[venueData[i] substringWithRange:NSMakeRange(base, limit)] isEqualToString:@"url"]){

                while ([venueData[i] characterAtIndex:k++] != ';');
                
            }
            else{
                while (!([venueData[i] characterAtIndex:k-1] == '}' && [venueData[i] characterAtIndex:k] == ';')){
                    k++;
                };
                k++;

            }

            while ([venueData[i] characterAtIndex:k++] != '\n');

            while (k < [venueData[i] length] && [venueData[i] characterAtIndex:k] == ' ')
                k++;

        }
        [self.info addObject:[[NSDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:venueName, @"name", ident, @"id", lat, @"latitude", lon, @"longitude", nil]]];
        [venueName release];
        [ident release];
        [lat release];
        [lon release];
    }
    [data release];
    for(int i = 0; i < numVenues; i++)
        [venueData[i] release];
    

}



-(IBAction)mapPressed:(id)sender{
    
    NSInteger mapViewNum = 4;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:mapViewNum];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}

-(IBAction)storePressed:(id)sender {
    NSInteger newView = 8;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

-(IBAction)manageVenuesPressed:(id)sender {
    NSInteger newView = 5;
    NSNumber *newMode = [[NSNumber alloc] initWithInt:newView];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:newMode forKey:@"switchView"];
    NSNotification *notification = [NSNotification notificationWithName:@"ViewChange" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(IBAction)optionsPressed:(id)sender{
    
    popupView* poppy;
    NSString* firstText = [[NSString alloc] initWithFormat:@"Leave this place!"];
    poppy = [[popupView alloc] initWithText:firstText andDelegate:self andYesFunc:@selector(firstPopUpYes) andNoFunc:@selector(firstPopUpNo)];
    [self addSubview:poppy];
    
}


//////////////////////////////////////////////////////////////////////////////////

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

/*- (void)dealloc {
    foursquare_.sessionDelegate = nil;
    [self cancelRequest];
}*/


#pragma mark -
#pragma mark BZFoursquareRequestDelegate

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;


    self.request = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"CheckInPressedDone called"); //Kevin - happens twice
    [self checkInPressedDone];
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
    [postString writeToFile:dataFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    //[postString release];
    //[path release];
   // [documentsDirectory release];
    ///[dataFilePath release];
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
    NSString *temp = [[NSString alloc] initWithFormat:@"%lf,%lf",latitude,longitude];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:temp, @"ll", nil];
    self.request = [foursquare_ requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request_ start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)checkin {
    [self prepareForRequest];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[venue objectForKey:@"id"], @"venueId", @"public", @"broadcast", nil];
    self.request = [foursquare_ requestWithPath:@"checkins/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
    [request_ start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)getUser {
    [self prepareForRequest];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    self.request = [foursquare_ requestWithPath:@"users/self" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request_ start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)setLatitude:(double)lat andLongitude:(double)lon {
    NSLog(@"got here");
    latitude = lat;
    longitude = lon;
}

@end
