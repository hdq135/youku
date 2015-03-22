//
//  BBBarController.m
//  borderButtonController
//
//  Created by hdq on 15-3-13.
//  Copyright (c) 2015年 hdq. All rights reserved.
//


#import "borderButtonView.h"

#define num(x) [NSNumber numberWithInt:(int)x]
#define str(x) [NSString stringWithFormat:@"%d",(int)x]
#define barView(x) (borderButtonView*)[self.bars objectForKey:num(x)]
#define isExist(x) ((self.barType&x)==x)

@interface BBBarController ()

@end

@implementation BBBarController
- (instancetype)init:(float)lenth{
    self.lenth = lenth;
    self.step = -1;
    self.time = 0.5;
    if (!self.barType) {
        self.barType = BBBarAll;
    }
    return [self init];
}
- (instancetype)init:(float)lenth type:(BBBarType)type{
    self.barType = type;
    
    return [self init:lenth];
}



- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] bounds];
    borderButtonView *contentView = [[borderButtonView alloc] initWithFrame:applicationFrame];
    // contentView.backgroundColor = [UIColor blackColor];
    
    float width = applicationFrame.size.width - 2*self.lenth;
    float hight = applicationFrame.size.height - 2*self.lenth;
    NSMutableArray *objarry = [NSMutableArray array];
    
    NSArray *keys = [NSArray arrayWithObjects:num(BBBarTop), num(BBBarLeft), num(BBBarRight), num(BBBarBottom), nil];
    CGRect rect;
    for(int i=0; i<4; i++) {
        switch (self.barType&(1<<i)) {
            case BBBarTop:
                rect = CGRectMake(self.lenth ,0.00f,width, self.lenth);
                [objarry addObject:[[borderButtonView alloc] initWithFrame:rect type:BBBarTop]];
                break;
            case BBBarLeft:
                rect = CGRectMake(0, self.lenth, self.lenth, hight);
                [objarry addObject:[[borderButtonView alloc] initWithFrame:rect type:BBBarLeft]];
                break;
            case BBBarRight:
                rect = CGRectMake(applicationFrame.size.width - self.lenth,self.lenth, self.lenth, hight);
                [objarry addObject:[[borderButtonView alloc] initWithFrame:rect type:BBBarRight]];
                break;
            case BBBarBottom:
                rect = CGRectMake(self.lenth,applicationFrame.size.height - self.lenth,width, self.lenth);
                [objarry addObject:[[borderButtonView alloc] initWithFrame:rect type:BBBarBottom]];
                break;
            default:
                [objarry addObject:[NSObject alloc] ];
                break;
        }
    }
    
    if (![self readDate]) {
        self.maps = [NSMutableDictionary dictionary];
    }
    self.bars = [NSDictionary dictionaryWithObjects:objarry forKeys:keys];
    
    self.view = contentView;
    if (isExist(BBBarTop)) {
        [self.view addSubview:barView(BBBarTop)];
    }
    if (isExist(BBBarLeft)) {
        [self.view addSubview:barView(BBBarLeft)];
    }
    if (isExist(BBBarRight)) {
        [self.view addSubview:barView(BBBarRight)];
    }
    if (isExist(BBBarBottom)) {
        [self.view addSubview:barView(BBBarBottom)];
    }
    
    
    [self setCornerRadius:8.0f];
    [self setBackgroundColor:0.7f alpha:0.5f];
    
    self.CurrentLenth = 0;
    
    UIPanGestureRecognizer *Recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:Recognizer];
    Recognizer.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show:(BOOL)on{
    if (self.timer) {
        return;
    }
    if (on) {
        self.step = self.step > 0?self.step:0 - self.step;
    }
    else{
        self.step = self.step < 0?self.step:0 - self.step;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time/self.lenth/(self.step>0?self.step:0-self.step) target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

#pragma mark - button

-(NSInteger)addBarButton:(UIButton*)objects atBar:(BBBarType)type{
    borderButtonView *view = nil;
    BBBarType t = self.barType & type;
    switch (t) {
        case BBBarTop:
            view = barView(BBBarTop);
            break;
        case BBBarLeft:
            view = barView(BBBarLeft);
            break;
        case BBBarRight:
            view = barView(BBBarRight);
            break;
        case BBBarBottom:
            view = barView(BBBarBottom);
            break;
        default:
            if (isExist(BBBarTop)) {
                t = BBBarTop;
                view = barView(BBBarTop);
            }else if (isExist(BBBarLeft)) {
                t = BBBarLeft;
                view = barView(BBBarLeft);
            }else if (isExist(BBBarRight)) {
                t = BBBarRight;
                view = barView(BBBarRight);
            }else if (isExist(BBBarBottom)) {
                t = BBBarBottom;
                view = barView(BBBarBottom);
            }
            break;
    }
    if (view == nil) {
        return -1;
    }
    int count = 0;
    for (int i = 0; i<[self.bars count]; i++) {
        if (isExist(1<<i)) {
            count += [[[self.bars objectForKey:num(1<<i)] subviews] count];
        }
    }
    objects.tag = count+BBBUTTONTAG;
    int index = -1;
    for (int i = 0; i<[self.maps count]; i++) {
        if (isExist(1<<i) && [self.maps objectForKey:str(1<<i)]!=nil) {
            for (int j=0; j<[[self.maps objectForKey:str(1<<i)] count]; j++) {
                if ([[[self.maps objectForKey:str(1<<i)] objectAtIndex:j] integerValue] == objects.tag) {
                    index = i;
                }
            }
        }
    }
    if (index == -1) {
        if ([self.maps objectForKey:str(view.type)]!=nil) {
            [[self.maps objectForKey:str(view.type)] addObject:num(objects.tag)];
        }else{
            [self.maps setObject:[NSMutableArray arrayWithObjects:num(objects.tag), nil] forKey:str(view.type)];
        }
        [view addSubview:objects];
        [self orderButton:view.type];
    }else{
        borderButtonView *v = barView(1<<index);
        [v addSubview:objects];
        [self orderButton:1<<index];
    }
    
    
    [(UIButton*)objects addTarget:self action:@selector(dragInside:)forControlEvents:UIControlEventTouchDragInside];
    return objects.tag;
}

-(void)refrashArray:(BBBarType)type tag:(NSInteger)tag{
    
    NSMutableArray *array = [self.maps objectForKey:str(type)] ;
    for (int i = 0; i<[array count]; i++) {
        if ([[array objectAtIndex:i] integerValue] == -1) {
            if (tag == -1) {
                [array removeObjectAtIndex:i];
            }else{
                [array replaceObjectAtIndex:i withObject:num(tag)];
            }
            break;
        }
    }
}
-(void)moveTo:(borderButtonView*)view index:(NSInteger)index{
    
    [self.currentButton removeFromSuperview];
    [view addSubview:self.currentButton];
    
    NSMutableArray *array = [self.maps objectForKey:str(view.type)] ;
    borderButtonView *v = (borderButtonView*)self.oldButtonSuperView;
    if (array) {
        if (index == -1) {
            [self refrashArray:view.type tag:self.currentButton.tag];
        }else if(index < [array count]){
            [array insertObject:num(self.currentButton.tag) atIndex:index];
            [self refrashArray:v.type tag:-1];
        }else{
            [array addObject:num(self.currentButton.tag)];
            [self refrashArray:v.type tag:-1];
        }
    }else{
        [self.maps setObject:[NSMutableArray arrayWithObjects:num(self.currentButton.tag), nil] forKey:str(view.type)];
        [self refrashArray:v.type tag:-1];
    }
    [self orderButton:view.type];
    self.currentButton = nil;
    self.oldButtonSuperView = nil;
    self.CurrentLenth = self.CurrentLenth;
}
- (void)orderButton{
    NSEnumerator *key = [self.maps keyEnumerator];
    NSString *str = key.nextObject;
    while (str) {
        BBBarType type = [str integerValue];
        if (isExist(type)) {
            [self orderButton:type];
        }
        str = key.nextObject;
    }
}
- (void)orderButton:(BBBarType)type{
    borderButtonView * view = barView(type);
    NSArray *array = [self.maps objectForKey:str(type)];
    if ([[view subviews] count] ==0) {
        return;
    }
    float width = view.frame.size.width>0?view.frame.size.width:self.lenth;
    float height = view.frame.size.height>0?view.frame.size.height:self.lenth;
    
    for (int i=0,j=0; i < [array count]; i++) {
        UIButton *button = (UIButton*)[view viewWithTag:[[array objectAtIndex:i] integerValue]];
        if (button == nil) {
            continue;
        }
        
        float x = width/2;
        float y = (height/([[view subviews] count]+1))*(j+1);
        
        switch (view.type) {
            case BBBarTop:
            case BBBarBottom:
                x = (width/([[view subviews] count]+1))*(j+1);
                y = height/2 ;
                break;
            case BBBarLeft:
            case BBBarRight:
                break;
            default:
                break;
        }
        button.center = CGPointMake(x, y);
        j++;
    }
}


#pragma mark - save

-(void)savetofile{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:BBFILENAME];
    [self.maps writeToFile:path atomically:YES];
    
}
-(BOOL)readDate{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:BBFILENAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.maps = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        return YES;
    }
    return NO;
}
#pragma mark - backcall


-(void)timerAction:(id)timer{            //timer
    
    if ((self.CurrentLenth >= self.lenth && self.step>0 ) || (self.CurrentLenth <= 0 && self.step<0)) {
        [timer invalidate];
        timer = nil;
        self.timer = nil;
        self.CurrentLenth = self.step>0?self.lenth:0;
        return;
    }
    self.CurrentLenth += self.step;
}

-(void)pan:(UIPanGestureRecognizer*)pan {   //PanGestureRecognizer
    
    if (self.currentButton == nil) {
        return;
    }
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            [self setAllLenth:self.lenth];
            borderButtonView * view = (borderButtonView*)self.currentButton.superview;
            CGPoint p = CGPointMake(self.currentButton.center.x + view.frame.origin.x, self.currentButton.center.y + view.frame.origin.y);
            
            self.oldButtonSuperView = self.currentButton.superview;
            [self.currentButton removeFromSuperview];
            [self.view addSubview:self.currentButton];
            self.currentButton.center = p;
            NSMutableArray *array = [self.maps objectForKey:str(view.type)] ;
            for (int i = 0; i<[array count]; i++) {
                if ([[array objectAtIndex:i] integerValue] == self.currentButton.tag) {
                    [array replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
                }
            }
            
            [self orderButton:view.type];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (self.currentButton) {
                CGPoint translation = [pan translationInView:self.view];
                self.currentButton.center = CGPointMake(self.currentButton.center.x + translation.x, self.currentButton.center.y + translation.y);
                [pan setTranslation:CGPointMake(0, 0) inView:self.view];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            CGPoint point = self.currentButton.center;
            
            for (int i=0; i<[self.bars count]; i++) {
                BBBarType type = 1<<i;
                if (isExist(type)) {
                    borderButtonView *view = barView(type);
                    if (CGRectContainsPoint(view.frame,point)) {
                        NSMutableArray *array = [self.maps objectForKey:str(view.type)] ;
                        int index = -1;
                        if (array) {
                            if (view.type == BBBarLeft || view.type == BBBarRight) {
                                float l = view.frame.size.height/([array count]+1);
                                index = (int)(point.y - self.lenth)/l;
                                
                            }else{
                                float l = view.frame.size.width/([array count]+1);
                                index = (int)(point.x - self.lenth)/l;
                                
                            }
                        }else{
                            index = 0;
                        }
                        [self moveTo:view index:index];
                        break;
                    }
                }
            }
            if (self.currentButton!=nil) {
                [self moveTo:(borderButtonView*)self.oldButtonSuperView index:-1];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            if (self.currentButton!=nil) {
                [self moveTo:(borderButtonView*)self.oldButtonSuperView index:-1];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
            NSLog(@"uigesture fail");
            break;
        default:{
            break;
        }
    }
}


- (void)dragInside:(id)sender  //button draginside
{
    self.currentButton = sender;
}

- (void)orientationDidChange:(NSNotification *)note   //Rotate screen
{
    
    CGRect mainRect = [[UIScreen mainScreen] bounds];
    
    float width = mainRect.size.width - 2*self.lenth;
    float hight = mainRect.size.height - 2*self.lenth;
    
    [self.view setFrame:mainRect];
    if (isExist(BBBarTop)) {
        CGRect rect = CGRectMake(self.lenth ,0.00f,width, self.CurrentLenth );
        [barView(BBBarTop) setFrame:rect];
        [self orderButton:BBBarTop];
    }
    if (isExist(BBBarLeft)) {
        CGRect rect = CGRectMake(0, self.lenth, self.CurrentLenth , hight);
        [barView(BBBarLeft) setFrame:rect];
        [self orderButton:BBBarLeft];
    }
    if (isExist(BBBarRight)) {
        CGRect rect = CGRectMake(mainRect.size.width - self.lenth,self.lenth, self.CurrentLenth , hight);
        [barView(BBBarRight) setFrame:rect];
        [self orderButton:BBBarRight];
    }
    if (isExist(BBBarBottom)) {
        CGRect rect = CGRectMake(self.lenth,mainRect.size.height - self.lenth,width, self.CurrentLenth );
        [barView(BBBarBottom) setFrame:rect];
        [self orderButton:BBBarBottom];
    }
    self.CurrentLenth =  self.CurrentLenth;
    
}

#pragma mark - style

-(void)setCurrentLenth:(float)lenth{
    
    if (isExist(BBBarTop)) {
        if ([[barView(BBBarTop) subviews] count]>0) {
            [barView(BBBarTop) setHeight:lenth];
        }else{
            [barView(BBBarTop) setHeight:0];
        }
    }
    if (isExist(BBBarLeft)){
        if([[barView(BBBarLeft) subviews] count]>0) {
            [barView(BBBarLeft) setWidth:lenth];
        }else{
            [barView(BBBarLeft) setWidth:0];
        }
    }
    if (isExist(BBBarRight)){
        borderButtonView* view = barView(BBBarRight);
        CGRect rect = view.frame;
        rect.origin.x = self.view.frame.size.width - lenth;
        rect.size.width = lenth;
        
        if([[barView(BBBarRight) subviews] count]>0){
            [barView(BBBarRight) setFrame:rect];
        }else{
            rect.origin.x = self.view.frame.size.width ;
            rect.size.width = 0;
            [barView(BBBarRight) setFrame:rect];
        }
    }
    if (isExist(BBBarBottom)){
        borderButtonView* view = barView(BBBarBottom);
        CGRect rect = view.frame;
        if([[barView(BBBarBottom) subviews] count]>0) {
            rect.origin.y = self.view.frame.size.height - lenth;
            rect.size.height =lenth;
            [barView(BBBarBottom) setFrame:rect];
        }else{
            rect.origin.y = self.view.frame.size.height;
            rect.size.height = 0;
            [barView(BBBarBottom) setFrame:rect];
        }
    }
    _CurrentLenth = lenth;
}

-(void)setAllLenth:(float)lenth{
    
    if (isExist(BBBarTop)) {
        [barView(BBBarTop) setHeight:lenth];
    }
    if (isExist(BBBarLeft)) {
        [barView(BBBarLeft) setWidth:lenth];
    }
    if (isExist(BBBarRight)) {
        
        borderButtonView* view = barView(BBBarRight);
        CGRect rect = view.frame;
        rect.origin.x = self.view.frame.size.width - lenth;
        rect.size.width = lenth;
        [barView(BBBarRight) setFrame:rect];
    }
    if (isExist(BBBarBottom)) {
        borderButtonView* view = barView(BBBarBottom);
        CGRect rect = view.frame;
        rect.origin.y = self.view.frame.size.height - lenth;
        rect.size.height =lenth;
        [barView(BBBarBottom) setFrame:rect];
    }
}
-(void)setCornerRadius:(float)radius{
    
    if (isExist(BBBarTop)) {
        [barView(BBBarTop) setCornerRadius:radius];
    }
    if (isExist(BBBarLeft)) {
        [barView(BBBarLeft) setCornerRadius:radius];
    }
    if (isExist(BBBarRight)) {
        [barView(BBBarRight) setCornerRadius:radius];
    }
    if (isExist(BBBarBottom)) {
        [barView(BBBarBottom) setCornerRadius:radius];
    }
}

-(void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor{
    
    if (isExist(BBBarTop)) {
        [barView(BBBarTop)  setCornerRadius:radius borderColor:borderColor];
    }
    if (isExist(BBBarLeft)) {
        [barView(BBBarLeft)  setCornerRadius:radius borderColor:borderColor];
    }
    if (isExist(BBBarRight)) {
        [barView(BBBarRight)  setCornerRadius:radius borderColor:borderColor];
    }
    if (isExist(BBBarBottom)) {
        [barView(BBBarBottom)  setCornerRadius:radius borderColor:borderColor];
    }
}
-(void)setBackgroundColor:(float)color alpha:(float)alphas{
    
    
    if (isExist(BBBarTop)) {
        borderButtonView* view = barView(BBBarTop);
        view.backgroundColor = [UIColor colorWithWhite:color alpha:alphas];
    }
    if (isExist(BBBarLeft)) {
        borderButtonView* view = barView(BBBarLeft);
        view.backgroundColor = [UIColor colorWithWhite:color alpha:alphas];
    }
    if (isExist(BBBarRight)) {
        borderButtonView* view = barView(BBBarRight);
        view.backgroundColor = [UIColor colorWithWhite:color alpha:alphas];
    }
    if (isExist(BBBarBottom)) {
        borderButtonView* view = barView(BBBarBottom);
        view.backgroundColor = [UIColor colorWithWhite:color alpha:alphas];
    }
}

@end
