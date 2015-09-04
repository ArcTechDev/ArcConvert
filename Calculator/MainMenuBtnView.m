//
//  MainMenuBtnView.m
//  Calculator
//
//  Created by User on 4/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "MainMenuBtnView.h"

@interface MainMenuBtnView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *topView;

@end

@implementation MainMenuBtnView{
    
    enum ButtonViewType bType;
}

@synthesize bgView = _bgView;
@synthesize nameLabel = _nameLabel;
@synthesize bottomView = _bottomView;
@synthesize topView = _topView;

#pragma mark - public interface
- (void)setButtonViewType:(enum ButtonViewType)type{
    
    bType = type;
}

#pragma mark - override
- (void)customizeView{
    
    //Background image
    [_bgView setImage:[UIImage imageNamed:[self requestUIData:@"MainMenu/BtnView/BgImg"]]];
    
    //label font, size and color
    [_nameLabel setFont:[UIFont fontWithName:[self requestUIData:@"MainMenu/BtnView/TextFont"] size:[[self requestUIData:@"MainMenu/BtnView/TextSize"] floatValue]]];
    
    [_nameLabel setTextColor:[self requestUIData:@"MainMenu/BtnView/TextColor"]];
}

#pragma mark- internal
- (void)customizeIcon{
    
    if(bType == BTime){
        
        [_bottomView setImage:[UIImage imageNamed:[self requestUIData:@"MainMenu/BtnIconTime/BottomImg"]]];
        [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconTime/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconTime/TopTintColor"]]];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
