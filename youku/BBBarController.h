//
//  BBBarController.h
//  borderButtonController
//
//  Created by hdq on 15-3-13.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BBBarType) {
    BBBarTop      = 1<<0,
    BBBarLeft     = 1<<1,
    BBBarRight    = 1<<2,
    BBBarBottom   = 1<<3,
    BBBarAll      = 0xf,
};

#define BBBUTTONTAG 100   //define button's tag start num aviod to repeat with view
#define BBFILENAME @"bbarmaps.plist"
@interface BBBarController : UIViewController<UIGestureRecognizerDelegate>

@property NSInteger step;
@property float time;
@property (nonatomic) float lenth;
@property (nonatomic) float CurrentLenth;

@property (strong, nonatomic) NSTimer *timer;

@property BBBarType barType;
@property (strong, nonatomic) NSDictionary *bars;
@property (strong, nonatomic) NSMutableDictionary *maps;

@property UIView* oldButtonSuperView;
@property (strong, nonatomic) UIButton* currentButton;


- (instancetype)init:(float)lenth;                             //lenth : topbar/bottombar's height or right/left's width
- (instancetype)init:(float)lenth type:(BBBarType)type;        //type : multiple choice like BBBarLeft|BBBarBottom

-(NSInteger)addBarButton:(UIButton *)objects atBar:(BBBarType)type;   //add button to bar retun the button's tag. Don't modify the tag! type: only select from BBBarTop - BBBarBottom;

-(void)show:(BOOL)on;
-(void)orderButton;
-(void)savetofile;


@end
