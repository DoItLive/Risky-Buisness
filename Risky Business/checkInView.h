//
//  checkInView.h
//  Risky Business
//
//  Created by Christian Weigandt on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Connection.h"
#include "Venue.h"
#include "Player.h"

@interface checkInView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    IBOutlet UIPickerView* venuePicker;
    IBOutlet UIButton* chooseButton;
    NSArray *info;
    NSInteger selection;
    Player* user;
    Venue* venue;
}

@property (nonatomic, retain) IBOutlet UIPickerView *venuePicker;
@property (nonatomic, retain) IBOutlet UIButton *chooseButton;
@property (nonatomic, retain) NSArray *info;
@property (nonatomic) NSInteger selection;
@property (nonatomic, retain) Player *user;
@property (nonatomic, retain) Venue *venue;


-(id)initWithPlayer:(Player*)u;
-(IBAction)choosePushed:(id)sender;
-(void)setPick;
-(void)updatePick;
-(void)setInfo:(NSArray *)incoming;
-(void)chooseView:(NSData*) receivedData;

@end
