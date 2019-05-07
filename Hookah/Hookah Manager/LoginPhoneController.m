//
//  LoginPhoneController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "LoginPhoneController.h"
#import "APIManger.h"


@interface LoginPhoneController ()

@property (strong, nonatomic) UIButton * buttomToolbar;
@property (strong, nonatomic) NSString * phoneString;


@end

@implementation LoginPhoneController

- (void) loadView {
    [super loadView];
    
    //Localization---------
    self.labelInputPhone.text = [NSString stringWithFormat:NSLocalizedString(@"LoginPhone_labelInputPhone_text", nil)];
    
    [self setCustomTitle:[NSString stringWithFormat:NSLocalizedString(@"LoginPhone_title", nil)]];
    
    
    UIToolbar * toolbar = [self createToolBar];
    self.buttomToolbar = [[UIButton alloc] initWithTitl:[NSString stringWithFormat:
                                                               NSLocalizedString(@"LoginPhone_buttonNext", nil)]
                                                     andFrame:CGRectMake(0, 0, CGRectGetWidth(toolbar.bounds),
                                                                         CGRectGetHeight(toolbar.bounds))
                                           andBackgroundColor:@"757575" andTitlColor:@"9D9D9D"];
    [toolbar addSubview:self.buttomToolbar];
    [self.buttomToolbar addTarget:self action:@selector(actionButtonNext:) forControlEvents:UIControlEventTouchUpInside];
    self.buttomToolbar.userInteractionEnabled = NO;
    self.textFildPhone.inputAccessoryView = toolbar;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.textFildPhone becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) actionButtonNext: (UIButton*) button {
    if (self.textFildPhone.text.length < 15) {
        [self showAlertWithMessage:@"\nВведите корректный номер телефона\n"];
    } else {
        [self.view endEditing:YES];

        NSLog(@"%@", self.phoneString);
        APIManger * apiManager = [[APIManger alloc] init];
        
        NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.phoneString,@"phone",
                                 @"eKoHn6oNEC4N3P", @"app_token",nil];
        
        [self createActivitiIndicatorAlertWithView];
        self.buttomToolbar.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
        [self.buttomToolbar setTitleColor:[UIColor hx_colorWithHexRGBAString:@"9D9D9D"] forState:UIControlStateNormal];
        self.buttomToolbar.userInteractionEnabled = NO;
        
        
        [apiManager postDataFromSeverWithMethod:@"visitor.sendSmsCode" andParams:params andToken:nil
                                                                 complitionBlock:^(id response) {
            
            if([[response objectForKey:@"response"] integerValue] == 1){
                [self.textFildPhone resignFirstResponder];
                if (![self.textFildPhone isFirstResponder]){
                    [self deleteActivitiIndicator];
                    LoginInputCodeController * VC = [self.storyboard
                                                     instantiateViewControllerWithIdentifier:@"LoginInputCodeController"];
                    VC.phoneString = self.textFildPhone.text;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            }else{
                [self deleteActivitiIndicator];
                self.buttomToolbar.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"29b98f"];
                [self.buttomToolbar setTitleColor:[UIColor hx_colorWithHexRGBAString:@"FFFFFF"] forState:UIControlStateNormal];
                self.buttomToolbar.userInteractionEnabled = YES;
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                                                               [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                if(errorCode == 211){
                    [self pushControllerWithIdentifier:@"ErrorInputController"];
                }
                if(errorCode == 212){
                    [self showAlertWithMessage:@"Введите корректный номер\nтелефона"];
                }
                if(errorCode == 213){
                    [self showAlertWithMessage:@"Сервер обновляется,\nзайдите в приложение позднее"];
                }
            }
        }]; 
    }
}

#pragma mark - UITextFieldDelegate



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                       replacementString:(NSString *)string {
    
    return [textField checkForPhoneWithTextField:textField shouldChangeCharactersInRange:range replacementString:string
                                 complitionBlock:^(NSString *response) {
        
        self.phoneString = response;
        
        if(response.length == 11){
            self.buttomToolbar.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"29b98f"];
            [self.buttomToolbar setTitleColor:[UIColor hx_colorWithHexRGBAString:@"FFFFFF"] forState:UIControlStateNormal];
            self.buttomToolbar.userInteractionEnabled = YES;
        } else if (response.length != 11) {
            self.buttomToolbar.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            [self.buttomToolbar setTitleColor:[UIColor hx_colorWithHexRGBAString:@"9D9D9D"] forState:UIControlStateNormal];
            self.buttomToolbar.userInteractionEnabled = NO;
        }
    }];
}




@end
