//
//  ViewController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexColors.h"
#import "Macros.h"
#import "UILabel+TitleCategory.h"
#import "CustomButton.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSArray * arrayPickerView;
@property (strong, nonatomic) NSString * pickerViewString; //Сохраняет выбранный параметр в пикерВью
@property (strong, nonatomic) NSString * pickerViewStringID;
@property (strong, nonatomic) NSString * pickerViewStringValueID;
@property (strong, nonatomic) NSString * pickerDictKeyTitle; //Ключ для массива, где внутри коллекция
@property (strong, nonatomic) NSString * pickerDictKeyID; //Ключ для массива, где внутри коллекц

//кастомный заголовок для Нав контрол.
- (void) setCustomTitle: (NSString*) title;

//Создание тулбара-------
- (UIToolbar*) createToolBar;

//Переход к новому контроллеру---
- (void) pushControllerWithIdentifier: (NSString*) identifier;

//Алерты--------
- (void) showAlertWithMessage: (NSString*) message;
- (void) showAlertWithMessageWithBlock: (NSString*) message block: (void (^)(void)) compilationBack;
- (void) showDataPickerBirthdayWithButton: (UIButton*) button;
- (void) showViewPickerWithButton: (CustomButton*) button andTitl: (NSString*) message andArrayData: (NSArray *) arrayData andKeyTitle:(NSString *) dictKeyTitle andKeyID:(NSString *) dictKeyID andDefValueIndex: (NSString *) defValueIndex;
- (void) showTextFildNameWithButton: (CustomButton*) button withBlockAction: (void(^)(void)) blockAction ;
- (void) showDataPickerBirthdayActionWithButton: (UIButton*) button withBlockAction: (void(^)(void)) blockAction;

//Джестер на скрытие всех textFilds
- (void) hideAllTextFildWithMainView: (UIView*) view;

//Создание и удаление Активити
- (void) createActivitiIndicatorAlertWithView;
- (void) deleteActivitiIndicator;

- (NSString*) refactDateString: (NSDate*) date;


- (void)setCustomNavigationBackButton;

//Получаем текущую дату с учетом TimeZone
-(NSDate *) getLocalDate;

+(NSString *) checkStringToNull:(NSString *) string;
+(NSString *) checkIdToNull:(id) string;

@end

