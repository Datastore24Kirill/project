//
//  RegistrationMainController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 28.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "RegistrationMainController.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "UserInformationTable.h"
#import "DateTimeMethod.h"
#import "CountryController.h"
#import "NameTableViewCell.h"
#import "BirthdayTableViewCell.h"
#import "PasswordTableViewCell.h"
#import "confPasswordTableViewCell.h"

@interface RegistrationMainController ()

@property (assign, nonatomic) CGFloat heightUpView;
@property (strong, nonatomic) UserInformationTable * selectedDataObject;
@property (strong, nonatomic) RLMResults *tableDataArray;

@property (strong, nonatomic) NSArray * arrayCell;


@end

@implementation RegistrationMainController

- (void) loadView {
    [super loadView];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = NO;
    [self hideAllTextFildWithMainView:self.view];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.userInteractionEnabled = YES;
    
    [self setCustomTitle:[NSString stringWithFormat:NSLocalizedString(@"RegistrationMainController_title", nil)]];
    [self.buttonRegistration setTitle:[NSString stringWithFormat:
                                       NSLocalizedString(@"RegistrationMainController_buttonRegistration", nil)]
                             forState:UIControlStateNormal];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCell = [NSArray arrayWithObjects:@"Cell1", @"Cell2", @"Cell3", @"Cell4", nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.textFildName]) {
        return [textField checkForWordsWithTextField:textField withString:string];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.textFildPassword]) {
        if ([[UIScreen mainScreen] bounds].size.height == 568.0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.contentOffset = CGPointMake(0, 62);
            }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayCell.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * identifier = [self.arrayCell objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        NameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.nameLabel.text = [NSString stringWithFormat:
                               NSLocalizedString(@"RegistrationMainController_labelName", nil)];
        self.textFildName = cell.textFildName;
        return cell;
    } else if (indexPath.row == 1) {
        BirthdayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.birthdayLabel.text = [NSString stringWithFormat:
                                   NSLocalizedString(@"RegistrationMainController_labelBirthday", nil)];
        self.buttonBirthday = cell.buttonBirthday;
        return cell;
    } else if (indexPath.row == 2) {
        PasswordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.passwordLabel.text = [NSString stringWithFormat:
                                   NSLocalizedString(@"RegistrationMainController_labelPass", nil)];
        self.textFildPassword = cell.passwordTextFild;
        return cell;
    } else {
        confPasswordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.confPasswordLabel.text = [NSString stringWithFormat:
                                       NSLocalizedString(@"RegistrationMainController_labelConfPass", nil)];
        self.textFildConfirmPassword = cell.confPasswordTextFild;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

#pragma mark - Actions

- (IBAction)actionButtonRegistration:(UIButton *)sender {
    
    if (self.textFildName.text.length == 0) {
        [self showAlertWithMessage:@"\nВведите имя\n"];
    } else if (self.buttonBirthday.titleLabel.text.length == 0) {
        [self showAlertWithMessage:@"\nВыберите дату своего рождения\n"];
    } else if (self.textFildPassword.text.length == 0) {
        [self showAlertWithMessage:@"\nВведите пароль\n"];
    } else if (![self.textFildPassword.text isEqualToString:self.textFildConfirmPassword.text]) {
        [self showAlertWithMessage:@"\nВведённые пароли не совпадают\n"];
    } else {
        NSLog(@"Go %@",[[SingleTone sharedManager] birthdayDate]);
        NSDate * birthdayDate =[[SingleTone sharedManager] birthdayDate];
        
        NSString * dateTimestamp =[DateTimeMethod dateToTimestamp:birthdayDate];
        
        NSLog(@" DATE %@",dateTimestamp);
        APIManger * apiManager = [[APIManger alloc] init];
        NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.textFildName.text, @"name",
                                 dateTimestamp, @"birthday",
                                 self.textFildPassword.text, @"password",nil];
        
        //Проверка токена в СинглТоне на дурака, в случае сбоя загрузки из SingleTone
        NSString * singleToneToken = [[SingleTone sharedManager] token];
        NSString * token;
        if(singleToneToken.length !=0){
            token = singleToneToken;
        }else{
            self.tableDataArray=[UserInformationTable allObjects];
            if (self.tableDataArray.count >0 ){
                self.selectedDataObject = [self.tableDataArray objectAtIndex:0];
                
                token = self.selectedDataObject.token;
                [[SingleTone sharedManager] setToken:token];
            }
        }
        [self createActivitiIndicatorAlertWithView];
        [apiManager postDataFromSeverWithMethod:@"visitor.signUp" andParams:params andToken:token complitionBlock:^(id response) {
            NSLog(@"RESP %@",response);
            if([[response objectForKey:@"response"] integerValue] == 1){
                [self deleteActivitiIndicator];
                [self pushControllerWithIdentifier:@"CountryController"];
               
            }else{
                [self deleteActivitiIndicator];
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                      [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                if(errorCode == 242){
                    [self showAlertWithMessage:@"Употребление табачных изделий разрешено лицам с 18 лет"];
                }
                if(errorCode == 243){
                    [self showAlertWithMessage:@"Длина пароля не менее 6 символов"];
                }
            }

        }];
    }
    

    
}

- (IBAction)actionButtonBirthday:(UIButton *)sender {
    [self showDataPickerBirthdayWithButton:sender];
}

- (void) keyboardWillShow: (NSNotification*) notification {
    
    [self animationMethodWithDictParams:[self paramsKeyboardWithNotification:notification]];
}

- (void) keyboardWillHide: (NSNotification*) notification {
    
    [self animationMethodWithDictParams:[self paramsKeyboardWithNotification:notification]];
}

#pragma mark - Other

- (NSDictionary*) paramsKeyboardWithNotification: (NSNotification*) notification {
    
    CGFloat animationDuration = [[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    NSValue* keyboardFrameBegin = [notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGFloat heightValue = keyboardFrameBeginRect.origin.y;
    
    NSDictionary * dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:animationDuration], @"animation",
                                 [NSNumber numberWithFloat:heightValue], @"height", nil];
    return dictParams;
}

- (void) animationMethodWithDictParams: (NSDictionary*) dict{
    
    [UIView animateWithDuration:[[dict objectForKey:@"animation"] floatValue] animations:^{
        CGRect newRect = self.buttonRegistration.frame;
        newRect.origin.y = [[dict objectForKey:@"height"] floatValue] - CGRectGetHeight(newRect);
        self.buttonRegistration.frame = newRect;
        CGRect newTableRect = self.tableView.frame;
        newTableRect.size.height = [[dict objectForKey:@"height"] floatValue] - CGRectGetHeight(newRect) - 64;
        self.tableView.frame = newTableRect;
    }];
}

@end
