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

@end

@implementation RecordMenuViewController

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
    
    [self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.delegate respondsToSelector:@selector(onRecordSelectedWithIndex:)]){
        
        [self.delegate onRecordSelectedWithIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
