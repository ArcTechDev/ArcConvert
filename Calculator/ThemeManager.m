//
//  ThemeManager.m
//  Calculator
//
//  Created by User on 3/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager{
    
    NSString *currentThemeName;
    NSDictionary *themeData;
}

#pragma mark - public interface
static ThemeManager *instance;

+ (ThemeManager *)sharedThemeManager{
    
    if(instance == nil){
        
        instance = [[ThemeManager alloc] init];
    }
    
    return instance;
}

- (NSArray *)getAllThemes{
    
    if(themeData != nil){
        
        return [themeData allKeys];
    }
    
    return nil;
}

- (NSString *)getCurrentThemeName{
    
    return currentThemeName;
    
}

- (void)switchThemeWithThemeName:(NSString *)themeName{
    
    if(themeData != nil){
        
        if([themeData objectForKey:themeName] != nil){
            
            //save current theme name
            if([self saveCurrentThemeName]){
                
                //set new theme name as current
                currentThemeName = themeName;
            }
            else{
                
                NSLog(@"Switch Theme fail, can not saved new theme name");
                
                return;
            }
            
            //todo:post notification
            [[NSNotificationCenter defaultCenter] postNotificationName:ThemChangeNotify object:nil];
            
            return;
        }
    }
    
    NSLog(@"Unable to switch theme to %@, it might not exist",themeName);
}

- (id)requestCustomizedUIDataWithPathString:(NSString *)pathString{
    
    NSArray *splitString = [pathString componentsSeparatedByString:@"/"];
    
    NSDictionary *currentLocation = [themeData objectForKey:currentThemeName];
    
    if(currentLocation == nil){
        
        NSLog(@"request path:%@ you don't need to give theme name in request path", pathString);
        return nil;
    }
    
    for(int i=0; i<splitString.count; i++){
        
        id location = [currentLocation objectForKey:splitString[i]];
        
        //if this is end of path
        if(i == (splitString.count -1)){
            
            if([[location class] isSubclassOfClass:[NSDictionary class]]){
                
                NSLog(@"request path:%@ is not a data", pathString);
                return nil;
            }
            else if([[location class] isSubclassOfClass:[NSString class]]){
                
                id retVal = [self dataParserWithDataString:location];
                
                if(retVal == nil){
                    
                    NSLog(@"request path:%@ unable to parser data", pathString);
                    return nil;
                }
                
                return retVal;
            }
            else{
                
                NSLog(@"request path:%@ has unknow data type, it have to be string", pathString);
                return nil;
            }
        }
        else{
            
            currentLocation = (NSDictionary *)location;
        }
    }
    
    return nil;
}

#pragma mark - internal
- (void)loadThemeData{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:themeDataFileName ofType:@"plist"];
    
    themeData = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if(themeData == nil){
        
        NSLog(@"Unable to load theme data");
    }
}

- (BOOL)saveCurrentThemeName{
    
    if(currentThemeName == nil){
    
        NSLog(@"Unable to save current theme name, current theme name is nil");
        return NO;
    }
    
    NSArray *arr = [NSArray arrayWithObject:currentThemeName];
    
    NSString *filePath = [Helper getDocumentDirectoryPath];
    filePath = [filePath stringByAppendingPathComponent:savedThemeFileName];
    
    return [arr writeToFile:filePath atomically:NO];
    
}

- (NSString *)getSavedThemeName{
    
    NSString *filePath = [Helper getDocumentDirectoryPath];
    filePath = [filePath stringByAppendingPathComponent:savedThemeFileName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
        
        return [arr objectAtIndex:0];
    }
    
    return nil;
}

- (id)dataParserWithDataString:(NSString *)dataString{
    
    NSArray *splitString = [dataString componentsSeparatedByString:@"#"];
    
    if(splitString.count != 2){
        
        NSLog(@"Can't parser data string, wrong format, e.g [flag]-[value]");
        
        return nil;
    }
    
    NSString *flag = [splitString objectAtIndex:0];
    flag = [flag lowercaseString];
    
    NSString *value = [splitString objectAtIndex:1];
    
    if([flag isEqualToString:@"c"]){
        
        NSArray *colorValues = [value componentsSeparatedByString:@","];
        
        if(colorValues.count != 4){
            
            NSLog(@"Can't parser color value from data string, wrong format, e.g r,g,b,a");
        }
        
        float r = [colorValues[0] floatValue];
        float g = [colorValues[1] floatValue];
        float b = [colorValues[2] floatValue];
        float a = [colorValues[3] floatValue];
        
       return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/100.0f];
        
    }
    else if([flag isEqualToString:@"s"]){
        
        if([value isEqual:@""])
            return nil;
        
        return value;
        
    }
    else if([flag isEqualToString:@"n"]){
        
       return [NSNumber numberWithFloat:[value floatValue]];
    }
    else if([flag isEqual:@"b"]){
        
        return [NSNumber numberWithBool:[value boolValue]];
    }
    
    NSLog(@"Can't parser data string, unknow data flag %@", flag);
    
    return nil;
}

#pragma mark - override
- (id)init{
    
    if(self = [super init]){
        
        [self loadThemeData];
        
        if(themeData == nil || [themeData allKeys].count <= 0){
            
            NSLog(@"Load theme data fail either loading fail or no data");
            
            return self;
        }
        
        NSString *savedThemeName = [self getSavedThemeName];
        
        //if no saved theme name
        if(savedThemeName == nil){
        
            //get a random theme name as current theme name
            currentThemeName = [[themeData allKeys] objectAtIndex:0];
            
            //save it
            [self saveCurrentThemeName];
        }
        else{
            
            currentThemeName = savedThemeName;
        }
    }
    
    //test
    [self switchThemeWithThemeName:@"S-G"];
    
    return self;
}

@end
