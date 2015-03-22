//
//  html5ViewController.h
//  youku
//
//  Created by hdq on 15-3-12.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface html5ViewController : UIViewController <UIAlertViewDelegate>

-(NSString*)getPlayerHtml:(NSString*)videoId;
-(BOOL)initFunc:(NSString*)str;
-(void)setVolume:(float)volume;
@property (strong, nonatomic) NSString *html;
@property (strong, nonatomic) NSString *videoId;

@property (weak, nonatomic) IBOutlet UIButton *refrsh;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
