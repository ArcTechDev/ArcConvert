//
//  CacheManager.h
//  Calculator
//
//  Created by User on 14/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CacheManager : NSCache

+ (CacheManager *)sharedManager;

@end
