//
//  UIButton+CustomButton.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "UIButton+CustomButton.h"

@implementation UIButton (CustomButton)


- (id)initWithTitl: (NSString *) titl andFrame: (CGRect) frame
                            andBackgroundColor: (NSString*) color andTitlColor: (NSString*) titlColor {
    
    self = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor hx_colorWithHexRGBAString:color];
        [self setTitle:titl forState:UIControlStateNormal];
        [self setTitleColor:[UIColor hx_colorWithHexRGBAString:titlColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:HM_FONT_NEUCGA_REGULAR size:18];
    }
    return self;
}

- (id)initWithTitle: (NSString *) titl andFrame: (CGRect) frame
andBackgroundColor: (UIColor *) color  {
    
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.frame = frame;
        self.backgroundColor = color;
        [self setTitle:titl forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:HM_FONT_NEUCGA_REGULAR size:18];
    }
    return self;
}

@end
