//
//  TutorialManager.m
//  Calculator
//
//  Created by User on 15/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "TutorialManager.h"
#import "AppDelegate.h"

@implementation TutorialManager{
    
    NSMutableDictionary *tutorialRecord;
    BOOL appFirstLaunch;
    UIViewController *currentController;
    UIGestureRecognizer *dismissGesture;
    
    __weak id<TutorialManagerDelegate> theDelegate;
}

static TutorialManager *instance;

+ (TutorialManager *)sharedManager{

    if(instance == nil){
        
        instance = [[TutorialManager alloc] init];
    }
    
    return instance;
}


- (void)presentTutorialWithKey:(NSString *)key WithDelegate:(id<TutorialManagerDelegate>)delegate WithViewController:(UIViewController *)controller WithDismissGesture:(UIGestureRecognizer *)gesture{
    
    if(!appFirstLaunch)
        return;
    
    id obj = [tutorialRecord objectForKey:key];
    
    if(obj != nil)
        return;
    
    theDelegate = delegate;
    
    
    currentController = controller;
    dismissGesture = gesture;
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:controller.view];
    
    [gesture addTarget:self action:@selector(onTutorialDismiss:)];
    [controller.view  addGestureRecognizer:gesture];
    
    
    [tutorialRecord setObject:[NSNumber numberWithBool:YES] forKey:key];
}

- (void)onTutorialDismiss:(UIGestureRecognizer *)gesture{
    
    if([theDelegate respondsToSelector:@selector(onTutorialDismissWithViewController:)]){
        
        [theDelegate onTutorialDismissWithViewController:currentController];
    }
    
    [currentController.view removeFromSuperview];
    currentController = nil;
    dismissGesture = nil;
    theDelegate = nil;
    
}

- (id)init{
    
    if(self = [super init]){
        
        tutorialRecord = [[NSMutableDictionary alloc] init];
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        appFirstLaunch = delegate.firstLaunch;
    }
    
    return self;
}

@end
