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

@interface RecordMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecordMenuViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    UIView *bView = [[UIView alloc] init];
    bView.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:204.0/255.0 blue:177.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bView];
    
    [self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.delegate respondsToSelector:@selector(onRecordSelectedWithIndex:)]){
        
        [self.delegate onRecordSelectedWithIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell.contentView setBackgroundColor:[UIColor blackColor]];
}
 */

#pragma mark - override
- (void)onPushIntoNavigationController{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
