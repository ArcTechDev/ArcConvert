//
//  TutorialManager.h
//  Calculator
//
//  Created by User on 15/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TutorialManagerDelegate <NSObject>

- (void)onTutorialDismissWithViewController:(UIViewController *)viewController;

@end

@interface TutorialManager : NSObject

+ (TutorialManager *)sharedManager;
- (void)presentTutorialWithKey:(NSString *)key WithDelegate:(id<TutorialManagerDelegate>)delegate WithViewController:(UIViewController *)controller WithDismissGesture:(UIGestureRecognizer *)gesture;

@end
