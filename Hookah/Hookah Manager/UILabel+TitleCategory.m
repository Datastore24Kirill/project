//
//  UILabel+TitleCategory.m
//  TravelTogether
//
//  Created by Виктор Мишустин on 02/08/16.
//  Copyright © 2016 Виктор Мишустин. All rights reserved.
//

#import "UILabel+TitleCategory.h"
#import "Macros.h"

@implementation UILabel (TitleCategory)

- (id)initWithTitle: (NSString*) title
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:HM_FONT_NEUCGA_REGULAR size:20];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.text = title;
        [self sizeToFit];
    }
    return self;
}

@end
