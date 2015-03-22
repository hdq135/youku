//
//  ViewController.h
//  youku
//
//  Created by hdq on 15-3-9.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBarController.h"
@interface ViewController : UIViewController <UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic) BOOL IsPlayView;


@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) BBBarController *broderButtonmBar;
@property (weak, nonatomic)  UIButton *turn;
@property (weak, nonatomic)  UIButton *refrsh;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

