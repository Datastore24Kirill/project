//
//  ChooseFlavorCell.m
//  Hookah Manager
//
//  Created by Viktor on 3/22/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseFlavorCell.h"

@implementation ChooseFlavorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionSwich:(UISwitch *)sender {
    [self.delegate actionCell:self withSwich:sender];
}
@end
