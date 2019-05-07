//
//  ButtonMenu.m
//  FlowersOnline
//
//  Created by Viktor on 30.04.16.
//  Copyright © 2016 datastore24. All rights reserved.
//

#import "ButtonMenu.h"

@implementation ButtonMenu



+ (UIButton*) createButtonBack
{
    UIImage *imageBarButton = [UIImage imageNamed:@"backButtonImage"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 20, 20);
    CGRect rect = button.frame;
    rect.origin.y += 16;
    rect.origin.x -= 5;
    button.frame = rect;
    [button setImage:imageBarButton forState:UIControlStateNormal];
    
    return button;
}

@end
