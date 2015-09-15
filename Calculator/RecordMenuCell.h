//
//  RecordMenuCell.h
//  Calculator
//
//  Created by User on 21/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordMenuCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *processLabel;
@property(weak, nonatomic) IBOutlet UILabel *sumLabel;

- (void)highlight;
- (void)unhighlight;

@end
