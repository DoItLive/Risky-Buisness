//
//  Meter.h
//  Tester
//
//  Created by Christian Weigandt on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Meter : UIView{
    
    UIButton* thumb;
    UIImageView* lowerImage;
    UIImageView* upperImage;
    UIButton* upperIcon;
    UIButton* lowerIcon;
    
    UILabel* userArmyLabel;
    UILabel* venueArmyLabel;

    NSInteger value;
    NSInteger maxValue;
    
    id target;
    SEL selector;
}

@property (nonatomic, retain) UIButton *thumb;
@property (nonatomic, retain) UIImageView *lowerImage;
@property (nonatomic, retain) UIImageView *upperImage;
@property (nonatomic, retain) UIButton *upperIcon;
@property (nonatomic, retain) UIButton *lowerIcon;
@property (nonatomic, retain) UILabel *userArmyLabel;
@property (nonatomic, retain) UILabel *venueArmyLabel;

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event;
-(void)setMaxValue:(NSInteger)newMax andValue:(NSInteger)newValue;
-(void)upPushed;
-(void)downPushed;

@end
