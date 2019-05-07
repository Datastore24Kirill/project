//
//  UITextField+CheckNumber.m
//  Kinopro365
//
//  Created by Виктор Мишустин on 11.12.16.
//  Copyright © 2016 kiviLab.com. All rights reserved.
//

#import "UITextField+CheckNumber.h"

@implementation UITextField (CheckNumber)

- (BOOL)checkForNamberPhoneWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                       replacementString:(NSString *)string
{
    
    NSCharacterSet * validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray * components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray * validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 1;
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        return NO;
    }
    
    NSMutableString * resultString = [NSMutableString string];
    
    NSInteger localNumberLength = MIN((int)newString.length, localNumberMaxLength);
    
    if (localNumberLength > 0) {
        NSString * number = [newString substringFromIndex:(int)newString.length - localNumberLength];
        [resultString appendString:number];
        if ([resultString length] > 3) {
            [resultString insertString:@"" atIndex:3];
        }
    }
    
    if ([newString length] > localNumberLength) {
        NSInteger areaCodeLength = MIN((int)newString.length - localNumberMaxLength, areaCodeMaxLength);
        NSRange areaRange = NSMakeRange((int)newString.length - localNumberMaxLength - areaCodeLength, areaCodeLength);
        NSString * area = [newString substringWithRange:areaRange];
        area = [NSString stringWithFormat:@"(%@)", area];
        [resultString insertString:area atIndex:0];
    }
    
    if ([newString length] > localNumberLength + areaCodeMaxLength) {
        NSInteger countryCodeLength = MIN((int)newString.length - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        NSRange countryRange = NSMakeRange(0, countryCodeLength);
        NSString * coutry = [newString substringWithRange:countryRange];
        coutry = [NSString stringWithFormat:@"+%@", coutry];
        [resultString insertString:coutry atIndex:0];
    }
    textField.text = resultString;
    
    return NO;
}

- (BOOL)checkForRussianWordsWithTextField:(UITextField *)textField withString:(NSString *)string {
    
    NSCharacterSet * validationSet = [[NSCharacterSet characterSetWithCharactersInString:
                                                                    @"ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ"
                                                                    @"йцукенгшщзхъфывапролджэячсмитьбю"] invertedSet];

     NSArray * components = [string componentsSeparatedByCharactersInSet:validationSet];
    if ([components count] > 1) {
        return NO;
    }
    return YES;  
}

- (BOOL)checkForEnglishWordsWithTextField:(UITextField *)textField withString:(NSString *)string {
    
    NSCharacterSet * validationSet = [[NSCharacterSet characterSetWithCharactersInString:
                                                                    @"QWERTYUIOPASDFGHJKLZXCVBNM"
                                                                    @"qwertyuiopasdfghjklzxcvbnm"] invertedSet];
    
    NSArray * components = [string componentsSeparatedByCharactersInSet:validationSet];
    if ([components count] > 1) {
        return NO;
    }
    return YES;
}

- (BOOL)checkForWordsWithTextField:(UITextField *)textField withString:(NSString *)string {
    
    NSCharacterSet * validationSet = [[NSCharacterSet characterSetWithCharactersInString:
                                       @"QWERTYUIOPASDFGHJKLZXCVBNM"
                                       @"qwertyuiopasdfghjklzxcvbnmЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ"
                                       @"йцукенгшщзхъфывапролджэячсмитьбю"] invertedSet];
    
    NSArray * components = [string componentsSeparatedByCharactersInSet:validationSet];
    if ([components count] > 1) {
        return NO;
    }
    return YES;
}

- (BOOL)validationEmailFor:(UITextField *)textField replacementString:(NSString *)string {
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:
                                                                   @".ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvw"
                                                                   @"xyz@0123456789_"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    if ([textField.text rangeOfString:@"@"].location == NSNotFound && [string rangeOfString:@"@"].location != NSNotFound) {
        return [string isEqualToString:filtered];
        
    } else if ([string rangeOfString:@"@"].location == NSNotFound) {
        
        return [string isEqualToString:filtered];
    } else {
        return NO;
    }
}

- (BOOL)checkForPhoneWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                 replacementString:(NSString *)string complitionBlock: (void (^) (NSString* response)) compitionBlock {
    if (range.location == 0) {
        return NO;
    }
    
    if (string.length == 0) {
        return YES;
    }
    
    NSCharacterSet *invalidCharSet = [NSCharacterSet characterSetWithCharactersInString:
                                       @" ,*#;+"];
    NSArray * components = [string componentsSeparatedByCharactersInSet:invalidCharSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray * validComponents = [newString componentsSeparatedByCharactersInSet:invalidCharSet];
    newString = [validComponents componentsJoinedByString:@""];
    
    if (newString.length > 11) {
        
        return NO;
    }
    
    NSMutableString * resultString = [NSMutableString string];
    [resultString appendString:newString];
    
    [resultString insertString:@"+" atIndex:0];
    
    if (resultString.length >= 3) {
        [resultString insertString:@" " atIndex:2];
    }
    
    if (resultString.length >= 7) {
        [resultString insertString:@" " atIndex:6];
    }
    
    if (resultString.length >= 11) {
        [resultString insertString:@" " atIndex:10];
    }
    
    compitionBlock(newString);
    
    textField.text = resultString;
    
    NSInteger offset = range.location + string.length;
    
    if (range.location == 2 || range.location == 6 || range.location == 10) {
        offset++;
    }
    
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *cursorLocation = [textField positionFromPosition:beginning
                                                              offset:offset];
    UITextRange *newSelectedRange = [textField textRangeFromPosition:cursorLocation
                                                          toPosition:cursorLocation];
    [textField setSelectedTextRange:newSelectedRange];
    
    return NO;
    
}

- (BOOL)checkForCodeWithTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                 replacementString:(NSString *)string complitionBlock: (void (^) (NSString* response)) compitionBlock {
    
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newString.length > 8) {
        return NO;
    }
    
    compitionBlock (newString);
    
    textField.text = newString;
    
    return NO;
}




@end
