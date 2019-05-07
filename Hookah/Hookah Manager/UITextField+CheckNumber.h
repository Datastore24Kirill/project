//
//  UITextField+CheckNumber.h
//  Kinopro365
//
//  Created by Виктор Мишустин on 11.12.16.
//  Copyright © 2016 kiviLab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CheckNumber)

//Проверка ввода телефона---
- (BOOL)checkForNamberPhoneWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                       replacementString:(NSString *)string;
//Проверка ввода русского Имени/Фамилии
- (BOOL)checkForRussianWordsWithTextField:(UITextField *)textField withString:(NSString *)string;
//Проверка ввода Английского Имени/Фамилии
- (BOOL)checkForEnglishWordsWithTextField:(UITextField *)textField withString:(NSString *)string;
//Проверка ввода e-mail
- (BOOL)validationEmailFor:(UITextField *)textField replacementString:(NSString *)string;

//Альтернатива проверки телефона
- (BOOL)checkForPhoneWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                 replacementString:(NSString *)string complitionBlock: (void (^) (NSString* response)) compitionBlock;

//Проверка числового кода
- (BOOL)checkForCodeWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string complitionBlock: (void (^) (NSString* response)) compitionBlock;

//Ввод только букв без пробелов
- (BOOL)checkForWordsWithTextField:(UITextField *)textField withString:(NSString *)string;

@end
