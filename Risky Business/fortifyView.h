//
//  fortifyView.h
//  Risky Business
//
//  Created by Do It Live, CW/KS/TL, on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "Venue.h"
#import "Player.h"

@interface fortifyView : UIView{
    
    Venue* venue;
    Player* user;
    
    UILabel* statArmySizeLabel;
    UILabel* venueLabel;
    UILabel* mobileArmySizeLabel;
    
    UIButton* backButton;
    UIButton* menuButton;
    UIButton* commitButton;
    
    UISlider* slider;
    UIStepper* stepper;
    
}

@property (nonatomic, retain) IBOutlet UILabel *statArmySizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *mobileArmySizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *venueLabel;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *menuButton;
@property (nonatomic, retain) IBOutlet UIButton *commitButton;
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UIStepper *stepper;

@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) Player *user;



-(void)setVenue:(Venue*)v;
-(id)initWithPlayer:(Player*)u;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)menuButtonPressed:(id)sender;
-(IBAction)commitButtonPressed:(id)sender;
-(IBAction)sliderMoved:(id)sender;
-(void)fortifyFinished:(NSData*)responseData;
-(IBAction)stepperPushed:(id)sender;


@end
