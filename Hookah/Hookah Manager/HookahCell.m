//
//  HookahCell.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 18.02.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "HookahCell.h"


@implementation HookahCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (IBAction)actionButtonDetail:(CustomButton *)sender {
    
    [self.delegate actionButtonDetail:self andButtonSender:sender];
    
 
    
}

- (IBAction)actionBuutonChoose:(CustomButton *)sender {
    
    [self.delegate actionBuutonChoose:self andButtonSender:sender];
    
}
@end
