//
//  ErrorInputController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import "HexColors.h"
#import "Macros.h"
#import "UIButton+CustomButton.h"
#import "UITextField+CheckNumber.h"

@interface ErrorInputController : MainViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFildLogin;
@property (weak, nonatomic) IBOutlet UITextField *textFildPassword;

@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@end
