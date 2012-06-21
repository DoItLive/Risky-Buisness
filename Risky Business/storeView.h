//
//  storeView.h
//  Risky Business
//
//  Created by Christian Weigandt on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "Player.h"

@interface storeView : UIView{
    
    UIButton* tenButton;
    UIButton* twentyButton;
    UIButton* fiftyButton;
    
    UIButton* menuButton;
    
    Player* user;
    
}

@property (nonatomic, retain) IBOutlet UIButton *tenButton;
@property (nonatomic, retain) IBOutlet UIButton *twentyButton;
@property (nonatomic, retain) IBOutlet UIButton *fiftyButton;
@property (nonatomic, retain) IBOutlet UIButton *menuButton;

@property (nonatomic, retain) Player *user;

-(id)initWithPlayer:(Player*)u;
-(IBAction)tenPressed:(id)sender;
-(IBAction)twentyPressed:(id)sender;
-(IBAction)fiftyPressed:(id)sender;
-(IBAction)menuPressed:(id)sender;
-(void)addToArmy:(NSInteger)addition;
-(void)afterUpdate:(NSData*)receivedData;

@end
