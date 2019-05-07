//
//  RegistrationMainController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 28.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import "HexColors.h"
#import "Macros.h"
#import "UIButton+CustomButton.h"
#import "UITextField+CheckNumber.h"

@interface RegistrationMainController : MainViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegistration;

//Из-за того что обхекты находятся в табличных ячейках, придется создавтаь проперти вручную,
//                                                   и инициализировать при создании таблицы

@property (strong, nonatomic) UITextField * textFildName;
@property (strong, nonatomic) UITextField * textFildPassword;
@property (strong, nonatomic) UITextField * textFildConfirmPassword;

@property (strong, nonatomic) UIButton * buttonBirthday;

//Actions----

- (IBAction)actionButtonRegistration:(UIButton *)sender;
- (IBAction)actionButtonBirthday:(UIButton *)sender;

@end
