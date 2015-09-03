//
//  ThemeManager.h
//  Calculator
//
//  Created by User on 3/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Helper.h"

#define ThemChangeNotify @"ThemChange"

static NSString *themeDataFileName = @"ThemeConfig";
static NSString *savedThemeFileName= @"ThemeSave.data";

@interface ThemeManager : NSObject

+ (ThemeManager *)sharedThemeManager;

- (NSArray *)getAllThemes;

- (NSString *)getCurrentThemeName;

- (void)switchThemeWithThemeName:(NSString *)themeName;

/**
 * Might return UIColor, NSString, NSNumber
 * 
 * UIColor 0~255
 * NSString(font name,  image name)
 * NSNumber (font size, boolean)
 * 
 * pathString e.g string/string/string reference to ThemeConfig.plist
 */
- (id)requestCustomizedUIDataWithPathString:(NSString *)pathString;

@end
