//
//  html5ViewController.m
//  youku
//
//  Created by hdq on 15-3-12.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

#import "html5ViewController.h"
#import "ViewController.h"
#import "MediaPlayer/MediaPlayer.h"

@implementation html5ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSURL *baseURL = [NSURL fileURLWithPath:@"youku.com"];
    [self.webView loadHTMLString:self.html baseURL:baseURL];
        
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
    [self.refrsh setHidden:true];
}


- (IBAction)refrsh:(id)sender {
    NSURL *baseURL = [NSURL fileURLWithPath:@"youku.com"];
    [self.webView loadHTMLString:self.html baseURL:baseURL];
    
}


-(NSString*)getPlayerHtml:(NSString*)videoId{
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"youkufix" ofType:@"css" inDirectory:@"ressource"];
    filePath= [filePath substringToIndex:[filePath rangeOfString:@"youkufix"].location];
    NSURL *basePath = [NSURL fileURLWithPath:filePath];
    NSString *html = @"";
    html  = [html stringByAppendingFormat: @"<html><head><script type='text/javascript'>var videoId2= '%@';</script><link rel='stylesheet' media='all' href='%@youkufix.css'></head><body><script src='%@Base64.js'></script><script src='%@youkufix.js'></script></body></html>",videoId,basePath,basePath,basePath];
    self.videoId = videoId;
    return html;
}

//-(BOOL)shouldAutorotate{
//    return NO;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
//        //zuo
//    }
//    if (interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
//        //you
//    }
//    if (interfaceOrientation==UIInterfaceOrientationPortrait) {
//        //shang
//    }
//    if (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
//        //xia
//        
//    }
//    return NO;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark jsCallfunc
-(BOOL)initFunc:(NSString*)str{
    
    if ([str rangeOfString:@"func://"].length > 0) {
        NSRange funPos = [str rangeOfString:@"func://"];
        NSRange pPos = [str rangeOfString:@"/?p="];
        NSString *fun = nil;
        NSString *p = nil;
        if (pPos.length > 0) {
            fun = [str substringWithRange:NSMakeRange(NSMaxRange(funPos), pPos.location-NSMaxRange(funPos))];
            p = [str substringFromIndex:NSMaxRange(pPos)];
        }else{
            fun = [str substringFromIndex:NSMaxRange(funPos)];
        }
        
        
        if (![fun compare:@"setVolume"]) {
            [self setVolume:p?[p floatValue]:0.00f];
        }
        
        if (![fun compare:@"networkerr"]) {
            [[[UIAlertView alloc] initWithTitle:@"error" message:@"network error" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil] show];
        }
        
        
        if (![fun compare:@"close"]) {
            ViewController* vc = (ViewController*)[self.view.window rootViewController];
            vc.IsPlayView = false;
            [self dismissViewControllerAnimated:YES completion:nil];
            return false;
        }
        return false;
    }
    
    return true;
}

-(void)setVolume:(float)volume{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    // retrieve system volume
    float systemVolume = volume;
    // change system volume, the value is between 0.0f and 1.0f
    [volumeViewSlider setValue:systemVolume animated:NO];
    // send UI control event to make the change effect right now.
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark webView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([[[request URL] absoluteString] rangeOfString:@"func://"].length > 0) {
        return [self initFunc:[[request URL] absoluteString]];
    }
    return true;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    switch (error.code) {
        case -1003:
            //hostname error
            NSLog(@"hostname error");
            [[[UIAlertView alloc] initWithTitle:@"error" message:@"network error" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil] show];
            break;
        case -1005:
            //network connection was lost
            NSLog(@"network error");
            [[[UIAlertView alloc] initWithTitle:@"error" message:@"network error" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil] show];
            break;
        case -1007:
        {
            //redirect error
            // NSURL *url = [error.userInfo objectForKey:@"NSErrorFailingURLKey"];
            break;
        }
        case -1009:
            //network connection was lost
            NSLog(@"network error");
            [[[UIAlertView alloc] initWithTitle:@"error" message:@"network error" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil] show];
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            NSURL *baseURL = [NSURL fileURLWithPath:@"youku.com"];
            [self.webView loadHTMLString:self.html baseURL:baseURL];
        }
            break;
        default:
            break;
    }
}

@end
