//
//  ThemePickerViewController.m
//  Calculator
//
//  Created by User on 10/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "ThemePickerViewController.h"
#import "ThemePickerCell.h"
#import "ThemeManager.h"

@interface ThemePickerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation ThemePickerViewController{
    
    NSIndexPath *lastSelectedIndex;
}

@synthesize bgImageView = _bgImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showNavigationBar = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override
- (void)customizeView{
    
    //Nav bar title
    self.title = @"Themes";
    
    //display back  instead of last view controller title
    self.navigationController.navigationBar.backItem.title = @"Back";
    
    //Nav bar tint color
    [self.navigationController.navigationBar setBarTintColor:[self requestUIData:@"Themes/NavBar/BarColor"]];
    
    //Nav bar title font, size and color
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    
    [titleBarAttributes setValue:[UIFont fontWithName:[self requestUIData:@"Themes/NavBar/TitleFont"] size:[[self requestUIData:@"Themes/NavBar/TitleSize"] floatValue]] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:[self requestUIData:@"Themes/NavBar/TitleFontColor"]forKey:NSForegroundColorAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    //Nav bar Translucent
    [self.navigationController.navigationBar setTranslucent:[[self requestUIData:@"Themes/NavBar/Translucent"] boolValue]];
    
    //Nav bar background alpha
    [(UIView*)[self.navigationController.navigationBar.subviews objectAtIndex:0] setAlpha:[[self requestUIData:@"Themes/NavBar/BarAlpha"] floatValue]];
    
    //Background image
    [_bgImageView setImage:[UIImage imageNamed:[self requestUIData:@"Themes/BgImg"]]];
}

#pragma mark - UICollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[ThemeManager sharedThemeManager] getAllThemes].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((collectionView.frame.size.width - 5)/2, (collectionView.frame.size.height-5)/2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"CollectionCell";
    
    ThemePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil){
        
        cell = [[ThemePickerCell alloc] init];
    }
    
    NSString *themeName = [[[ThemeManager sharedThemeManager] getAllThemes] objectAtIndex:indexPath.row];
    
    [cell setThemeImage:[UIImage imageNamed:themeName]];
    
    
    if([[[ThemeManager sharedThemeManager] getCurrentThemeName] isEqual:themeName]){
        
        [cell setThemeSelect:YES];
        lastSelectedIndex = indexPath;
        
    }
    else{
        
        [cell setThemeSelect:NO];
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ThemeManager *themeMgr = [ThemeManager sharedThemeManager];
    
    [themeMgr switchThemeWithThemeName:[[themeMgr getAllThemes] objectAtIndex:indexPath.row]];
    
    [(ThemePickerCell *)[collectionView cellForItemAtIndexPath:lastSelectedIndex] setThemeSelect: NO];
    
    ThemePickerCell *cell = (ThemePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell setThemeSelect:YES];
    
    lastSelectedIndex = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //[cell setBackgroundColor:[UIColor clearColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
