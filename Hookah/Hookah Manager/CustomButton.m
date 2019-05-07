//
//  CustomButton.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) setCustomIDWithDelegate:(NSString *)customIDWithDelegate{
    _customIDWithDelegate = customIDWithDelegate;
    
    [self.delegate loadTableWithCustomID:customIDWithDelegate andCustomName:self.customName];
}


@end
