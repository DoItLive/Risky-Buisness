//
//  ViewController.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "menuView.h"
#import "preBattleView.h"
#import "fortifyView.h"
#import "aftermathView.h"
#import "battleView.h"
#import "mapView.h"
#import "myVenuesView.h"
#import "checkInView.h"
#import "storeView.h"
#import "FriendAnnotation.h"
#import "EnemyAnnotation.h"
#import "Venue.h"
#import "Player.h"
#import "FogOverlay.h"
#import "FogOverlayView.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>{
    
    menuView *menuViewInst;
    preBattleView *preBattleViewInst;
    fortifyView *fortifyViewInst;
    aftermathView *aftermathViewInst;
    mapView *mapViewInst;
    myVenuesView *myVenuesViewInst;
    battleView *battleViewInst;
    checkInView *checkInViewInst;
    storeView *storeViewInst;
    
    double lati;
    double longi;
    
    CLLocationManager *locationManager;
        
    Player* user;
}

@property (nonatomic, retain) IBOutlet menuView *menuViewInst;
@property (nonatomic, retain) IBOutlet preBattleView *preBattleViewInst;
@property (nonatomic, retain) IBOutlet fortifyView *fortifyViewInst;
@property (nonatomic, retain) IBOutlet aftermathView *aftermathViewInst;
@property (nonatomic, retain) IBOutlet mapView *mapViewInst;
@property (nonatomic, retain) IBOutlet myVenuesView *myVenuesViewInst;
@property (nonatomic, retain) IBOutlet battleView *battleViewInst;
@property (nonatomic, retain) IBOutlet checkInView *checkInViewInst;
@property (nonatomic, retain) IBOutlet storeView *storeViewInst;
@property (nonatomic, retain) Player *user;


-(void)checkForDBID:(NSTimer *)Timer;
- (void)changeView:(NSNotification *)notif;
-(void)setUpUser;
-(void)initUser:(NSData*)receivedData;


-(NSString *)dataFilePath;

@end
