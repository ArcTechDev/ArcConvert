//
//  UnitPickViewController.m
//  Calculator
//
//  Created by User on 28/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "UnitPickViewController.h"
#import "UnitPickCell.h"
#import "Helper.h"

@interface UnitPickViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UnitPickViewController{
    
    NSArray *units;
}

@synthesize tableView = _tableView;
@synthesize unitToDisplay = _unitToDisplay;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Setter
- (void)setUnits:(NSArray *)unitToDisplay{
    
    units = unitToDisplay;
}

#pragma mark - internal

- (void)configureCell:(UnitPickCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    //when display we need to convert string from plist that might contain unicode to new string
    //so special unicode character can display properly
    cell.titleLabel.text = [Helper getUnicodeStringFromString:[units objectAtIndex:indexPath.row]];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(units != nil){
        
        return units.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"UnitPickCell";
    
    UnitPickCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        
        cell = [[UnitPickCell alloc] init];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.delegate respondsToSelector:@selector(onUnitPickViewSelectUnitAtIndex:withUnitName:)]){
        
        [self.delegate onUnitPickViewSelectUnitAtIndex:indexPath.row withUnitName:[units objectAtIndex:indexPath.row]];
    }
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
