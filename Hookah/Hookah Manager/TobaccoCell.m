//
//  TobaccoCell.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.02.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "TobaccoCell.h"

@implementation TobaccoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionButtonChoose:(CustomButton *)sender {
    [self.delegate actionButtonChoose:self andButtonSender:sender];
}

- (IBAction)actionButtonDetail:(CustomButton *)sender {
    NSLog(@"actionButtonDetail %@",sender.customFullName);
    [self.delegate actionButtonDetail:self andButtonSender:sender];
}

- (IBAction)actionButtonShares:(CustomButton *)sender {
}
@end
