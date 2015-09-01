//
//  Helper.h
//  Calculator
//
//  Created by User on 20/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (NSString *)getDocumentDirectoryPath;

/**
 * if string contain unicode and aspecially that string is from plist
 * use this method to get correct string
 */
+ (NSString *)getUnicodeStringFromString:(NSString *)string;

+ (BOOL)findCharacterInStringWithString:(NSString *)stringToFind WithCharacter:(NSString *)character;

/**
 * Trime string after certain count of character
 */
+(NSString *)trimeStringWithString:(NSString *)string preserveCharacterCount:(NSUInteger)preserveCount;

@end
