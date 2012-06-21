//
//  mapView.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Player.h"
#import "FriendAnnotation.h"
#import "EnemyAnnotation.h"
#import "Venue.h"
#import "FogOverlay.h"

//The radius of the circle of sight around each venue
#define RADIUS 50 //In meters

@interface mapView : UIView <UIAlertViewDelegate>{
    
    MKMapView *mapViewInstance;
    
    UIButton *backButton;
    UIButton *nextButton;
    UILabel *usernameLabel;
    UILabel *armyStatsLabel;
    UIImageView *fogImageView;
    UIImage *fogImage;
    UIImage *maskImage;
    UIImage *curFogImage;
    
    NSArray *venueInfo;
    NSMutableArray *allVenues;
    NSUInteger curIndex; //Used to keep track of which venue currently showing
    NSInteger nVenues; //Number of venues user owns
    
    Player *user;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapViewInstance;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *armyStatsLabel;
@property (nonatomic, retain) IBOutlet UIImageView *fogImageView;
@property (nonatomic, retain) UIImage *fogImage;
@property (nonatomic, retain) UIImage *maskImage;
@property (nonatomic, retain) UIImage *curFogImage;
@property (nonatomic) NSUInteger curIndex;
@property (nonatomic) NSInteger nVenues;
@property (nonatomic, retain) NSArray *venueInfo;
@property (nonatomic, retain) NSMutableArray *allVenues;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

- (void)initWithPlayer:(Player*)player;
- (void)update;
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
- (void) updateFog;
- (void) drawCircles:(CGContextRef)context;

@end
