//
//  ConverterInputView.h
//  Calculator
//
//  Created by User on 9/9/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "DelegateView.h"

enum ConverterInputViewType{
    
    CInputTop,
    CInputDown
};

@interface ConverterInputView : DelegateView

- (void)setInputViewType:(enum ConverterInputViewType)type;

@end
