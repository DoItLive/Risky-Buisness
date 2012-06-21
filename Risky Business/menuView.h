//
//  menuView.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "BZFoursquare.h"
#import "Venue.h"
#import "Player.h"
#import "popupView.h"

@interface menuView : UIView <BZFoursquareRequestDelegate, BZFoursquareSessionDelegate> {
    
    
    UIButton *checkInButton;
    UIButton *mapButton;
    UIButton *storeButton;
    UIButton *manageVenuesButton;
    UIButton *optionsButton;
            
    double latitude;
    double longitude;
    NSInteger selection;
    
    Player *user;
    NSString *token;
    ///////////////////
    BZFoursquare        *foursquare_;
    BZFoursquareRequest *request_;
    NSDictionary        *meta_;
    NSArray             *notifications_;
    NSDictionary        *response_;
    NSInteger           s;
    NSString            *name;
    NSMutableArray      *info;
    NSDictionary        *venue;
    ///////////////////
    
    UIImageView *leftBuilding;
    UIImageView *rightBuilding;
    UIImageView *shadow;
}

@property (nonatomic, retain) IBOutlet UIImageView *leftBuilding;
@property (nonatomic, retain) IBOutlet UIImageView *rightBuilding;
@property (nonatomic, retain) IBOutlet UIImageView *shadow;


@property (nonatomic, retain) IBOutlet UIButton *checkInButton;
@property (nonatomic, retain) IBOutlet UIButton *mapButton;
@property (nonatomic, retain) IBOutlet UIButton *storeButton;
@property (nonatomic, retain) IBOutlet UIButton *manageVenuesButton;
@property (nonatomic, retain) IBOutlet UIButton *optionsButton;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) Player *user;

///////////////////////////////
@property (nonatomic) NSInteger s;
@property (nonatomic) NSInteger selection;
@property(nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *meta;
@property(nonatomic,copy) NSArray *notifications;
@property(nonatomic,copy) NSDictionary *response;
@property(nonatomic,retain) NSString *name;
@property(nonatomic, retain)  NSMutableArray *info;
@property(nonatomic, retain) NSDictionary *venue;
//////////////////////////////

-(id)initWithPlayer:(Player*)u;
-(IBAction)checkInPressed:(id)sender;
-(void)checkInPressedDone;
-(IBAction)mapPressed:(id)sender;
-(IBAction)storePressed:(id)sender;
-(IBAction)manageVenuesPressed:(id)sender;
-(IBAction)optionsPressed:(id)sender;
-(void) setSelection:(NSInteger)incoming;


///////////////////////////////
- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo;
- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare; 
- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error;
- (void)requestDidFinishLoading:(BZFoursquareRequest *)request;
- (void)cancelRequest;
- (void)prepareForRequest;
- (void)getUser;
- (void)searchVenues;
- (void)checkin;
- (void)checkInPressedDone;
- (void)setup;
- (void)setLatitude:(double)lat andLongitude:(double)lon;
- (void)parseVenues;
//////////////////////////////
-(void)setUpAnimations;

@end
