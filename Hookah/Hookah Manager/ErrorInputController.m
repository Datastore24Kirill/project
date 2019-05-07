//
//  ErrorInputController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "ErrorInputController.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "UserInformationTable.h"

@interface ErrorInputController ()
@property (strong, nonatomic) UserInformationTable * userInformationTable;
@end

@implementation ErrorInputController

- (void) loadView {
    [super loadView];
    
    //Localization---------
    self.labelDescription.text = [NSString stringWithFormat:NSLocalizedString(@"ErrorInputController_labelDescription", nil)];
    self.labelPhone.text = [NSString stringWithFormat:NSLocalizedString(@"ErrorInputController_labelPhone", nil)];
    self.labelPassword.text = [NSString stringWithFormat:NSLocalizedString(@"ErrorInputController_labelPass", nil)];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self setCustomTitle:[NSString stringWithFormat:NSLocalizedString(@"ErrorInputController_title", nil)]];
    
    UIToolbar * toolbar = [self createToolBar];
    UIButton * buttomToolbar = [[UIButton alloc] initWithTitl:[NSString stringWithFormat:
                                                               NSLocalizedString(@"ErrorInputController_buttonNext", nil)]
                                                     andFrame:CGRectMake(0, 0, CGRectGetWidth(toolbar.bounds),
                                                                         CGRectGetHeight(toolbar.bounds))
                                           andBackgroundColor:@"29B98F" andTitlColor:@"FFFFFF"];
    [toolbar addSubview:buttomToolbar];
    [buttomToolbar addTarget:self action:@selector(actionButtonNext:) forControlEvents:UIControlEventTouchUpInside];
    self.textFildLogin.inputAccessoryView = toolbar;
    self.textFildPassword.inputAccessoryView = toolbar;
    
    self.userInformationTable = [[UserInformationTable alloc] init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.textFildLogin becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    if ([textField isEqual:self.textFildLogin]) {
        return [textField checkForPhoneWithTextField:textField shouldChangeCharactersInRange:range replacementString:string complitionBlock:^(NSString *response) {
            
        }];
    }
    
    return YES;
}

#pragma mark - Action

- (void) actionButtonNext: (UIButton*) sender {
    
    if (self.textFildLogin.text.length < 7 || self.textFildPassword.text.length == 0) {
        if(self.textFildLogin.text.length < 7){
                [self showAlertWithMessage:@"\nВведите Ваш номер телефона\n"];
        }else if (self.textFildPassword.text.length == 0){
                [self showAlertWithMessage:@"\nВведите Ваш пароль\n"];
        }
        
    } else {
        APIManger * apiManager = [[APIManger alloc] init];
        NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.textFildLogin.text,@"login",
                                 self.textFildPassword.text, @"password",
                                 @"GUID", @"device_token",
                                 @"2",@"os_type",nil];
        
        [apiManager postDataFromSeverWithMethod:@"visitor.authByLoginAndPass" andParams:params andToken:nil
                                complitionBlock:^(id response) {
                                    
                                    NSDictionary * respDict = [response objectForKey:@"response"];
                                    
                                    if([response objectForKey:@"error_code"]){
                                        NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                                              [response objectForKey:@"error_msg"]);
                                        
                                    }else{
                                        
                                        
                                        [self.userInformationTable insertDataIntoDataBaseWithToken:[respDict objectForKey:@"token"]
                                                                                         andCityID:@"" deviceToken:@"GUID"];
                                        [[SingleTone sharedManager] setToken:[respDict objectForKey:@"token"]];
                                        
                                        //Пользователь не зарегистрирован
                                        if([[respDict objectForKey:@"state"] integerValue] == 0){
                                            [self pushControllerWithIdentifier:@"RegistrationMainController"];
                                        }else{
                                            //Пользователь зарегистрирован
                                            //                    [self pushCountryControllerWithIdentifier:@"ОКНА ЕЩЕ НЕТ"];
                                            
                                        }
                                    }
                                    
                                    
                                }];

    }
    
    
}

@end
