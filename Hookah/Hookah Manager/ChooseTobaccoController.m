//
//  ChooseTobaccoController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.02.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseTobaccoController.h"
#import "ChooseTobaccoModel.h"
#import "ChooseFlavorController.h"
#import "HookahDetailController.h"
#import "TobaccoCell.h"
#import "SingleTone.h"

@interface ChooseTobaccoController () <TobaccoCellDelegate,ChooseTobaccoModelDelegate>

@property (strong, nonatomic) NSMutableArray * arrayRows;
@property (strong, nonatomic) NSMutableArray * arrayBoolParams;
@property (strong, nonatomic) ChooseTobaccoModel * chooseTabacooModel;

@end

@implementation ChooseTobaccoController

- (void) loadView {
    [super loadView];
    
    

    self.navigationController.navigationBarHidden = NO;
    
    
    self.viewForTextFild.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.userInteractionEnabled = YES;
    self.chooseTabacooModel = [[ChooseTobaccoModel alloc] init];
    self.chooseTabacooModel.delegate = self;
    [self.chooseTabacooModel getArray:self.outletID andHookahID:self.hookahID timeBlock:^{
        
        NSString * nameHookah = [[[SingleTone sharedManager] dictOrder] objectForKey:@"tobaccos[0][id_name]"];
        
        [self.arrayBoolParams removeAllObjects];
        
        for (int i = 0; i < self.tobaccoTempArray.count; i++) {
            NSDictionary * dictHookah = [self.tobaccoTempArray objectAtIndex:i];
            NSString * tempNameHookah = [dictHookah objectForKey:@"name"];
           
            
            if ([nameHookah isEqualToString:tempNameHookah]) {
                [self.arrayBoolParams addObject:[NSNumber numberWithBool:YES]];
                self.darkViewForButtonNext.alpha = 0.f;
            } else {
                [self.arrayBoolParams addObject:[NSNumber numberWithBool:NO]];
            }
        }
        
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.arrayRows = [NSMutableArray array];
    self.arrayBoolParams = [NSMutableArray array];
    
    //Кастомный массив будет для отрисовки ячеек сюда ндао поместить колличсетво объектов приходящих с сервера
    
    for (int i = 0; i < 10; i++) {
        
        if (i == 5) {
            [self.arrayBoolParams addObject:[NSNumber numberWithBool:YES]];
        } else {
            [self.arrayBoolParams addObject:[NSNumber numberWithBool:NO]];
        }
    } 
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];

    self.tabBarController.tabBar.hidden = YES;
    
    [self setCustomTitle:@"Выберите табак"];
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadTobacco:(NSArray *) arrayRespone{
    self.tobaccoArray = arrayRespone;
    self.tobaccoTempArray = arrayRespone;
    [self.tableView reloadData];
    [self deleteActivitiIndicator];
}


#pragma mark - Actions

- (void) actionBackButton: (UIBarButtonItem*) button {
    
    //Если приходит из зименения заказа условия пропускаются
    
    if (!self.isBool) {
        NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
        
        NSMutableDictionary * dictTemp = [[[SingleTone sharedManager] dictOrder] mutableCopy];
        
        for (NSString *key in dict) {
            
            if ([key rangeOfString:@"tobaccos"].location != NSNotFound && [key rangeOfString:@"id"].location != NSNotFound) {
                
                [dictTemp removeObjectForKey:key];
            }
        }
        
        [[SingleTone sharedManager] setDictOrder:dictTemp];
        
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) keyboardWillShow: (NSNotification*) notification {
    
    [self animationMethodWithDictParams:[self paramsKeyboardWithNotification:notification]];
}

- (void) keyboardWillHide: (NSNotification*) notification {
    
    [self animationMethodWithDictParams:[self paramsKeyboardWithNotification:notification]];
}

- (IBAction)actionButtonNext:(UIButton *)sender {
    
    NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
    
    NSMutableDictionary * dictTemp = [[[SingleTone sharedManager] dictOrder] mutableCopy];
    
    ChooseFlavorController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseFlavorController"];
    if(self.chooseTobacco){
        for (NSString *key in dict) {
            
            if ([key rangeOfString:@"tobaccos"].location != NSNotFound && [key rangeOfString:@"id"].location != NSNotFound ) {
                
                [dictTemp removeObjectForKey:key];
            }
            if ([key rangeOfString:@"tobaccos"].location != NSNotFound && [key rangeOfString:@"feature_id"].location != NSNotFound) {
                
                [dictTemp removeObjectForKey:key];
            }

        }
        [[SingleTone sharedManager] setStringFlavor:@""];
        
        [dictTemp setObject:self.chooseTobacco forKey:@"tobaccos[0][id]"];
        [dictTemp setObject:self.chooseTobaccoName forKey:@"tobaccos[0][id_name]"];
        [[SingleTone sharedManager] setDictOrder:dictTemp];
        
        detail.outletID = self.outletID;
        detail.toobaccoID = self.chooseTobacco;
        detail.toobaccoName = self.chooseTobaccoName;
        detail.maximumNumberOfFeatures = self.maximumNumberOfFeatures;

    }else{
        detail.outletID = [dict objectForKey:@"outlet_id"];
        detail.toobaccoID = [dict objectForKey:@"tobaccos[0][id]"];
        detail.toobaccoName = [dict objectForKey:@"tobaccos[0][id_name]"];
        detail.maximumNumberOfFeatures = [dict objectForKey:@"maximumNumberOfFeatures"];
    }
    
    
   
    //Передаем булеый параметр в новое окно
    detail.isBool = self.isBool;
    detail.isBoolHookah = self.isBoolHookah;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tobaccoTempArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier = @"Cell";
    TobaccoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    NSDictionary * dict = [self.tobaccoTempArray objectAtIndex:indexPath.row];
    cell.labelName.text = [dict objectForKey:@"name"];
    cell.isBool = [[self.arrayBoolParams objectAtIndex:indexPath.row] boolValue];
    cell.buttonDetail.customFullName = [dict objectForKey:@"full_name"];
    cell.buttonDetail.customName = [dict objectForKey:@"content"];
    cell.buttonDetail.customDescription = [dict objectForKey:@"description"];
    cell.buttonDetail.customImageURL = [dict objectForKey:@"image_url"];
    
    if (cell.isBool) {
        cell.imageChoose.alpha = 1;
    } else {
        cell.imageChoose.alpha = 0;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.f;
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldTextDidChange: (NSNotification*) notification {
    
  
    if(self.filterTextFild.text.length>2){
        [self.chooseTabacooModel setIsFilterText:YES];
        [self.chooseTabacooModel setFilterText:self.filterTextFild.text];
        NSArray * resultArray = [self.chooseTabacooModel filtred:self.tobaccoArray];
        self.tobaccoTempArray = resultArray;
        [self.tableView reloadData];
    }else if(self.filterTextFild.text.length<=2){
        [self.chooseTabacooModel setIsFilterText:NO];
        self.tobaccoTempArray = self.tobaccoArray;
        [self.tableView reloadData];
    }
    
    
}

#pragma mark - HookahCellDelegate
- (void) actionButtonChoose: (TobaccoCell*) tobaccoCell andButtonSender: (CustomButton*) sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tobaccoCell];
    
    if (![[self.arrayBoolParams objectAtIndex:indexPath.row] boolValue]) {
        [self.arrayBoolParams setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.row];
        [UIView animateWithDuration:0.3 animations:^{
            self.buttonNext.userInteractionEnabled = YES;
            self.darkViewForButtonNext.alpha = 0.f;
        }];
    } else {
        [self.arrayBoolParams setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPath.row];
        [UIView animateWithDuration:0.3 animations:^{
            self.buttonNext.userInteractionEnabled = NO;
            self.darkViewForButtonNext.alpha = 0.4f;
        }];
    }
    
    for (int i = 0; i < self.arrayBoolParams.count; i++) {
        if (i != indexPath.row) {
            [self.arrayBoolParams setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:i];
        }
    }
   
    
    self.chooseTobacco = [NSString stringWithFormat:@"%@",
                         [[self.tobaccoTempArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    self.chooseTobaccoName = [NSString stringWithFormat:@"%@",
                          [[self.tobaccoTempArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [self.tableView reloadData];


}

-(void) actionButtonDetail:(TobaccoCell*) tobaccoCell andButtonSender: (CustomButton*) sender{
    HookahDetailController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HookahDetailController"];
    
    
    detail.fullName = sender.customFullName;
    detail.name = sender.customName;
    detail.information = sender.customDescription;
    detail.image_url = sender.customImageURL;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
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
        CGRect newRect = self.buttonNext.frame;
        newRect.origin.y = [[dict objectForKey:@"height"] floatValue] - CGRectGetHeight(newRect);
        self.buttonNext.frame = newRect;
        self.darkViewForButtonNext.frame = newRect;
        CGRect newTableRect = self.tableView.frame;
        newTableRect.size.height = [[dict objectForKey:@"height"] floatValue] - CGRectGetHeight(newRect) - 64
        - CGRectGetHeight(self.viewForTextFild.bounds);
        self.tableView.frame = newTableRect;
    }];
}
@end
