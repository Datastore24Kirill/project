//
//  LoginInputCodeController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 27.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "LoginInputCodeController.h"
#import "APIManger.h"
#import "UserInformationTable.h"
#import "RegistrationMainController.h"
#import "SingleTone.h"

@interface LoginInputCodeController ()
@property (strong, nonatomic) UserInformationTable * userInformationTable;
@property (strong, nonatomic) UIButton * buttonToolbar;
@property (assign, nonatomic) NSInteger timerStep; //Счетчик таймера
@property (strong, nonatomic) NSTimer * timerCode;

@end

@implementation LoginInputCodeController

- (void) loadView {
    [super loadView];
    
    //Localization---------
    NSString * firstPartDiscription = [NSString stringWithFormat:
                                       NSLocalizedString(@"LoginInputCodeController_labelDescription_first", nil)];
    NSString * secondPartDiscription = [NSString stringWithFormat:
                                       NSLocalizedString(@"LoginInputCodeController_labelDescription_second", nil)];
    self.labelSendMessage.text =
                          [NSString stringWithFormat:@"%@%@%@", firstPartDiscription, self.phoneString, secondPartDiscription];
    
    self.labelCode.text = [NSString stringWithFormat:NSLocalizedString(@"LoginInputCodeController_labelInputCode", nil)];
    [self.buttonCodeAgain setTitle:[NSString stringWithFormat:
                                    NSLocalizedString(@"LoginInputCodeController_buttonCodeAgain", nil)]
                          forState:UIControlStateNormal];
    self.buttonCodeAgain.alpha = 0.f;
    
    
    
    self.navigationItem.hidesBackButton = YES;
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self setCustomTitle:[NSString stringWithFormat:NSLocalizedString(@"LoginInputCodeController_title", nil)]];
    
    UIToolbar * toolbar = [self createToolBar];
    self.buttonToolbar = [[UIButton alloc] initWithTitl:[NSString stringWithFormat:
                                                               NSLocalizedString(@"LoginInputCodeController_buttonNext", nil)]
                                                     andFrame:CGRectMake(0, 0, CGRectGetWidth(toolbar.bounds),
                                                                         CGRectGetHeight(toolbar.bounds))
                                           andBackgroundColor:@"757575" andTitlColor:@"9D9D9D"];
    self.buttonToolbar.userInteractionEnabled = NO;
    [toolbar addSubview:self.buttonToolbar];
    [self.buttonToolbar addTarget:self action:@selector(actionButtonNext:) forControlEvents:UIControlEventTouchUpInside];
    self.textFildCode.inputAccessoryView = toolbar;
    self.labelSendMessage.text = [NSString stringWithFormat:
                                  @"На номер %@ отправлено сообщение с кодом подтверждения", self.phoneString];
    
    self.userInformationTable = [[UserInformationTable alloc] init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timerStep = 30;
    
    [self startTimerOnButton:self.buttonCodeAgain];

}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.textFildCode becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) actionButtonNext: (UIButton*) button {
    if (self.textFildCode.text.length < 4) {
        [self showAlertWithMessage:@"\nМинимальный код состоит из\n4 символов\n"];
    } else {
        
        APIManger * apiManager = [[APIManger alloc] init];
        NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.phoneString,@"phone",
                                 self.textFildCode.text, @"sms_code",
                                 @"GUID", @"device_token",
                                 @"2",@"os_type",nil];
        [self createActivitiIndicatorAlertWithView];
        [apiManager postDataFromSeverWithMethod:@"visitor.authBySmsCode" andParams:params andToken:nil
                                                                   complitionBlock:^(id response) {
            NSDictionary * respDict = [response objectForKey:@"response"];
            
            if([response objectForKey:@"error_code"]){
                [self deleteActivitiIndicator];
               NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                                                              [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                if(errorCode == 221){
                    [self showAlertWithMessage:@"Вы ввели не верный\nSMS код"];
                }
                if(errorCode == 222){
                    [self showAlertWithMessage:@"Введенный код не верен.\nЗапросите код повторно"];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.buttonCodeAgain.alpha = 1.f;
                    }];
                    self.textFildCode.text = @"";
                    self.textFildCode.userInteractionEnabled = NO;
                    [self deleteTimer];
                }
                if(errorCode == 223){
                    [self showAlertWithMessage:@"Вам ограничили доступ к сервису"];
                    
                    self.textFildCode.userInteractionEnabled = NO;
                    self.buttonToolbar.userInteractionEnabled = NO;
                    [self deleteTimer];
                }
                
            }else{
                
                NSLog(@"STATE %@ token %@",[respDict objectForKey:@"state"], [respDict objectForKey:@"token"]);
                [self.userInformationTable insertDataIntoDataBaseWithToken:[respDict objectForKey:@"token"]
                                                                 andCityID:@"" deviceToken:@"GUID"];
                [[SingleTone sharedManager] setToken:[respDict objectForKey:@"token"]];
                
                NSLog(@"INFO LOGIN %@", response);
                //Пользователь не зарегистрирован
                if([[respDict objectForKey:@"state"] integerValue] == 0){
                     [self deleteActivitiIndicator];
                    [self pushControllerWithIdentifier:@"RegistrationMainController"];
                }else if([[respDict objectForKey:@"state"] integerValue] == 1){
                     [self deleteActivitiIndicator];
                    [self pushControllerWithIdentifier:@"CountryController"];
                
                }else if([[respDict objectForKey:@"state"] integerValue] == 2){
                //Пользователь зарегистрирован
                   
                    [apiManager getDataFromSeverWithMethod:@"visitor.getProfile" andParams:nil
                                                  andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
                        [self deleteActivitiIndicator];
                        if([response objectForKey:@"error_code"]){
                            NSLog(@"МЕТОД: visitor.getProfile");
                            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                                  [response objectForKey:@"error_msg"]);
                        }else{
                            
                            NSDictionary * respProfileDict = [response objectForKey:@"response"];
                           
                            NSLog(@"%@",respProfileDict);
                            RLMResults * tableDataArray=[UserInformationTable allObjects];
                            
                            if (tableDataArray.count >0 ){
                                UserInformationTable * selectedDataObject = [tableDataArray objectAtIndex:0];
                                
                                RLMRealm *realm = [RLMRealm defaultRealm];
                                [realm beginWriteTransaction];
                                if([[respProfileDict objectForKey:@"city"] isKindOfClass:[NSDictionary class]]){
                                    NSDictionary * cityDict = [respProfileDict objectForKey:@"city"];
                                    
                                  
                                    selectedDataObject.city_id=[NSString stringWithFormat:@"%@",[cityDict objectForKey:@"id"]];
                                    [realm commitWriteTransaction];
                                    [self pushControllerWithIdentifier:@"MenuBarController"];
                                }else{
                                    [self showAlertWithMessage:@"Произошла неизвестная ошибка,\nсообщите о ней администратору"];
                                }
                            }
                        }
                       
                    }];
                }
            }
        }];
    }
}

- (IBAction)actionButtonCodeAgain:(UIButton *)sender {
    
    NSLog(@"%@", self.phoneString);
    APIManger * apiManager = [[APIManger alloc] init];
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             self.phoneString,@"phone",
                             @"eKoHn6oNEC4N3P", @"app_token",nil];
    
    [self createActivitiIndicatorAlertWithView];
    
    
    [apiManager postDataFromSeverWithMethod:@"visitor.sendSmsCode" andParams:params andToken:nil
                            complitionBlock:^(id response) {
                                
                                if([[response objectForKey:@"response"] integerValue] == 1){
                                    
                                        [self deleteActivitiIndicator];
                        
                                }else{
                                    [self deleteActivitiIndicator];
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

    
    [self startTimerOnButton:sender];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    return [textField checkForCodeWithTextField:textField shouldChangeCharactersInRange:range
                              replacementString:string complitionBlock:^(NSString *response) {
        
        if(response.length >= 4){
            self.buttonToolbar.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"29b98f"];
            [self.buttonToolbar setTitleColor:[UIColor hx_colorWithHexRGBAString:@"FFFFFF"] forState:UIControlStateNormal];
            self.buttonToolbar.userInteractionEnabled = YES;
        } else if (response.length < 4) {
            self.buttonToolbar.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
            [self.buttonToolbar setTitleColor:[UIColor hx_colorWithHexRGBAString:@"9D9D9D"] forState:UIControlStateNormal];
            self.buttonToolbar.userInteractionEnabled = NO;
        }
        
    }];
}

#pragma mark - Timer

//Запуск таймера
- (void) startTimerOnButton: (UIButton*) button {
    
    [UIView animateWithDuration:0.3 animations:^{
        button.alpha = 0.f;
    }];
    
    if (self.textFildCode.userInteractionEnabled == NO) {
        self.textFildCode.userInteractionEnabled = YES;
    }
    
    self.timerCode = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(actionTimer:) userInfo:nil
                                                     repeats:YES];
}

//Действие таймера
- (void) actionTimer: (NSTimer*) timer {
    self.timerStep -= 1;
    
    NSLog(@"%ld", (long)self.timerStep);
    
    if (self.timerStep == 0) {
        [self.timerCode invalidate];
        self.timerCode = nil;
        self.timerStep = 30;
        [UIView animateWithDuration:0.3 animations:^{
            self.buttonCodeAgain.alpha = 1.f;
        }];
    }
}

- (void) deleteTimer {
    [self.timerCode invalidate];
    self.timerCode = nil;
    self.timerStep = 30;
}

- (void) actionBackButton: (UIBarButtonItem*) button {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
