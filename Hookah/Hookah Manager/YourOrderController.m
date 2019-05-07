//
//  YourOrderController.m
//  Hookah Manager
//
//  Created by Viktor on 3/22/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "YourOrderController.h"
#import "YourOrderModel.h"
#import "HookahDetailsModel.h"
#import "OrderCell.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "DateTimeMethod.h"
#import "ChooseTableController.h"
#import "ChooseHookahController.h"
#import "ChooseTobaccoController.h"
#import "ChooseOtherController.h"
#import "SingleTone.h"

@interface YourOrderController () <UITableViewDataSource, UITableViewDelegate, YourOrderModelDelegate>

@property (strong, nonatomic) NSArray * arrayTypes;
@property (strong, nonatomic) NSArray * testArrayDescription;
@property (strong, nonatomic) YourOrderModel * youOrderModel;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;

@end

@implementation YourOrderController

- (void) loadView {
    [super loadView];
    
    NSLog(@"typeOrder %ld", self.typeOrder);
    
    
//    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
    

//    self.mainTableView.scrollEnabled = NO;
    CGRect tableRect = self.mainTableView.frame;
    tableRect.size.height = 51.f * 5.f;
    self.mainTableView.frame = tableRect;
    self.mainTableView.allowsSelection = NO;
    
    
    CGRect rectButtonOrder = self.buttonOrder.frame;
    rectButtonOrder.origin.y = CGRectGetMaxY(self.mainTableView.frame);
    self.buttonOrder.frame = rectButtonOrder;
    self.buttonChange.frame = CGRectMake(CGRectGetMinX(self.buttonChange.frame), CGRectGetMinY(self.buttonOrder.frame),
                                         CGRectGetWidth(self.buttonChange.frame), CGRectGetHeight(self.buttonChange.frame));
    self.buttonCancelOrder.frame = CGRectMake(CGRectGetMinX(self.buttonCancelOrder.frame), CGRectGetMinY(self.buttonOrder.frame),
                                         CGRectGetWidth(self.buttonCancelOrder.frame), CGRectGetHeight(self.buttonCancelOrder.frame));
    
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.buttonOrder.frame) + 49);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self deleteActivitiIndicator];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationController.navigationBarHidden = YES;
    self.arrayTypes = nil;
    self.testArrayDescription = nil;
    
    
    [self.tabBarController.tabBar setHidden:NO];
    
    self.currentLocalDate = [self getLocalDate];
    [self createActivitiIndicatorAlertWithView];
    
    
    self.youOrderModel = [[YourOrderModel alloc] init];
    self.youOrderModel.delegate = self;
    [self.youOrderModel setTestArrayDescription:self.isHistory andOrderID:self.orderID];
    self.arrayTypes = [self.youOrderModel setArrayType];
    
    NSString * outletID;
    if(!self.isHistory){
        if([self.outletID isEqual: [NSNull null]]){
            outletID = @"";
        }else{
            outletID = self.outletID;
        }
        
        [self.youOrderModel selectOutlets:outletID];
    }
    [self.youOrderModel loadCoastOrdertimeBlock:^{
        
        if (self.checkForDobblePush == NO) {
            if (self.typeOrder == 0) {
                self.mainTableView.allowsSelection = YES;
                self.buttonOrder.alpha = 1.f;
                self.buttonCancelOrder.alpha = 0;
                self.buttonChange.alpha = 0;
            } else if (self.typeOrder == 1) {
                self.buttonOrder.alpha = 0.f;
                self.buttonCancelOrder.alpha = 0;
                self.buttonChange.alpha = 0;
                self.buttonCancel.alpha = 0;
                self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.buttonOrder.frame));
            } else if (self.typeOrder == 4 || self.typeOrder == 5) {
                self.buttonOrder.alpha = 1.f;
                self.buttonCancelOrder.alpha = 0;
                self.buttonChange.alpha = 0;
                self.buttonCancel.alpha = 0;
                [self.buttonOrder setTitle:@"Повторить заказ" forState:UIControlStateNormal];
            } else if (self.typeOrder == 6) {
                
                self.buttonOrder.alpha = 0;
                self.buttonCancelOrder.alpha = 1;
                self.buttonChange.alpha = 1;
                self.buttonCancel.alpha = 0;
            } else if (self.typeOrder == 7) {
                self.buttonOrder.alpha = 1.f;
                self.buttonCancelOrder.alpha = 0;
                self.buttonChange.alpha = 0;
                self.buttonCancel.alpha = 0;
                [self.buttonOrder setTitle:@"Повторить заказ" forState:UIControlStateNormal];
                self.mainTableView.allowsSelection = YES;
            } else if (self.typeOrder == 8) {
                
                
                    self.buttonOrder.alpha = 1.f;
                    self.buttonCancelOrder.alpha = 0;
                    self.buttonChange.alpha = 0;
                    self.buttonCancel.alpha = 0;
                    self.mainTableView.allowsSelection = YES;
               
               
                
            }else if (self.typeOrder == 9) {
            
            
            self.buttonOrder.alpha = 1.f;
            self.buttonCancelOrder.alpha = 0;
            self.buttonChange.alpha = 0;
            self.buttonCancel.alpha = 0;
            self.mainTableView.allowsSelection = YES;
            
            }
            
        }
        
     
     
        self.buttonBack.userInteractionEnabled = YES;
    }];
    
    
    NSLog(@"TYPE %ld", self.typeOrder);
    
    
}

-(void) loadArrayDescription:(NSDictionary *) dict andHistory:(BOOL) isHistory{
    
    if(isHistory){
        NSMutableString * otherName = [NSMutableString string];
        NSMutableString * tabaccosFeatureName = [NSMutableString string];
        self.outletID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"outlet_id"]];
        [self.youOrderModel selectOutlets:[NSString stringWithFormat:@"%@",[dict objectForKey:@"outlet_id"]]];
        NSArray * others = [dict objectForKey:@"others"];
        for(int i = 0; i<others.count; i++){
            NSDictionary * dict = [others objectAtIndex:i];
            [otherName appendString:[NSString stringWithFormat:@"%@,",[dict objectForKey:@"name"]]];
        }
        
        NSArray * tobaccos = [dict objectForKey:@"tobaccos"];
        for(int k = 0; k<tobaccos.count; k++){
            NSDictionary * dict = [tobaccos objectAtIndex:k];
            [tabaccosFeatureName appendString:[NSString stringWithFormat:@"%@,",[dict objectForKey:@"feature_name"]]];
        }
        
        
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm"];
        
        NSDate * orderDateStart = [DateTimeMethod timestampToDate:[dict objectForKey:@"begin_at"]];
        NSString *orderDateStringStart = [dateFormatter stringFromDate:orderDateStart];
        
        
        
        NSArray * arrayDescription = [NSArray arrayWithObjects:
                                      [MainViewController checkStringToNull:[NSString stringWithFormat:@"%@",[dict objectForKey:@"table_name"]]],
                                      [MainViewController checkStringToNull:orderDateStringStart],
                                      [MainViewController checkStringToNull:[dict objectForKey:@"hookah_name"]],
                                      [MainViewController checkStringToNull:tabaccosFeatureName],
                                      [MainViewController checkStringToNull:otherName], nil];
        
        if(self.typeOrder == 6 || self.typeOrder == 4 || self.typeOrder == 5){
            
            //Собираем массив
             NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] init];
            NSDateFormatter * dateFormatterForDict = [[NSDateFormatter alloc] init];
            [dateFormatterForDict setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [dateFormatterForDict setDateFormat:@"HH:mm"];
            
            NSDate * orderDateStart = [DateTimeMethod timestampToDate:[dict objectForKey:@"begin_at"]];
            NSDate * orderDateEnd;
            NSString *orderDateStringEnd;
            if(![[dict objectForKey:@"end_at"] isEqual:[NSNull null]]){
                orderDateEnd = [DateTimeMethod timestampToDate:[dict objectForKey:@"end_at"]];
                 orderDateStringEnd = [dateFormatterForDict stringFromDate:orderDateEnd];
                [resultDict setObject:orderDateStringEnd forKey:@"end_at"];
            }else{
                orderDateStringEnd = @"";
            }
            
            NSString *orderDateStringStart = [dateFormatterForDict stringFromDate:orderDateStart];
           
            
            
           
            
            [resultDict setObject:[dict objectForKey:@"id"] forKey:@"id"];
            [resultDict setObject:orderDateStringStart forKey:@"begin_at"];
            
            [resultDict setObject:[dict objectForKey:@"hookah_id"] forKey:@"hookah_id"];
            [resultDict setObject:[dict objectForKey:@"hookah_name"] forKey:@"hookah_name"];
            [resultDict setObject:[dict objectForKey:@"maximum_number_of_features"] forKey:@"maximumNumberOfFeatures"];
            [resultDict setObject:[dict objectForKey:@"outlet_id"] forKey:@"outlet_id"];
            [resultDict setObject:[dict objectForKey:@"table_name"] forKey:@"table_name"];
            [resultDict setObject:[dict objectForKey:@"table_id"] forKey:@"table_id"];
            NSArray * others = [dict objectForKey:@"others"];
            
            for(int i=0; i<others.count; i++){
                NSDictionary * otherChooseDict = [others objectAtIndex:i];
                NSString * stringKey = [NSString stringWithFormat:@"others[%d]",i];
                NSString * stringKeyName = [NSString stringWithFormat:@"others_name[%d]",i];
                
                [resultDict setObject:[otherChooseDict objectForKey:@"id"] forKey:stringKey];
                [resultDict setObject:[otherChooseDict objectForKey:@"name"] forKey:stringKeyName];
            }
            
            NSArray * tobaccos = [dict objectForKey:@"tobaccos"];
            for(int k=0; k<tobaccos.count; k++){
                
                NSDictionary * tobaccosChooseDict = [tobaccos objectAtIndex:k];
                NSString * stringKey = [NSString stringWithFormat:@"tobaccos[%d][feature_id]",k];
                NSString * stringKeyName = [NSString stringWithFormat:@"tobaccos[%d][feature_id_name]",k];
                NSString * stringKeyTobacco = [NSString stringWithFormat:@"tobaccos[%d][id]",k];
                NSString * stringKeyTobaccoName = [NSString stringWithFormat:@"tobaccos[%d][id_name]",k];
                
                [resultDict setObject:[tobaccosChooseDict objectForKey:@"feature_id"] forKey:stringKey];
                [resultDict setObject:[tobaccosChooseDict objectForKey:@"feature_name"] forKey:stringKeyName];
                [resultDict setObject:[tobaccosChooseDict objectForKey:@"id"] forKey:stringKeyTobacco];
                [resultDict setObject:[tobaccosChooseDict objectForKey:@"name"] forKey:stringKeyTobaccoName];
                
                
            }
            
            NSLog(@"TABLEEEE %@",resultDict);
            [[SingleTone sharedManager] setDictOrder:resultDict];
            //
            
            
            [[SingleTone sharedManager] setStringFlavor:[MainViewController checkStringToNull:tabaccosFeatureName]];
            [[SingleTone sharedManager] setStringOther:[MainViewController checkStringToNull:otherName]];
        }
        
        self.testArrayDescription = arrayDescription;
    }else{
        
        
        NSLog(@"DDDDDDD %@",[[SingleTone sharedManager] dictOrder]);
        
        NSMutableString * otherName = [NSMutableString string];
        NSMutableString * tabaccosFeatureName = [NSMutableString string];
        
        for(NSString * key in dict){
            
            if([key rangeOfString:@"others_name"].location != NSNotFound) {
                [otherName appendString:[NSString stringWithFormat:@"%@,",[dict objectForKey:key]]];
            }
            
            if([key rangeOfString:@"feature_id_name"].location != NSNotFound ) {
                [tabaccosFeatureName appendString:[NSString stringWithFormat:@"%@,",[dict objectForKey:key]]];
            }
            
            
        }
        
        NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
        
        if((self.typeOrder == 7 || self.typeOrder == 8 || self.typeOrder == 9) && self.isChange){
            [resultDict removeObjectForKey:@"table_name"];
            [resultDict removeObjectForKey:@"table_id"];
            [resultDict removeObjectForKey:@"begin_at"];
            [resultDict removeObjectForKey:@"end_at"];
           [[SingleTone sharedManager] setDictOrder:resultDict];
            self.buttonOrder.userInteractionEnabled = NO;
            self.buttonOrder.alpha = 0.3f;
            [self.youOrderModel loadCoastOrdertimeBlock:^{
                
            }];
            self.isChange = NO;
            
        }
        
        
        
        NSArray * arrayDescription = [NSArray arrayWithObjects:
                                      [MainViewController checkStringToNull:[dict objectForKey:@"table_name"]], [MainViewController checkStringToNull:[dict objectForKey:@"begin_at"]], [MainViewController checkStringToNull:[dict objectForKey:@"hookah_name"]],
                                      [MainViewController checkStringToNull:tabaccosFeatureName],
                                      [MainViewController checkStringToNull:otherName], nil];
        
        [[SingleTone sharedManager] setStringFlavor:[MainViewController checkStringToNull:tabaccosFeatureName]];
        [[SingleTone sharedManager] setStringOther:[MainViewController checkStringToNull:otherName]];
        self.testArrayDescription = arrayDescription;
    }
    
    [self.mainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionButtonBookmarkOn:(id)sender {
    
    
     HookahDetailsModel * hookDetailsModel = [[HookahDetailsModel alloc] init];
    
    [hookDetailsModel setFavorites:NO andOutletID: self.outletID complitionBlock:^{
        [UIView animateWithDuration:0.3 animations:^{
            self.buttonBookmarkOn.alpha = 0;
            self.buttonBookmarkOff.alpha = 1;
        }];
    }];
     
    
    
    
}

- (IBAction)actionButtonBookmarkOff:(id)sender {
    
    
    HookahDetailsModel * hookDetailsModel = [[HookahDetailsModel alloc] init];
    
    [hookDetailsModel setFavorites:YES andOutletID: self.outletID complitionBlock:^{
        [UIView animateWithDuration:0.3 animations:^{
            self.buttonBookmarkOn.alpha = 1;
            self.buttonBookmarkOff.alpha = 0;
        }];
    }];
    
    
}

- (IBAction)actionButtonOrder:(id)sender {
    NSLog(@"Оформить");
    
    if (self.typeOrder == 0) {
        
        
        [self.youOrderModel createOrder:^(id response) {
            if([[response objectForKey:@"response"] integerValue] == 1){
                [self showAlertWithMessageWithBlock:@"Ваш заказ оформлен" block:^{
                    [[SingleTone sharedManager] setDictOrder:[@{} mutableCopy]];
                    [[SingleTone sharedManager] setStringFlavor:@""];
                    [[SingleTone sharedManager] setStringOther:@""];
                    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
            }else{
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                      [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                if(errorCode == 462){
                    [self showAlertWithMessage:@"Стол в указанное время занят"];
                }else if(errorCode == 463){
                    [self showAlertWithMessage:@"Время окончания заказа должно быть\nбольше времени начала заказа"];
                }
            }
        }];
    } else if (self.typeOrder == 7) {
        
        NSLog(@"ОФОРМЛЯЕМ ПОВТОРЕННЫЙ ЗАКАЗ");
        [self.youOrderModel createOrder:^(id response) {
            if([[response objectForKey:@"response"] integerValue] == 1){
                [self showAlertWithMessageWithBlock:@"Ваш заказ оформлен" block:^{
                    [[SingleTone sharedManager] setDictOrder:[@{} mutableCopy]];
                    [[SingleTone sharedManager] setStringFlavor:@""];
                    [[SingleTone sharedManager] setStringOther:@""];
                    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
            }else{
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                      [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                if(errorCode == 462){
                    [self showAlertWithMessage:@"Стол в указанное время занят"];
                }else if(errorCode == 463){
                    [self showAlertWithMessage:@"Время окончания заказа должно быть\nбольше времени начала заказа"];
                }
            }
        }];

        
        
    } else if (self.typeOrder == 8) {
        
        
        NSLog(@"ЗДЕСЬ НАДО СДНЛАТЬ МЕТОД ИЗМЕНЕНИЯ ЗАКАЗА");
        
        NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
        
        if (![resultDict objectForKey:@"table_name"]) {
            [self showAlertWithMessage:@"Выберите стол"];
            
            
        }else if(![resultDict objectForKey:@"begin_at"]) {
            [self showAlertWithMessage:@"Выберите время заказа"];
        }else{
            [self.youOrderModel updateOrder:self.orderID andBlock:^(id response) {
                if([[response objectForKey:@"response"] integerValue] == 1){
                    [self showAlertWithMessageWithBlock:@"Ваш заказ изменен" block:^{
                        [[SingleTone sharedManager] setDictOrder:[@{} mutableCopy]];
                        [[SingleTone sharedManager] setStringFlavor:@""];
                        [[SingleTone sharedManager] setStringOther:@""];
                        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                }else{
                    NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                          [response objectForKey:@"error_msg"]);
                    NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                    if(errorCode == 462){
                        [self showAlertWithMessage:@"Стол в указанное время занят"];
                    }else if(errorCode == 463){
                        [self showAlertWithMessage:@"Время окончания заказа должно быть\nбольше времени начала заказа"];
                    }
                }
            }];
        }

    } else if (self.typeOrder == 9) {
        NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
        NSLog(@"ОФОРМЛЯЕМ ПОВТОРЕННЫЙ ЗАКАЗ");
        if (![resultDict objectForKey:@"table_name"]) {
            [self showAlertWithMessage:@"Выберите стол"];
            
            
        }else if(![resultDict objectForKey:@"begin_at"]) {
            [self showAlertWithMessage:@"Выберите время заказа"];
        }else{
            [self.youOrderModel createOrder:^(id response) {
                if([[response objectForKey:@"response"] integerValue] == 1){
                    [self showAlertWithMessageWithBlock:@"Ваш заказ оформлен" block:^{
                        [[SingleTone sharedManager] setDictOrder:[@{} mutableCopy]];
                        [[SingleTone sharedManager] setStringFlavor:@""];
                        [[SingleTone sharedManager] setStringOther:@""];
                        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                }else{
                    NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                          [response objectForKey:@"error_msg"]);
                    NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                    if(errorCode == 462){
                        [self showAlertWithMessage:@"Стол в указанное время занят"];
                    }else if(errorCode == 463){
                        [self showAlertWithMessage:@"Время окончания заказа должно быть\nбольше времени начала заказа"];
                    }
                }
            }];
        }
        
    
       
        
    } else {
        
        NSLog(@"ПОВТОРИТЬ ЗАКАЗ");
        
        YourOrderController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"YourOrderController"];
        controller.typeOrder = 9;
        [self.buttonCancelOrder setAlpha:0.f];
        [self.buttonChange setAlpha:0.f];
        [self.buttonOrder setAlpha:1.f];
        controller.orderID = self.orderID;
        controller.outletID = self.outletID;
        controller.isHistory = NO;
        controller.isChange = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    

}

- (IBAction)actionButtonCancel:(id)sender {
    NSLog(@"Delete");
    [[SingleTone sharedManager] setDictOrder:[@{} mutableCopy]];
    [[SingleTone sharedManager] setStringFlavor:@""];
    [[SingleTone sharedManager] setStringOther:@""];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
}

- (IBAction)actionButtonChange:(id)sender {

    NSLog(@"ИЗМЕНИТЬ ЗАКАЗ");
    YourOrderController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"YourOrderController"];
    controller.typeOrder = 8;
    controller.orderID = self.orderID;
    controller.outletID = self.outletID;
    controller.isHistory = NO;
    [self.navigationController pushViewController:controller animated:YES];


}

- (IBAction)actionButtonCancelOrder:(id)sender {
    
    NSLog(@"ОТМЕНИТЬ ЗАКАЗ");
    [self.youOrderModel cancelOrder:self.orderID andBlock:^(id response) {
        if([[response objectForKey:@"response"] integerValue] == 1){
            [self showAlertWithMessageWithBlock:@"Ваш заказ отменен" block:^{
                [[SingleTone sharedManager] setDictOrder:[@{} mutableCopy]];
                [[SingleTone sharedManager] setStringFlavor:@""];
                [[SingleTone sharedManager] setStringOther:@""];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (IBAction)actionBackButton:(id)sender {
    
    NSLog(@"Hello");
    
    
    NSLog(@"%ld", self.typeOrder);
    
    if (self.typeOrder != 7 || self.typeOrder != 8) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSInteger countController = self.navigationController.viewControllers.count - 3;
        YourOrderController * controller = [self.navigationController.viewControllers objectAtIndex:countController];
        controller.typeOrder = 4;
        [self.navigationController popToViewController:controller animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.testArrayDescription.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"Cell";
    
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.labelType.text = [self.arrayTypes objectAtIndex:indexPath.row];
    cell.labelDescription.text = [self.testArrayDescription objectAtIndex:indexPath.row];
    
    NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];

    if ((self.typeOrder == 8 || self.typeOrder == 9) && indexPath.row == 0 && ![resultDict objectForKey:@"table_name"]) {
        cell.labelDescription.text = @"Выберите стол";
        
    } else if ((self.typeOrder == 8 || self.typeOrder == 9) && indexPath.row == 1 && ![resultDict objectForKey:@"begin_at"]) {
        cell.labelDescription.text = @"Выберите время заказа";
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //Проверка ячейки----------------------
    if (indexPath.row == 0) {
        ChooseTableController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTableController"];
        controller.orderID = self.orderID;
        if (self.typeOrder == 7 || self.typeOrder == 8 || self.typeOrder == 9) {
            controller.changeTypeTime = YES;
        }
        controller.typeControllerForOrder = YES;
        controller.outletID = @"1";
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 1) {
        ChooseTableController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTableController"];
        controller.changeTypeTime = YES;
        controller.typeControllerTime = YES;
        controller.outletID = self.outletID;
        controller.orderID = self.orderID;
        controller.typeControllerForOrder = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 2) {
        ChooseHookahController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseHookahController"];
        detail.outletID = self.outletID;
        detail.isBool = YES;
        [self.navigationController pushViewController:detail animated:YES];
    } else if (indexPath.row == 3) {
        ChooseTobaccoController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTobaccoController"];
        detail.outletID = self.outletID;
        detail.isBool = YES;
        detail.hookahID = [[[SingleTone sharedManager] dictOrder] objectForKey:@"hookah_id"];
        detail.maximumNumberOfFeatures = [[[SingleTone sharedManager] dictOrder] objectForKey:@"maximumNumberOfFeatures"];;
        [self.navigationController pushViewController:detail animated:YES];
    } else if (indexPath.row == 4) {
        ChooseOtherController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseOtherController"];
        detail.outletID = self.outletID;
        detail.isBool = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}


#pragma mark - YouOrderModelDelegate

-(void) loadDefault:(NSString *) address open:(NSString *) open close: (NSString *) close
         isFavorite:(NSString*) isFavorite andLogoURL: (NSString*) logoURL andRating:(NSString*) rating{
    NSURL *imgURL = [NSURL URLWithString:logoURL];
    
    if([isFavorite integerValue]==0){
        self.buttonBookmarkOff.alpha = 1.f;
        self.buttonBookmarkOn.alpha = 0.f;
        
    }else{
        self.buttonBookmarkOff.alpha = 0.f;
        self.buttonBookmarkOn.alpha = 1.f;
        
    }
    
    //SingleTone с ресайз изображения
    
    NSLog(@"AD %@ open %@ close %@  isFav %@",address,open,close,isFavorite);
    
    //Кастомное числовое число для колличества звезд
    NSInteger starCountInteger = [self.starCount integerValue];
    NSLog(@"starCountInteger %ld image %@",starCountInteger,self.imageStars);
    for (int j = 0; j < 5; j++) {
        UIImageView * imageStarView = [self.imageStars objectAtIndex:j];
        if (starCountInteger > j) {
            imageStarView.image = [UIImage imageNamed:@"rateStarImageOn"];
        } else {
            imageStarView.image = [UIImage imageNamed:@"rateStarImageOff"];
        }
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imgURL
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if(image){
                                [self.mainImage setClipsToBounds:YES];
                                
                                //self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
                                self.mainImage.clipsToBounds =YES;
                                self.mainImage.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |
                                                                   UIViewAutoresizingFlexibleLeftMargin |
                                                                   UIViewAutoresizingFlexibleRightMargin |
                                                                   UIViewAutoresizingFlexibleHeight
                                                                   );
                                self.mainImage.image = image;
                                self.labelAddress.text = address;
                              
                                
                                
                                self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",open,close];
                                [self deleteActivitiIndicator];
                                
                                
                            }else{
                                //Тут обработка ошибки загрузки изображения
                            }
                        }];
    
    
    [self.mainTableView reloadData];
    
}

-(void) setTotalCoast: (NSString *) totalCoast{
    NSString * coast;
    if([totalCoast isEqual:[NSNull null]]){
        coast = @"%@";
        
    }else{
        coast = totalCoast;
        self.buttonOrder.userInteractionEnabled = YES;
        self.buttonOrder.alpha = 1.f;
    }
    NSString * totalCount = [NSString stringWithFormat:@"Оформить заказ (%@ Р)",totalCoast];
    [self.buttonOrder setTitle:totalCount forState:UIControlStateNormal];
}

-(void)deleteActiviti{
    [self deleteActivitiIndicator];
}






@end
