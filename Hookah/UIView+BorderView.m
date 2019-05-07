//
//  UIView+BorderView.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 06.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "UIView+BorderView.h"
#import "HexColors.h"

@implementation UIView (BorderView)

+ (UIView*) createBorderViewWithView: (UIView*) mainView andHeight: (CGFloat) height {
    
    CGRect rectBorderView = CGRectZero;
    rectBorderView.origin = CGPointMake(0, height);
    rectBorderView.size = CGSizeMake(CGRectGetWidth(mainView.bounds), 1);
    UIView * borderView = [[UIView alloc] initWithFrame:rectBorderView];
    borderView.backgroundColor = [UIColor whiteColor];
    borderView.alpha = 0.1f;
    
    return borderView;
}

+ (UIView*) createGrayBorderViewWithView: (UIView*) mainView andHeight: (CGFloat) height {
    
    CGRect rectBorderView = CGRectZero;
    rectBorderView.origin = CGPointMake(0, height);
    rectBorderView.size = CGSizeMake(CGRectGetWidth(mainView.bounds), 1);
    UIView * borderView = [[UIView alloc] initWithFrame:rectBorderView];
    borderView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"ededed"];
    
    return borderView;
}



@end
