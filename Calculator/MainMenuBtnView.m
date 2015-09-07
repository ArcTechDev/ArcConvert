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
@property (weak, nonatomic) IBOutlet UIImageView *iconBgView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *topView;

@end

@implementation MainMenuBtnView{
    
    enum ButtonViewType bType;
}

@synthesize bgView = _bgView;
@synthesize nameLabel = _nameLabel;
@synthesize iconBgView = _iconBgView;
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
    

    [_iconBgView setImage:[UIImage imageNamed:[self requestUIData:@"MainMenu/BtnView/IconBg"]]];
    
    // button name label text color
    [_nameLabel setTextColor:[self requestUIData:@"MainMenu/BtnView/TextColor"]];
    
    [self customizeIcon];
}

#pragma mark- internal
- (void)customizeIcon{
    
    switch (bType) {
        case BLength:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconLength/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconLength/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconLength/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconLength/TopTintColor"]]];
            break;
            
        case BTemperature:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconTemperature/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconTemperature/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconTemperature/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconTemperature/TopTintColor"]]];
            break;
            
         case BSpeed:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconSpeed/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconSpeed/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconSpeed/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconSpeed/TopTintColor"]]];
            break;
            
        case BArea:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconArea/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconArea/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconArea/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconArea/TopTintColor"]]];
            break;
            
        case BVolume:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconVolume/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconVolume/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconVolume/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconVolume/TopTintColor"]]];
            break;
            
        case BWeight:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconWeight/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconWeight/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconWeight/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconWeight/TopTintColor"]]];
            break;
            
        case BTime:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconTime/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconTime/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconTime/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconTime/TopTintColor"]]];
            break;
            
        case BData:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconData/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconData/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconData/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconData/TopTintColor"]]];
            break;
            
        case BCurrency:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconCurrency/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconCurrency/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconCurrency/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconCurrency/TopTintColor"]]];
            break;
            
        case BTheme:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconThemes/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconThemes/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconThemes/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconThemes/TopTintColor"]]];
            break;
            
        case BCalculator:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconCalculator/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconCalculator/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconCalculator/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconCalculator/TopTintColor"]]];
            break;
            
        case BInformation:
            
            [_bottomView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconInformation/BottomImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconInformation/BottomTintColor"]]];
            [_topView setImage:[Helper imageName:[self requestUIData:@"MainMenu/BtnIconInformation/TopImg"] withTintColor:[self requestUIData:@"MainMenu/BtnIconInformation/TopTintColor"]]];
            break;
            
        default:
            break;
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
