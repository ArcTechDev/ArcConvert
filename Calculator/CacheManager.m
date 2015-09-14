//
//  CacheManager.m
//  Calculator
//
//  Created by User on 14/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "CacheManager.h"


@implementation CacheManager

static CacheManager *instance;

+ (CacheManager *)sharedManager{
    
    if(instance == nil){
        
        instance = [[CacheManager alloc] init];
        
        instance.name = @"CacheManager";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return instance;
    
}

- (void)didReceiveMemoryWarning:(NSNotification *)notify{
    
    NSLog(@"Cache Manager encounter memory warning....remove all cache");
    
    [self removeAllObjects];
}

@end
