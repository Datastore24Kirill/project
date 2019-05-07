//
//  LoginPhoneController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import "HexColors.h"
#import "Macros.h"
#import "UIButton+CustomButton.h"
#import "UITextField+CheckNumber.h"
#import "LoginInputCodeController.h"

@interface LoginPhoneController : MainViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFildPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelInputPhone;





@end
