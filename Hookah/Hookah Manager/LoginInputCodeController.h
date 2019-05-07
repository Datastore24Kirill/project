//
//  LoginInputCodeController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 27.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import "HexColors.h"
#import "Macros.h"
#import "UIButton+CustomButton.h"
#import "UITextField+CheckNumber.h"

@interface LoginInputCodeController : MainViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFildCode;
@property (weak, nonatomic) IBOutlet UILabel *labelSendMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonCodeAgain;

@property (strong, nonatomic) NSString * phoneString;

- (IBAction)actionButtonCodeAgain:(UIButton *)sender;


@end
