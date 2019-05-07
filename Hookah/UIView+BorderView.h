//
//  UIView+BorderView.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 06.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BorderView)

//СОздание границы для таблицы
+ (UIView*) createBorderViewWithView: (UIView*) mainView andHeight: (CGFloat) height;
+ (UIView*) createGrayBorderViewWithView: (UIView*) mainView andHeight: (CGFloat) height;

@end
