//
//  DelegateView.m
//  Calculator
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "DelegateView.h"

@implementation DelegateView{
    
    __weak ThemeManager *themeMgr;
}

@synthesize delegate = _delegate;

#pragma mark - override
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        themeMgr = [ThemeManager sharedThemeManager];
    }
    
    return self;
}

#pragma mark - public  interface
- (void)customizeView{
    
    
}

- (id)requestUIData:(NSString *)pathString{
    
    return [themeMgr requestCustomizedUIDataWithPathString:pathString];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
