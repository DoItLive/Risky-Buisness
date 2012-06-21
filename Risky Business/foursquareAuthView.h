//
//  foursquareAuthView.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*#ifndef FOURSQUARE
#define FOURSQUARE

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "BZFoursquare.h"

@interface foursquareAuthView : UIView <BZFoursquareRequestDelegate, BZFoursquareSessionDelegate> {
    UIButton *button;
    UILabel *buttonText;
    BZFoursquare        *foursquare_;
    BZFoursquareRequest *request_;
    NSDictionary        *meta_;
    NSArray             *notifications_;
    NSDictionary        *response_;
}
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UILabel *buttonText;
@property(nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *meta;
@property(nonatomic,copy) NSArray *notifications;
@property(nonatomic,copy) NSDictionary *response;


- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare;
-(IBAction)buttonPressed:(id)sender;
-(void)setup;
- (void)cancelRequest;
- (void)prepareForRequest;
- (void)getUser;
- (void)searchVenues;
- (void)checkin;

@end

#endif
*/