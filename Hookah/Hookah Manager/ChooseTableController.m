//
//  ChooseTableController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 2/1/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseTableController.h"
#import "ChooseHookahController.h"
#import "CustomButton.h"
#import "Macros.h"
#import "SingleTone.h"
#import "YourOrderController.h"

@interface ChooseTableController () <ChooseTableModelDelegate, UIGestureRecognizerDelegate, CustomButtonDelegate,ViewForPickersDelegate>

@property (strong, nonatomic) NSArray * arrayData;
@property (assign, nonatomic) CGFloat constant;
@property (assign, nonatomic) CGFloat testViewScale;
@property (assign, nonatomic) CGPoint touchOffcet;
@property (assign, nonatomic) CGSize baseSizeTestView;
@property (assign, nonatomic) CGPoint baseCenter;
@property (assign, nonatomic) CGFloat startWidth;
@property (strong, nonatomic) NSString * selectedTable;
@property (strong, nonatomic) NSString * selectedTableName;
@property (weak, nonatomic) IBOutlet UILabel *customNavigationLabel;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (strong, nonatomic) CustomButton * customSender;

@property (strong, nonatomic) NSMutableArray * buttonsArray;
@property (weak, nonatomic) IBOutlet UILabel *labelRoomName;

@property (strong, nonatomic) NSArray * arrayForTimeFirst; //Сохранения первоночального массива

//Колличество столов
@property (strong, nonatomic) NSArray * countTables;

//Timer---------------------------------------------------------
@property (strong, nonatomic) NSArray * timeArray;

//Булевый параметр для сохранения выбора одного стола или выбор стола не важен
@property (assign, nonatomic) BOOL isTable;



@end

@implementation ChooseTableController

- (void) loadView {
    [super loadView];
    
    self.testView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    self.whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.testView.alpha = 0.f;
    self.whiteView.alpha = 0.f;
    self.tableFoneView.backgroundColor = [UIColor clearColor];
    
    self.buttonNext.type = 0;
    self.buttonNotMatter.type = 0;
   
    UIPinchGestureRecognizer * pinchGesture =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handlePinch:)];

    [self.baseView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer * panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self.baseView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer * doubleTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 1;
    doubleTapGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    [self.buttonNotMatter setClipsToBounds:YES];
    
    
    
    UIView *leftBorder = [[UIView alloc] initWithFrame:CGRectMake(self.buttonNotMatter.frame.size.width-2, 1, 2,
                                                                  self.buttonNotMatter.frame.size.height-3)];
    leftBorder.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"99999a"];
    
    [self.buttonNotMatter addSubview:leftBorder];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ChooseTableModel * choseTableModel = [[ChooseTableModel alloc] init];
    choseTableModel.delegate = self;
    self.startWidth = self.testView.frame.size.width;
    
    self.buttonChooseTable.delegate = self;
    [choseTableModel getArray:self.outletID];
    
    self.mainTimePickerView.delegate = self;
    
    self.buttonsArray = [NSMutableArray array];
    
    self.isTable = NO;
    
    self.darkView.alpha = 0.f;
    self.typeView = 0;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.customNavigationLabel.alpha=1.f;
    
    self.navigationController.navigationBarHidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.toolbar setHidden: NO];
    self.buttonNotMatter.userInteractionEnabled = NO;
    self.tableArray = [NSMutableArray new];
    
    
    NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
    
    if([resultDict objectForKey:@"table_id"]){
        self.selectedTable = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"table_id"]];
        
    }
    
    if([resultDict objectForKey:@"table_name"]){
        self.selectedTableName = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"table_name"]];
    }
    
    if([resultDict objectForKey:@"roomID"]){
        self.chooseRoomID = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"roomID"]];
    }else{
        self.chooseRoomID = @"";
    }
    
    if([resultDict objectForKey:@"roomName"]){
        self.chooseRoomName = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"roomName"]];
    }else{
        self.chooseRoomName = @"";
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChooseTableModelDelegate

-(void) loadTable:(NSArray *) arrayRespone endCountTables:(NSArray *)countTables{
    [self createActivitiIndicatorAlertWithView];
    self.arrayData = arrayRespone;
    self.countTables = countTables;
    
    if(self.arrayData.count >0){
        if(self.chooseRoomID.length == 0){
            NSDictionary * dict = [self.arrayData objectAtIndex:0];
            CGFloat height = [[dict objectForKey:@"width"] floatValue];
            CGFloat width = [[dict objectForKey:@"length"] floatValue];
            self.labelRoomName.text = [dict objectForKey:@"name"];
            
            [self changeViewWithHeight:height andWidth:width andArrayTable:[dict objectForKey:@"tables"]];
        }else{
            [self loadTableWithCustomID:self.chooseRoomID andCustomName:self.chooseRoomName];
        }
        
    }else{
        [self deleteActivitiIndicator];
        [self showAlertWithMessageWithBlock:@"Столы не обнаружены" block:^{
            self.hidesBottomBarWhenPushed = NO;
            [self.navigationController popViewControllerAnimated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
          
        }];
    }
    
    
}

-(void) loadTableWithCustomID:(NSString *) customID andCustomName: (NSString *) customName{

    NSUInteger indexOfArray = [self.arrayData indexOfObjectPassingTest:^BOOL(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        BOOL found = [[item objectForKey:@"id"] intValue] == [customID intValue];
        return found;
    }];
    
    if (indexOfArray != NSNotFound) {
        // First matching item at index2.
        for (UIView * view in self.tableFoneView.subviews){
            [view removeFromSuperview];
        }
        self.constant = 1;
        self.baseSizeTestView = CGSizeZero;
        self.labelRoomName.text = customName;
        
        
        
        NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
        [resultDict setObject:customID forKey:@"roomID"];
        [resultDict setObject:customName forKey:@"roomName"];
        [[SingleTone sharedManager] setDictOrder:resultDict];
        
        
            NSDictionary * dict = [self.arrayData objectAtIndex:indexOfArray];
            CGFloat height = [[dict objectForKey:@"width"] floatValue];
            CGFloat width = [[dict objectForKey:@"length"] floatValue];
        
            [self changeViewWithHeight:height andWidth:width andArrayTable:[dict objectForKey:@"tables"]];
        
    } else {
        
        // No matching item found.
    }
}

#pragma mark - Other

- (void) changeViewWithHeight: (CGFloat) height andWidth: (CGFloat) width andArrayTable: (NSArray*) arrayTable {
    
    CGFloat baseWith = self.startWidth;
    
    CGFloat changeFloat;
    CGFloat mainFloat;
    if (height > width) {
        changeFloat = height;
    } else {
        changeFloat = width;
    }
    mainFloat = changeFloat;
    changeFloat -= baseWith;
    changeFloat = changeFloat / mainFloat;
    self.constant = 1.f - changeFloat;
    CGRect rect = self.testView.frame;
    rect.size.width =  height * self.constant;
    rect.size.height = width * self.constant;
    
    self.testView.frame = rect;
    self.testView.center = CGPointMake(CGRectGetMidX(self.baseView.bounds), CGRectGetMidY(self.baseView.bounds));

    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, CGRectMake(self.whiteView.frame.origin.x + 1, self.whiteView.frame.origin.y + 1,
                                        self.whiteView.frame.size.width - 2, self.whiteView.frame.size.height - 2));
    
    CGPathAddRect(path, nil, CGRectMake(0, 0, self.testView.frame.size.width, self.testView.frame.size.height));
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.path = path;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.testView.layer.mask = maskLayer;
    self.testView.clipsToBounds = YES;
    self.testView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    self.testView.layer.borderWidth = 1.f;
    self.testView.layer.cornerRadius = 3.f;

    self.testView.alpha = 1.f;
    self.whiteView.alpha = 1.f;
    self.tableFoneView.frame = self.testView.frame;
    
    //Tables------------------------------------------------
    for (int i = 0; i < arrayTable.count; i++) {
        NSDictionary * dictTable = [arrayTable objectAtIndex:i];
        
        BOOL isChoose;
        if([self.selectedTable isEqualToString:[NSString stringWithFormat:@"%@",[dictTable objectForKey:@"id"]]]){
            isChoose = YES;
        }else{
            isChoose = NO;
        }
        [self addTableWithType:[[dictTable objectForKey:@"kind"] integerValue]
                       offcetX:[[dictTable objectForKey:@"position_x"] floatValue]
                       offcetY:[[dictTable objectForKey:@"position_y"] floatValue]
                        height:[[dictTable objectForKey:@"width"] floatValue]
                         width:[[dictTable objectForKey:@"length"] floatValue]
                        rotate:[dictTable objectForKey:@"position_angle"]
                       andName:[dictTable objectForKey:@"name"]
                        number:[dictTable objectForKey:@"number"]
                    andTableId:[dictTable objectForKey:@"id"]
         andChoose:isChoose];
        
    }

    self.baseSizeTestView = self.testView.frame.size;
    self.baseCenter = self.baseView.center;
    [self deleteActivitiIndicator];
    self.buttonNotMatter.userInteractionEnabled = YES;
    
    //Отрисовка --------------------------
    

    
    if (self.typeControllerTime) {
        
        //ЕСЛИ ПЕРЕВОДИМ ИЗ ЗАКАЗА НА ВРЕМЯ УВЕЛИЧИВАЕМ СЧЕТЧИК ТИПА НОПКИ НА 1
        //И СОЗДАЕМ АНИМАЦИЮ ОТКРЫТИЯ ВРЕМЕНИ
        
        self.typeView += 1;
        
        NSDictionary * dict = [[SingleTone sharedManager] dictOrder];
        NSString * tableID = [dict objectForKey:@"table_id"];
        
        [self createTimePickerWithTableId:tableID andSender:nil andImage:nil];
        [self animatiomForType:self.typeView];
    }
    if (self.typeControllerForOrder) {
        NSString * tableID = [[[SingleTone sharedManager] dictOrder] objectForKey:@"table_id"];
        
        for (CustomButton * button in self.buttonsArray) {
            NSString * tableIDTemp = button.customID;
            if ([tableID integerValue] == [tableIDTemp integerValue]) {
                NSString * stringImage;
                if (button.type == 1) {
                    stringImage = @"tableOvalOn";
                } else {
                    stringImage = @"tableSquareOn";
                }
                button.isBool = YES;
                [self animationNextButton:button andStringImage:stringImage];
                self.darkViewForButtonNext.alpha = 0.f;
                
                break;
            }
        }
    }
}

- (void) addTableWithType: (NSInteger) type offcetX: (CGFloat) X offcetY: (CGFloat) Y
                   height: (CGFloat) height width: (CGFloat) with rotate: (NSString*) rotate andName: (NSString*) name number: (NSString*) number andTableId: (NSString*) tableID andChoose: (BOOL) isCoohse{
    
    
    CustomButton * buttonTable = [CustomButton buttonWithType:UIButtonTypeCustom];
    buttonTable.frame = CGRectMake(X * self.constant, Y * self.constant, height * self.constant, with * self.constant);
    buttonTable.center = CGPointMake(X * self.constant, Y * self.constant);
    
    NSString * nameImage;
    if (type == 1) {
       nameImage = @"tableOval";
        
    } else {
        nameImage = @"tableSquare";
    }

    [buttonTable setImage:[UIImage imageNamed:nameImage] forState:UIControlStateNormal];
    buttonTable.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    buttonTable.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    buttonTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    buttonTable.type = type;
    buttonTable.isBool = NO;
    buttonTable.customID = tableID;
    buttonTable.customName = name;
    NSDictionary * dictTable = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@",tableID],@"tableID",
                                [NSString stringWithFormat:@"%@",name],@"tableName",nil];
    [self.tableArray addObject:dictTable];
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, [self degreesToRadians:rotate]);
    buttonTable.transform = transform;
    [buttonTable addTarget:self action:@selector(actionButtonTable:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableFoneView addSubview:buttonTable];
    [self.buttonsArray addObject:buttonTable];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(buttonTable.layer.frame) - 70,
                                                                CGRectGetMinY(buttonTable.layer.frame) - 20, 140, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"979797"];
    label.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:14];
    label.text = name;
    [self.tableFoneView addSubview:label];
    if(isCoohse){
        [self actionButtonTable:buttonTable];
    }
    
}

- (double) degreesToRadians: (NSString*) stringDegrees {
    double degrees = [stringDegrees doubleValue];
    double radians = degrees * M_PI / 180;
    return radians;
}

#pragma mark - Actions

- (void) actionButtonTable: (CustomButton*) sender {
    [self.mainTimePickerView deletePickers];
    NSString * image;
    if (![self.customSender isEqual:sender]) {
        if (self.customSender.type == 2) {
            image = @"tableSquare";
        } else {
            image = @"tableOval";
        }
        
        [self.customSender setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        
        
        self.customSender.isBool = NO;
        
    }
    
   
    
    
    
    NSString * stringImage;
    if (!sender.isBool) {
//        for (CustomButton * button in self.buttonsArray) {
//            NSString * image;
//            if (![button isEqual:sender]) {
//                if (button.type == 2) {
//                    image = @"tableSquare";
//                } else {
//                    image = @"tableOval";
//                }
//                
//                    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//                    
//
//                button.isBool = NO;
//            }
//        }
        if (sender.type == 1) {
            stringImage = @"tableOvalOn";
        } else {
            stringImage = @"tableSquareOn";
        }
        sender.isBool = YES;
        self.selectedTable = [NSString stringWithFormat:@"%@",sender.customID];
        self.selectedTableName = [NSString stringWithFormat:@"%@",sender.customName];
        
       
        
        NSString * tableID;
        
        if(self.selectedTable.length == 0){
            tableID = @"1";
        }else{
            tableID = self.selectedTable;
        }
      
        
        [self createTimePickerWithTableId:tableID andSender:sender andImage:stringImage];
        
        if (sender != nil) {
            [self animationNextButton:sender andStringImage:stringImage];
        } else {
            [self animatiomForType:1];
        }
       
        
    } else {
        if (sender.type == 2) {
            stringImage = @"tableSquare";
        } else {
            stringImage = @"tableOval";
        }
        sender.isBool = NO;
        [self animationNextButton:sender andStringImage:stringImage];
    }
     self.customSender = sender;
    
}

- (void) createTimePickerWithTableId: (NSString*) tableID
                           andSender: (CustomButton*) sender
                            andImage: (NSString*) stringImage {
   
    self.chooseOneTable = [[ChooseTableModel alloc] init];
    
    [self.chooseOneTable getArrayCloseTimeForServer:self.outletID andTableID:tableID orderID:self.orderID ccomplitionBlock:^(NSArray *response) {
        self.timeArray = response;
        self.arrayForTimeFirst = response;
       
        if(self.timeArray.count>0){
            [self.mainTimePickerView deletePickers];
            [self.mainTimePickerView createPickersWithData:self.timeArray andNext:NO count:0];
            
        }else{
            
       
            if(self.changeTypeTime && self.typeControllerTime && self.typeControllerForOrder){
                [self showAlertWithMessageWithBlock:@"Стол занят,\nсначала изменить стол" block:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [self showAlertWithMessage:@"Стол занят,\nвыберите другой"];
            }
            self.darkViewForButtonNext.alpha = 0.4f;
            
        }
        
        
    }];
    
}

-(void) animationNextButton:(CustomButton*) sender andStringImage:(NSString *) stringImage{
    [UIView animateWithDuration:0.3 animations:^{
        [sender setImage:[UIImage imageNamed:stringImage] forState:UIControlStateNormal];
    }];
    
    
    if (sender.isBool == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            self.darkViewForButtonNext.alpha = 0.f;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.darkViewForButtonNext.alpha = 0.4f;
        }];
    }
}

- (IBAction)actionButtonBack:(id)sender {
    
    
    if (self.typeView == 0) {
        [self.navigationController popViewControllerAnimated:NO];
    } else if (self.typeView == 1) {
        if (self.typeControllerTime) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.typeView -= 1;
            if ([self checkOnTable]) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.darkViewForButtonNext.alpha = 0.f;
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.darkViewForButtonNext.alpha = 0.4f;
                }];
            }
            [self animatiomForType:self.typeView];
        }
    } else if (self.typeView == 2) {
        self.typeView -= 1;
        [self animationApDatePickeViewWithBlock:^{
            self.customNavigationLabel.text = @"Выберите время визита";
            [self.mainTimePickerView deletePickers];
            [self.mainTimePickerView createPickersWithData:self.arrayForTimeFirst andNext:NO count:0];
        } endDicrction:NO];
    }
}

- (IBAction)actionChooseTableButton:(CustomButton *)sender {

    [self showViewPickerWithButton:sender andTitl:@"Выберите зал" andArrayData:self.arrayData andKeyTitle:@"name" andKeyID:@"id" andDefValueIndex: sender.customName];
}

- (IBAction)actionButtonNotMatter:(CustomButton *)sender {
    
//    if (!self.typeControllerForOrder) {
        if (self.typeView == 0) {
            [self.mainTimePickerView deletePickers];
            
            self.chooseManyTable = [[ChooseTableModel alloc] init];
            NSMutableArray * mCounttables = [NSMutableArray arrayWithArray:self.countTables];
            self.chooseManyTable.allExistTables = mCounttables;
            [self createActivitiIndicatorAlertWithView];
            [self.chooseManyTable getArrayCloseTimeForServer:self.outletID orderID:self.orderID ccomplitionBlock:^(NSArray *response) {
                [self deleteActivitiIndicator];
                
                self.timeArray = response;
                self.arrayForTimeFirst = response;
                [self.mainTimePickerView deletePickers];
                
                [self.mainTimePickerView createPickersWithData:self.timeArray andNext:NO count:0];
                
                self.typeView += 1;
                self.isTable = NO;
                
                self.darkViewForButtonNext.alpha = 0.f;
                [self animatiomForType:self.typeView];
            }];

        } else {
            if (!self.typeControllerForOrder) {
                
                
                NSIndexSet *indices = [self.tableArray indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                    return [[NSString stringWithFormat:@"%@", [obj objectForKey:@"tableID"]] isEqualToString:[NSString stringWithFormat:@"%@",self.selectedTable]];
                }];
                
                
                NSArray *filtered = [self.tableArray objectsAtIndexes:indices];
                
                
                NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
                [resultDict setObject:self.chooseTimeStart forKey:@"begin_at"];
                [resultDict setObject:self.outletID forKey:@"outlet_id"];
                [resultDict setObject: self.selectedTable forKey:@"table_id"];
                
                if(filtered.count>0){
                    NSDictionary *item = [filtered objectAtIndex:0];
                    [resultDict setObject:[item objectForKey:@"tableName"] forKey:@"table_name"];
                }
                
                
                
                [[SingleTone sharedManager] setDictOrder:resultDict];
                self.customNavigationLabel.alpha=0.f;
                self.hidesBottomBarWhenPushed = YES;
                ChooseHookahController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseHookahController"];
                detail.outletID = self.outletID;
                [self.navigationController pushViewController:detail animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            } else {
                
                
                //ВЫБОР КОНЦА НЕ ВАЖНО ПРИ ИЗМЕНЕНИИ ЗАКАЗА
                
                NSIndexSet *indices = [self.tableArray indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                    return [[NSString stringWithFormat:@"%@", [obj objectForKey:@"tableID"]] isEqualToString:[NSString stringWithFormat:@"%@",self.selectedTable]];
                }];
                
                
                NSArray *filtered = [self.tableArray objectsAtIndexes:indices];
                
                
                NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
                [resultDict setObject:self.chooseTimeStart forKey:@"begin_at"];
                [resultDict setObject:@"" forKey:@"end_at"];
                [resultDict setObject:self.outletID forKey:@"outlet_id"];
                [resultDict setObject: self.selectedTable forKey:@"table_id"];
                
                if(filtered.count>0){
                    NSDictionary *item = [filtered objectAtIndex:0];
                    [resultDict setObject:[item objectForKey:@"tableName"] forKey:@"table_name"];
                }
                
                
                
                [[SingleTone sharedManager] setDictOrder:resultDict];
                
                NSInteger counter = self.navigationController.viewControllers.count - 2;
                YourOrderController * controller = [self.navigationController.viewControllers objectAtIndex:counter];
                [self.navigationController popToViewController:controller animated:YES];
                
                
                
                
            }
        }
}

- (IBAction)actionButtonNext:(CustomButton *)sender {
    
    if (!self.typeControllerForOrder || self.typeControllerTime || self.changeTypeTime) {
        if (self.typeView == 0) {
            self.typeView += 1;
            self.isTable = YES;
            
            [self animatiomForType:self.typeView];

        } else if (self.typeView == 1) {
            self.typeView += 1;
            if(self.chooseTime.length == 0){
                [self showAlertWithMessage:@"Выберите время"];
            }else{
                self.chooseTimeStart = self.chooseTime;
                NSArray * arrayForDataPicker;
                if (!self.typeControllerTime || self.changeTypeTime) {
                    [[SingleTone sharedManager] setArrayTime:self.chooseOneTable];
                } else {
                    //ЕСЛИ ВРЕМЯ ТО ДОСТАЕМ ИЗ СИНГЛТОНА АХРИХ СТАРТОВОГО ВРЕМЕНИ И ПЕРЕХОДИМ В КОНЕЧНОЕ ВРЕМЯ
                    self.chooseOneTable = [[SingleTone sharedManager] arrayTime];
                }
                
                if (self.isTable || self.typeControllerTime) {
                    arrayForDataPicker = [self.chooseOneTable getFinishTime:self.chooseTime andTableID:nil andOutletID:self.outletID];
                    
              
                    
                    
                } else {
                    
                    
                    
                    NSDictionary * needTableDict = [self.chooseManyTable chooseTableForTime:self.chooseTime];
                    arrayForDataPicker = [self.chooseManyTable getFinishTime:self.chooseTime andTableID:[needTableDict objectForKey:@"table_id"] andOutletID:self.outletID];
                    
                    
                    
                    self.selectedTable = [needTableDict objectForKey:@"table_id"];
                }
                [self.mainTimePickerView deletePickers];
                
                [self animationApDatePickeViewWithBlock:^{
                    self.customNavigationLabel.text = @"Выберите время ухода";
                    [self.mainTimePickerView deletePickers];
                    [self.mainTimePickerView createPickersWithData:arrayForDataPicker
                                                           andNext:YES count:arrayForDataPicker.count];
                    
                    if(arrayForDataPicker.count>1){
                        
                        
                        [self.mainTimePickerView.pickerHours selectRow:1 inComponent:0 animated:YES];
                        [self.mainTimePickerView.pickerHours reloadComponent:1];
                        
                    }
                    
                } endDicrction:YES];
            }
        } else if (self.typeView == 2) {
            if (!self.typeControllerTime && !self.changeTypeTime) {
                
                self.chooseTimeEnd = self.chooseTime;
                
                
                
                NSIndexSet *indices = [self.tableArray indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                    return [[NSString stringWithFormat:@"%@", [obj objectForKey:@"tableID"]] isEqualToString:[NSString stringWithFormat:@"%@",self.selectedTable]];
                }];
                
                
                
                NSArray *filtered = [self.tableArray objectsAtIndexes:indices];
                
                
                
                
                NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
                [resultDict setObject:self.chooseTimeStart forKey:@"begin_at"];
                [resultDict setObject:self.chooseTimeEnd forKey:@"end_at"];
                [resultDict setObject:self.outletID forKey:@"outlet_id"];
                [resultDict setObject: self.selectedTable forKey:@"table_id"];
                
                if(filtered.count>0){
                    NSDictionary *item = [filtered objectAtIndex:0];
                    [resultDict setObject:[item objectForKey:@"tableName"] forKey:@"table_name"];
                }

                
                [[SingleTone sharedManager] setDictOrder:resultDict];
                self.customNavigationLabel.alpha=0.f;
                self.hidesBottomBarWhenPushed = YES;
                ChooseHookahController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseHookahController"];
                detail.outletID = self.outletID;
                [self.navigationController pushViewController:detail animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                
                
            } else {
                if (self.isTable) {
                   
                    self.chooseTimeEnd = self.chooseTime;
                    NSUInteger countType = self.navigationController.viewControllers.count - 2;
                    YourOrderController * controller = [self.navigationController.viewControllers objectAtIndex:countType];
                    NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
                    
                    if(self.selectedTable){
                        NSIndexSet *indices = [self.tableArray indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                            return [[NSString stringWithFormat:@"%@", [obj objectForKey:@"tableID"]] isEqualToString:[NSString stringWithFormat:@"%@",self.selectedTable]];
                        }];
                        NSArray *filtered = [self.tableArray objectsAtIndexes:indices];
                        if(filtered.count>0){
                            NSDictionary *item = [filtered objectAtIndex:0];
                            [resultDict setObject:[item objectForKey:@"tableName"] forKey:@"table_name"];
                        }
                        [resultDict setObject: self.selectedTable forKey:@"table_id"];
                    }
                    [resultDict setObject:self.chooseTimeStart forKey:@"begin_at"];
                    [resultDict setObject:self.chooseTimeEnd forKey:@"end_at"];
                    
                    
                    [[SingleTone sharedManager] setDictOrder:resultDict];
                    
                    [self.navigationController popToViewController:controller animated:YES];
                } else {
                    //ВОЗВРАЩАЕМ СТОЛЫ ПРИ ВЫБОРЕ СТОЛА (НЕ ВАЖНО);
                    self.chooseTimeEnd = self.chooseTime;
                    NSInteger counter = self.navigationController.viewControllers.count - 2;
                    YourOrderController * controller = [self.navigationController.viewControllers objectAtIndex:counter];
                    
                    NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
                    
                    if(self.selectedTable){
                        NSIndexSet *indices = [self.tableArray indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                            return [[NSString stringWithFormat:@"%@", [obj objectForKey:@"tableID"]] isEqualToString:[NSString stringWithFormat:@"%@",self.selectedTable]];
                        }];
                        NSArray *filtered = [self.tableArray objectsAtIndexes:indices];
                        if(filtered.count>0){
                            NSDictionary *item = [filtered objectAtIndex:0];
                            [resultDict setObject:[item objectForKey:@"tableName"] forKey:@"table_name"];
                        }
                        [resultDict setObject: self.selectedTable forKey:@"table_id"];
                    }
                    [resultDict setObject:self.chooseTimeStart forKey:@"begin_at"];
                    [resultDict setObject:self.chooseTimeEnd forKey:@"end_at"];
                    
                    
                    [[SingleTone sharedManager] setDictOrder:resultDict];

                    
                    [self.navigationController popToViewController:controller animated:YES];
                }
                

            }
        }
    } else {
        
        if(self.selectedTable){
            NSIndexSet *indices = [self.tableArray indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                return [[NSString stringWithFormat:@"%@", [obj objectForKey:@"tableID"]] isEqualToString:[NSString stringWithFormat:@"%@",self.selectedTable]];
            }];
            
            
            
            NSArray *filtered = [self.tableArray objectsAtIndexes:indices];
            
            NSMutableDictionary * resultDict = [[SingleTone sharedManager] dictOrder];
            [resultDict setObject: self.selectedTable forKey:@"table_id"];
            
            if(filtered.count>0){
                NSDictionary *item = [filtered objectAtIndex:0];
                [resultDict setObject:[item objectForKey:@"tableName"] forKey:@"table_name"];
            }
            
            [[SingleTone sharedManager] setDictOrder:resultDict];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        // Если переходим с окна заказа -------------------------
    }
    
    }

#pragma mark - Gesters

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform,
                                                         recognizer.scale, recognizer.scale)];
    
    if (recognizer.view.transform.a > 1.6) {
        CGAffineTransform fooTransform = recognizer.view.transform;
        fooTransform.a = 1.6; // this is x coordinate
        fooTransform.d = 1.6; // this is y coordinate
        recognizer.view.transform = fooTransform;
    }
    
    if (recognizer.view.transform.a < 0.95) {
        CGAffineTransform fooTransform = recognizer.view.transform;
        fooTransform.a = 1.00; // this is x coordinate
        fooTransform.d = 1.00; // this is y coordinate
        recognizer.view.transform = fooTransform;
    }
    recognizer.scale = 1.0;
}

- (void) handlePan: (UIPanGestureRecognizer*) recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 50), self.view.bounds.size.height - 50);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
    }
}

- (void) handleDoubleTap: (UITapGestureRecognizer*) tapGesture {
    self.baseView.center = self.baseCenter;
    CGAffineTransform fooTransform = self.baseView.transform;
    fooTransform.a = 1.00;
    fooTransform.d = 1.00;
    self.baseView.transform = fooTransform;
}

#pragma mark - Other

- (BOOL) checkOnTable {
    for (CustomButton * button in self.buttonsArray) {
        if (button.isBool) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Animations

- (void) animatiomForType: (NSInteger) type {
    
    if (type == 0) {
        [self animutionForTimeendDirection:NO];
        self.darkView.alpha = 0.f;
        self.customNavigationLabel.text = @"Выберите столик";
    } else if (type == 1) {
        [self animutionForTimeendDirection:YES];
        self.darkView.alpha = 0.3f;
        self.customNavigationLabel.text = @"Выберите время визита";
    } else {
        self.typeView -= 1;
        NSLog(@"Другие действия");
    }
}

- (void) animutionForTimeendDirection: (BOOL) direction {
    
    if (direction) {
        CGRect rectButtonNext = self.buttonNext.frame;
        rectButtonNext.origin.x = 0.f;
        rectButtonNext.size.width = self.view.frame.size.width;
        self.buttonNext.frame = rectButtonNext;
        
        NSArray * arrayViewsAnimation = [NSArray arrayWithObjects:self.buttonNext, self.buttonNotMatter,
                                         self.mainTimePickerView, nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView * view in arrayViewsAnimation) {
                CGRect rect = view.frame;
                rect.origin.y -= self.mainTimePickerView.frame.size.height;
                view.frame = rect;
            }
        } completion:^(BOOL finished) {}];
    } else {
        CGRect rectButtonNext = self.buttonNext.frame;
        rectButtonNext.origin.x = CGRectGetWidth(self.view.bounds) / 2;
        rectButtonNext.size.width = CGRectGetWidth(self.view.bounds) / 2;
        self.buttonNext.frame = rectButtonNext;
        
        NSArray * arrayViewsAnimation = [NSArray arrayWithObjects:self.buttonNext, self.buttonNotMatter,
                                         self.mainTimePickerView, nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView * view in arrayViewsAnimation) {
                CGRect rect = view.frame;
                rect.origin.y += self.mainTimePickerView.frame.size.height;
                view.frame = rect;
            }
        } completion:^(BOOL finished) {}];
    }
}

- (void) animationApDatePickeViewWithBlock: (void (^) (void)) compitionBlock endDicrction: (BOOL) direction {
    
    NSArray * arrayViewsAnimation = [NSArray arrayWithObjects:self.buttonNext, self.buttonNotMatter,
                                     self.mainTimePickerView, nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView * view in arrayViewsAnimation) {
            CGRect rect = view.frame;
            rect.origin.y += self.mainTimePickerView.frame.size.height;
            view.frame = rect;
        }
    } completion:^(BOOL finished) {
        compitionBlock();
        if (direction) {
            CGRect rectButtonNext = self.buttonNext.frame;
            rectButtonNext.origin.x = CGRectGetWidth(self.view.bounds) / 2;
            rectButtonNext.size.width = CGRectGetWidth(self.view.bounds) / 2;
            self.buttonNext.frame = rectButtonNext;
        } else {
            CGRect rectButtonNext = self.buttonNext.frame;
            rectButtonNext.origin.x = 0;
            rectButtonNext.size.width = CGRectGetWidth(self.view.bounds);
            self.buttonNext.frame = rectButtonNext;
        }
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView * view in arrayViewsAnimation) {
                CGRect rect = view.frame;
                rect.origin.y -= self.mainTimePickerView.frame.size.height;
                view.frame = rect;
            }
        }];
    }];
    
}


@end
