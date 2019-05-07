//
//  ChooseTableController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 2/1/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"
#import "ChooseTableModel.h"
#import "CustomButton.h"
#import "ViewForPickers.h"



@interface ChooseTableController : MainViewController

@property (assign, nonatomic) BOOL isMap;      //Буль для перехода с карты

@property (assign, nonatomic) BOOL typeControllerForOrder;  //Буль для выбора столика
@property (assign, nonatomic) BOOL typeControllerTime;      //Буль для выбора времени

@property (assign, nonatomic) BOOL changeTypeTime; //Дополнительный буль параметр при овторении заказа
@property (assign, nonatomic) BOOL typeChangeTime; //Дополнительный буль параметр при ищменении заказа

@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSString * orderID;



@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UIView * whiteView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *tableFoneView;
@property (strong, nonatomic) NSMutableArray * tableArray;
@property (strong, nonatomic) NSString * chooseRoomID;
@property (strong, nonatomic) NSString * chooseRoomName;

@property (weak, nonatomic) IBOutlet UIButton *buttobBack;


@property (weak, nonatomic) IBOutlet CustomButton *buttonChooseTable;
@property (weak, nonatomic) IBOutlet CustomButton *buttonNotMatter;
@property (weak, nonatomic) IBOutlet UIView *darkViewForButtonNext;
@property (weak, nonatomic) IBOutlet CustomButton *buttonNext;

//Для выборки конца визита
@property (strong, nonatomic) ChooseTableModel * chooseOneTable;
@property (strong, nonatomic) ChooseTableModel * chooseManyTable;
@property (strong, nonatomic) NSString * chooseTime;

@property (strong, nonatomic) NSString * chooseTimeStart;
@property (strong, nonatomic) NSString * chooseTimeEnd;

//TimePicker---------------------------------
@property (weak, nonatomic) IBOutlet ViewForPickers *mainTimePickerView;

@property (assign, nonatomic) NSInteger typeView; //Тип главного окна


- (IBAction)actionButtonBack:(id)sender;
- (IBAction)actionChooseTableButton:(CustomButton *)sender;
- (IBAction)actionButtonNotMatter:(CustomButton *)sender;
- (IBAction)actionButtonNext:(CustomButton *)sender;

@end
