//
//  AppDelegate.h
//  Calculator
//
//  Created by User on 17/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (getter=getLaunchTime, nonatomic) NSInteger launchTime;
@property (getter=isFirstLaunch, nonatomic) BOOL firstLaunch;

@end

