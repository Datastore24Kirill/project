//
//  UIButton+CustomButton.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexColors.h"
#import "Macros.h"

@interface UIButton (CustomButton)

- (id)initWithTitl: (NSString *) titl andFrame: (CGRect) frame
andBackgroundColor: (NSString*) color andTitlColor: (NSString*) titlColor;

- (id)initWithTitle: (NSString *) titl andFrame: (CGRect) frame
 andBackgroundColor: (UIColor *) color;

@end
