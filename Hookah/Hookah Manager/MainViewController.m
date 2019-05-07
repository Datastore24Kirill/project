//
//  ViewController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import <NYAlertViewController/NYAlertViewController.h>
#import "UserInformationTable.h"
#import "SingleTone.h"

@interface MainViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UIActivityIndicatorView * activiti;



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"FILE URL %@", [[RLMRealm defaultRealm] configuration].fileURL);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Titl

- (void) setCustomTitle: (NSString*) title
{
    UILabel * CustomText = [[UILabel alloc]initWithTitle:title];
    self.navigationItem.titleView = CustomText;
}

#pragma mark - ToolBar

- (UIToolbar*) createToolBar {
    
    UIToolbar * toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.backgroundColor = [UIColor hx_colorWithHexRGBAString:HM_COLOR_BUTTON_PHONE_NEXT];
    
    return toolbar;
    
}

#pragma mark - NavController

- (void) pushControllerWithIdentifier: (NSString*) identifier {
    UIViewController * detai = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:detai animated:YES];
}

#pragma mark - Allerts

- (void) showAlertWithMessage: (NSString*) message {
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(@"", nil);
    alertViewController.message = NSLocalizedString(message, nil);
    
    alertViewController.buttonCornerRadius = 4.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:15.0f];
    alertViewController.messageColor = [UIColor whiteColor];
    alertViewController.buttonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                          size:alertViewController.buttonTitleFont.pointSize];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgrounImage.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithPatternImage:image];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor whiteColor];
    
    alertViewController.buttonColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void) showAlertWithMessageWithBlock: (NSString*) message block: (void (^)(void)) compilationBack {
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(@"", nil);
    alertViewController.message = NSLocalizedString(message, nil);
    
    alertViewController.buttonCornerRadius = 4.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:15.0f];
    alertViewController.messageColor = [UIColor whiteColor];
    alertViewController.buttonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                          size:alertViewController.buttonTitleFont.pointSize];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgrounImage.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithPatternImage:image];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor whiteColor];
    
    alertViewController.buttonColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              compilationBack();
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}


- (void) showDataPickerBirthdayWithButton: (UIButton*) button {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.title = NSLocalizedString(@"", nil);
    alertViewController.message = NSLocalizedString(@"\nВыберите вашу дату рождения", nil);
    alertViewController.buttonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                          size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                                size:alertViewController.buttonTitleFont.pointSize];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgrounImage.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithPatternImage:image];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor whiteColor];
    
    alertViewController.buttonColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    
    alertViewController.cancelButtonColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    alertViewController.cancelButtonTitleColor = [UIColor hx_colorWithHexRGBAString:@"9D9D9D"];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.timeZone = [NSTimeZone localTimeZone];
    datePicker.calendar = [NSCalendar currentCalendar];
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [datePicker setMaximumDate:[NSDate date]];
    
    if ([[SingleTone sharedManager] birthdayDate]) {
        [datePicker setDate:[[SingleTone sharedManager] birthdayDate] animated:YES];
    }else{
       datePicker.date = [self dateWithHundredYearsAgo:-25];
    }
    alertViewController.alertViewContentView = datePicker;
    
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Выбрать", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [[SingleTone sharedManager] setBirthdayDate:datePicker.date];
                                                              [button setTitle:[self refactDateString:datePicker.date]
                                                                      forState:UIControlStateNormal];
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void) showDataPickerBirthdayActionWithButton: (UIButton*) button withBlockAction: (void(^)(void)) blockAction {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.title = NSLocalizedString(@"", nil);
    alertViewController.message = NSLocalizedString(@"\nВыберите вашу дату рождения", nil);
    alertViewController.buttonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                          size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                                size:alertViewController.buttonTitleFont.pointSize];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgrounImage.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithPatternImage:image];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor whiteColor];
    
    alertViewController.buttonColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    
    alertViewController.cancelButtonColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    alertViewController.cancelButtonTitleColor = [UIColor hx_colorWithHexRGBAString:@"9D9D9D"];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.timeZone = [NSTimeZone localTimeZone];
    datePicker.calendar = [NSCalendar currentCalendar];
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
    [datePicker setMaximumDate:[NSDate date]];
    if([[SingleTone sharedManager] birthdayDate]){
        datePicker.date = [[SingleTone sharedManager] birthdayDate];
    }else{
        datePicker.date = [self dateWithHundredYearsAgo:-25];
    }
    
    if ([[SingleTone sharedManager] birthdayDate]) {
        [datePicker setDate:[[SingleTone sharedManager] birthdayDate] animated:YES];
    }else{
        datePicker.date = [self dateWithHundredYearsAgo:-25]; 
    }
    alertViewController.alertViewContentView = datePicker;
    
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Выбрать", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [[SingleTone sharedManager] setBirthdayDate:datePicker.date];
                                                              blockAction();
                                                              [button setTitle:[self refactDateString:datePicker.date]
                                                                      forState:UIControlStateNormal];
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}


- (void) showTextFildNameWithButton: (CustomButton*) button withBlockAction: (void(^)(void)) blockAction {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.title = NSLocalizedString(@"", nil);
    alertViewController.message = NSLocalizedString(@"\nВведите имя\n", nil);
    alertViewController.buttonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                          size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                                size:alertViewController.buttonTitleFont.pointSize];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"backgrounImage.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithPatternImage:image];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor whiteColor];
    
    alertViewController.buttonColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    
    alertViewController.cancelButtonColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    alertViewController.cancelButtonTitleColor = [UIColor hx_colorWithHexRGBAString:@"9D9D9D"];
    
    UITextField * textFild = [[UITextField alloc] init];
    textFild.textColor = [UIColor whiteColor];
    textFild.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:16];
    textFild.textAlignment = NSTextAlignmentCenter;
    textFild.autocorrectionType = UITextAutocorrectionTypeNo;
    textFild.spellCheckingType = UITextSpellCheckingTypeNo;
    textFild.text = button.titleLabel.text;
    textFild.delegate = self;
    
    
    alertViewController.alertViewContentView = textFild;
    
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Изменить", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              button.customName = textFild.text;
                                                              blockAction();
                                                              [button setTitle:textFild.text
                                                                      forState:UIControlStateNormal];
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void) showViewPickerWithButton: (CustomButton*) button andTitl: (NSString*) message andArrayData: (NSArray *) arrayData andKeyTitle:(NSString *) dictKeyTitle andKeyID:(NSString *) dictKeyID andDefValueIndex: (NSString *) defValueIndex {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.title = NSLocalizedString(@"", nil);
    alertViewController.message = NSLocalizedString(message, nil);
    alertViewController.buttonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                          size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR
                                                                size:alertViewController.buttonTitleFont.pointSize];
    
    
    alertViewController.alertViewBackgroundColor = [UIColor whiteColor];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor blackColor];
    
    alertViewController.buttonColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];

    alertViewController.cancelButtonColor = [UIColor hx_colorWithHexRGBAString:@"757575"];
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    alertViewController.cancelButtonTitleColor = [UIColor whiteColor];
    
    UIPickerView * pickerView = [[UIPickerView alloc] init];

    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    self.pickerDictKeyTitle = dictKeyTitle;
    self.pickerDictKeyID = dictKeyID;
    self.arrayPickerView = arrayData;
    NSString * defval;
    
    if(self.pickerDictKeyTitle.length !=0){
        if(defValueIndex.length !=0){
            //Поиск значения по умолчанию
            NSMutableArray * arrayIndex = [NSMutableArray new];
            
            for(int i=0; i<arrayData.count; i++){
                NSDictionary * dict = [self.arrayPickerView objectAtIndex:i];
                [arrayIndex addObject:[dict objectForKey:self.pickerDictKeyTitle]];
                
            }
            NSUInteger index = [arrayIndex indexOfObject:defValueIndex];
            //
            [pickerView selectRow:index inComponent:0 animated:YES];
            
            self.pickerViewString = defValueIndex;
            NSDictionary * pickerDict = [self.arrayPickerView objectAtIndex:index];
            self.pickerViewStringID = [pickerDict objectForKey:self.pickerDictKeyID];
        }else{
            NSDictionary * pickerDict = [self.arrayPickerView objectAtIndex:0];
            
            
            self.pickerViewString = [pickerDict objectForKey:self.pickerDictKeyTitle];
            self.pickerViewStringID = [pickerDict objectForKey:self.pickerDictKeyID];
        }
        
        
    }else{
        self.pickerViewString = [self.arrayPickerView objectAtIndex:[defval intValue]];
    }
    
    alertViewController.alertViewContentView = pickerView;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Выбрать", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              NSLog(@"BUTT %@ - %@",self.pickerViewString, self.pickerViewStringID);
                                                              [button setTitle:self.pickerViewString
                                                                      forState:UIControlStateNormal];
                                                              
                                                              button.customName = self.pickerViewString;
                                                              button.customIDWithDelegate = self.pickerViewStringID;
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}




#pragma mark - Gestures

- (void) hideAllTextFildWithMainView: (UIView*) view {
    
    UITapGestureRecognizer * gester = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(actionTapOnSelfView:)];
    [view addGestureRecognizer:gester];
    
}

#pragma mark - Actions

//Джестер на сворачивание клавиатуры
- (void) actionTapOnSelfView: (UITapGestureRecognizer*) tapGesture {
    
    for (UITextField * textFild in tapGesture.view.subviews) {
        [textFild resignFirstResponder];
    }
}

#pragma mark - Activiti

- (void) createActivitiIndicatorAlertWithView {
    
    self.activiti = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activiti.backgroundColor = [UIColor blackColor];
    self.activiti.backgroundColor = [self.activiti.backgroundColor colorWithAlphaComponent:0.5];
    CGRect frameForActiviti = CGRectZero;
    frameForActiviti.size = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.activiti.frame = frameForActiviti;
    self.activiti.color = [UIColor whiteColor];
    [self.navigationController.view.window addSubview:self.activiti];
    [self.activiti startAnimating];
    
}

- (void) deleteActivitiIndicator {
    [self.activiti stopAnimating];
    [self.activiti removeFromSuperview];
    self.activiti = nil;
    
}

#pragma mark - Other

- (NSString*) refactDateString: (NSDate*) date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *newDate = [dateFormatter stringFromDate:date];
    
    return newDate;
}

- (NSDate*) dateWithHundredYearsAgo: (NSInteger) ego {
    NSDate* currentDate = [self getLocalDate];
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    NSDate* now = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.timeZone=nowTimeZone;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:ego];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    
    NSLog(@"NOW: %@ DATE AGO %@",now, minDate);
    
    return minDate;
}


- (void)setCustomNavigationBackButton
{
    UIImage *backBtn = [UIImage imageNamed:@"backButtonImage"];
    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
}

-(NSDate *) getLocalDate {
    NSString* format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    // Set up an NSDateFormatter for UTC time zone
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Cast the input string to NSDate
    NSDate* utcDate = [NSDate date];
    
    // Set up an NSDateFormatter for the device's local time zone
    NSDateFormatter* formatterLocal = [[NSDateFormatter alloc] init];
    [formatterLocal setDateFormat:format];
    [formatterLocal setTimeZone:[NSTimeZone localTimeZone]];
    
    // Create local NSDate with time zone difference
    NSDate* localDate = [formatterUtc dateFromString:[formatterLocal stringFromDate:utcDate]];
    
    return localDate;
}

- (void) datePickerAction: (UIDatePicker*) dataPicker {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_POST_DATA" object:dataPicker];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.arrayPickerView.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component {
   
    if(self.pickerDictKeyTitle.length !=0){
        NSDictionary * pickerDict = [self.arrayPickerView objectAtIndex:row];
        
        return [pickerDict objectForKey:self.pickerDictKeyTitle];
    }else{
        return [self.arrayPickerView objectAtIndex:row];
    }
    
    
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if(self.pickerDictKeyTitle.length !=0){
        NSDictionary * pickerDict = [self.arrayPickerView objectAtIndex:row];
        
        self.pickerViewString = [pickerDict objectForKey:self.pickerDictKeyTitle];
        self.pickerViewStringID = [pickerDict objectForKey:self.pickerDictKeyID];
    }else{
        self.pickerViewString = [self.arrayPickerView objectAtIndex:row];
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

+(NSString *) checkStringToNull:(NSString *) string{
    if(string.length == 0){
        return @"";
    }else{
        return string;
    }
}

+(NSString *) checkIdToNull:(id) string{
    if(string == [NSNull null]){
        return @"";
    }else{
        return string;
    }
}



@end
