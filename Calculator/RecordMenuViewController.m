//
//  RecordMenuViewController.m
//  Calculator
//
//  Created by User on 21/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "RecordMenuViewController.h"
#import "RecordMenuCell.h"
#import "RecordManager.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectInnerGlow.h"

@interface RecordMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end

@implementation RecordMenuViewController

@synthesize tableView = _tableView;
@synthesize bgImageView = _bgImageView;
@synthesize clearBtn = _clearBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showNavigationBar = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal
- (void)configureCell:(RecordMenuCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    
    CalculationRecord *record = [[RecordManager sharedRecordManager] getRecordByIndex:indexPath.row];
    
    cell.processLabel.text = record.calculateRepresentation;
    cell.sumLabel.text = [NSString stringWithFormat:@"%@", record.getSum];
}

- (void)doClearHistory{
    
    [[RecordManager sharedRecordManager] clearAllRecords];
    
    [_tableView reloadData];
}

#pragma mark - override
- (void)customizeView{
    
    //Nav bar title
    self.title = @"History";
    
    //Nav bar tint color
    [self.navigationController.navigationBar setBarTintColor:[self requestUIData:@"History/NavBar/BarColor"]];
    
    //Nav bar title font, size and color
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    
    [titleBarAttributes setValue:[UIFont fontWithName:[self requestUIData:@"History/NavBar/TitleFont"] size:[[self requestUIData:@"History/NavBar/TitleSize"] floatValue]] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:[self requestUIData:@"History/NavBar/TitleFontColor"]forKey:NSForegroundColorAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    //back button color
    [self.navigationController.navigationBar setTintColor:[self requestUIData:@"History/NavBar/TitleFontColor"]];
    
    //Nav bar Translucent
    [self.navigationController.navigationBar setTranslucent:[[self requestUIData:@"History/NavBar/Translucent"] boolValue]];
    
    //Nav bar background alpha
    [(UIView*)[self.navigationController.navigationBar.subviews objectAtIndex:0] setAlpha:[[self requestUIData:@"History/NavBar/BarAlpha"] floatValue]];
    
    //background image
    [_bgImageView setImage:[UIImage imageNamed:[self requestUIData:@"History/BgImg"]]];
    
    //clear button
    [_clearBtn setTitleColor:[self requestUIData:@"History/BtnClear/TextColor"] forState:UIControlStateNormal];
    [_clearBtn setTitleColor:[self requestUIData:@"History/BtnClear/HighlightTextColor"] forState:UIControlStateHighlighted];
    [_clearBtn.titleLabel setFont:[UIFont fontWithName:[self requestUIData:@"History/BtnClear/TextFont"] size:[[self requestUIData:@"History/BtnClear/TextSize"] floatValue]]];
    [_clearBtn setBackgroundColor:[self requestUIData:@"History/BtnClear/BgColor"]];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        [self doClearHistory];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [RecordManager sharedRecordManager].recordCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"RecordCell";
    
    RecordMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        
        cell = [[RecordMenuCell alloc] init];
    }
    
    SelectInnerGlow *glow = [[SelectInnerGlow alloc] init];
    
    [cell setSelectedBackgroundView:glow];
    
    [self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.delegate respondsToSelector:@selector(onRecordSelectedWithIndex:)]){
        
        [self.delegate onRecordSelectedWithIndex:indexPath.row];
    }
    
    RecordMenuCell *cell = (RecordMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:YES animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecordMenuCell *cell = (RecordMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecordMenuCell *cell = (RecordMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell.contentView setBackgroundColor:[UIColor blackColor]];
}
 */

#pragma mark - override
- (void)onPushIntoNavigationController{
    
    
}

#pragma mark - IBAction
- (IBAction)clear:(id)sender{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Clear all history?" message:@"Do you want to clear all history?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil];
    
    [alertView show];
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
