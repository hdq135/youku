//
//  ViewController.m
//  youku
//
//  Created by hdq on 15-3-9.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

#import "ViewController.h"
#import "html5ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        
    NSURL *url = [NSURL URLWithString:@"http://youku.com"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.mediaPlaybackRequiresUserAction = NO;
    
    self.broderButtonmBar = [[BBBarController alloc] init:56.0f type:BBBarAll];
    [self.view addSubview:self.broderButtonmBar.view];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back.layer setCornerRadius:10];
    back.frame = CGRectMake(0, 0, 55, 35);
    [back setTitle:@"<" forState:UIControlStateNormal];
    // [self.refrsh setBackgroundColor:[UIColor lightGrayColor]];
    [back addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.broderButtonmBar addBarButton:back atBar:BBBarTop];
    
    UIButton *forward = [UIButton buttonWithType:UIButtonTypeSystem];
    [forward.layer setCornerRadius:10];
    forward.frame = CGRectMake(0, 0, 55, 35);
    [forward setTitle:@">" forState:UIControlStateNormal];
    // [self.refrsh setBackgroundColor:[UIColor lightGrayColor]];
    [forward addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    [self.broderButtonmBar addBarButton:forward atBar:BBBarTop];
    
    self.refrsh  = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.refrsh.layer setCornerRadius:10];
    self.refrsh.frame = CGRectMake(0, 0, 55, 35);
    [self.refrsh setTitle:@"Refrsh" forState:UIControlStateNormal];
   // [self.refrsh setBackgroundColor:[UIColor lightGrayColor]];
    [self.refrsh addTarget:self action:@selector(refrsh:) forControlEvents:UIControlEventTouchUpInside];
    [self.broderButtonmBar addBarButton:self.refrsh atBar:BBBarTop];
    
    self.turn  = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.turn.layer setCornerRadius:10];
    self.turn.frame = CGRectMake(0, 0, 55, 35);
    [self.turn setTitle:@"Turn" forState:UIControlStateNormal];
    [self.turn addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
   // [self.turn setBackgroundColor:[UIColor lightGrayColor]];
    [self.broderButtonmBar addBarButton:self.turn atBar:BBBarTop];
    [self.turn setEnabled:NO];
    
    UITapGestureRecognizer *Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    Recognizer.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:Recognizer];//关键语句，给self.view添加一个手势监测；
    Recognizer.delegate = self;
    
}
-(void)turn:(id)sender{
    self.IsPlayView = YES;
    [self performSegueWithIdentifier:@"segue" sender:self];
}

-(void)longPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    
   // if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
    {
        if (self.broderButtonmBar.step>0) {
            [self.broderButtonmBar show:NO];
        }
        else{
            [self.broderButtonmBar show:YES];
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)sevue sender:(id)sender {
   
    html5ViewController *view=sevue.destinationViewController;
    if (view.videoId == nil) {
        view.html = [view getPlayerHtml:self.videoId];
    }
}


-(void)refrsh:(id)sender {
    [self.webView reload];
}


#pragma mark webView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return true;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString* htmlSoure = [webView  stringByEvaluatingJavaScriptFromString:@"window.videoIdEn"];
    if (htmlSoure != nil && ![htmlSoure isEqual:@""]) {
        [self.turn setEnabled:YES];
        self.videoId = htmlSoure;
    }else{
        [self.turn setEnabled:NO];
    }
   // NSLog(@"html=%@",htmlSoure);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    switch (error.code) {
        case -1003:
            //hostname error
            NSLog(@"hostname error");
            [[[UIAlertView alloc] initWithTitle:@"error" message:@"network hostname error" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil] show];
            break;
        case -1005:
            //network connection was lost
            NSLog(@"network error");
            [[[UIAlertView alloc] initWithTitle:@"error" message:@"network  connection error" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil] show];
            break;
        case -1007:
        {
            //redirect error
            // NSURL *url = [error.userInfo objectForKey:@"NSErrorFailingURLKey"];
            NSLog(@"network error");
            [[[UIAlertView alloc] initWithTitle:@"error" message:@"network redirect error" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil] show];
            break;
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
            [self refrsh:nil];
            break;
        default:
            break;
    }
}
@end
