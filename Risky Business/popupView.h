//
//  popupView.h
//  Risky Business
//
//  Created by Christian Weigandt on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popupView : UIView{
    
    UIButton *yesButton;
    UIButton *noButton;
    UILabel *textLabel;
    UIImageView *bg;

    SEL yesFunction;
    SEL noFunction;
    id target;
    
}

@property (nonatomic, retain) IBOutlet UIButton *yesButton;
@property (nonatomic, retain) IBOutlet UIButton *noButton;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UIImageView *bg;

@property (nonatomic) SEL yesFunction;
@property (nonatomic) SEL noFunction;


- (id)initWithText:(NSString*)text andDelegate:(id)delegate andYesFunc:(SEL)yesFunc andNoFunc:(SEL)noFunc;
-(IBAction)yesPushed:(id)sender;
-(IBAction)noPushed:(id)sender;
-(void)disappear;

@end
