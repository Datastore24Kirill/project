//
//  ChooseHookahController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 18.02.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseHookahController.h"
#import "ChooseHookahModel.h"
#import "HookahCell.h"
#import "ChooseTobaccoController.h"
#import "HookahDetailController.h"
#import "SingleTone.h"

@interface ChooseHookahController () <HookahCellDelegate,ChooseHookahModelDelegate>

@property (strong, nonatomic) NSMutableArray * arrayRows;
@property (strong, nonatomic) NSMutableArray * arrayBoolParams;
@property (strong, nonatomic) ChooseHookahModel * chooseHookahModel;


@end

@implementation ChooseHookahController

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
    self.chooseHookahModel = [[ChooseHookahModel alloc] init];
    self.chooseHookahModel.delegate = self;
    [self.chooseHookahModel getArray:self.outletID timeBlock:^{
        
        NSString * nameHookah = [[[SingleTone sharedManager] dictOrder] objectForKey:@"hookah_name"];
        
        [self.arrayBoolParams removeAllObjects];
        
        for (int i = 0; i < self.hookahTempArray.count; i++) {
            NSDictionary * dictHookah = [self.hookahTempArray objectAtIndex:i];
            NSString * tempNameHookah = [dictHookah objectForKey:@"full_name"];
            if ([nameHookah isEqualToString:tempNameHookah]) {
                [self.arrayBoolParams addObject:[NSNumber numberWithBool:YES]];
                self.buttonNext.userInteractionEnabled = YES;
                self.darkViewForButtonNext.alpha = 0.f;
            } else {
                [self.arrayBoolParams addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createActivitiIndicatorAlertWithView];
    self.arrayRows = [NSMutableArray array];
    self.arrayBoolParams = [NSMutableArray array];
    self.buttonNext.userInteractionEnabled = NO;
    self.darkViewForButtonNext.alpha = 0.4f;
    
    //Кастомный массив будет для отрисовки ячеек сюда ндао поместить колличсетво объектов приходящих с сервера
    
    for (int i = 0; i < 10; i++) {
        [self.arrayBoolParams addObject:[NSNumber numberWithBool:NO]];
    }
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self setCustomTitle:@"Выберите кальян"];
    self.tabBarController.tabBar.hidden = YES;
    
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

#pragma mark - LOAD

-(void) loadHookah:(NSArray *) arrayRespone{
    
    self.hookahArray = arrayRespone;
    self.hookahTempArray = arrayRespone;
    [self.tableView reloadData];
    [self deleteActivitiIndicator];
}

#pragma mark - Actions 

- (void) actionBackButton: (UIBarButtonItem*) button {
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) keyboardWillShow: (NSNotification*) notification {
    
    [self animationMethodWithDictParams:[self paramsKeyboardWithNotification:notification]];
}

- (void) keyboardWillHide: (NSNotification*) notification {
    
    [self animationMethodWithDictParams:[self paramsKeyboardWithNotification:notification]];
}

- (IBAction)actionButtonNext:(UIButton *)sender {
    
    //Если приходит из зименения заказа условия пропускаются, возврат к окну оформления заказа
    
    //    if (self.isBool) {
    //        NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
    //        [dict setObject:self.chooseHookah forKey:@"hookah_id"];
    //        [dict setObject:self.chooseHookahName forKey:@"hookah_name"];
    //        [dict setObject:self.maximumNumberOfFeatures forKey:@"maximumNumberOfFeatures"];
    //
    //        [[SingleTone sharedManager] setDictOrder:dict];
    //        [self.navigationController popViewControllerAnimated:YES];
    //    } else {
    //
    NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
    
    NSMutableDictionary * dictTemp = [[[SingleTone sharedManager] dictOrder] mutableCopy];

    
    
    
    
    ChooseTobaccoController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTobaccoController"];
    
    if(self.chooseHookah){
        [dictTemp setObject:self.chooseHookah forKey:@"hookah_id"];
        [dictTemp setObject:self.chooseHookahName forKey:@"hookah_name"];
        [dictTemp setObject:self.maximumNumberOfFeatures forKey:@"maximumNumberOfFeatures"];
 
            for (NSString *key in dict) {
                
                if ([key rangeOfString:@"tobaccos"].location != NSNotFound && [key rangeOfString:@"id"].location != NSNotFound ) {
                    
                    [dictTemp removeObjectForKey:key];
                }
            }
            
            [[SingleTone sharedManager] setDictOrder:dictTemp];
        [[SingleTone sharedManager] setDictOrder:dictTemp];
        
        detail.outletID = self.outletID;
        detail.hookahID = self.chooseHookah;
        
        detail.maximumNumberOfFeatures = self.maximumNumberOfFeatures;
        detail.isBool = self.isBool;
        detail.isBoolHookah = self.isBool;

    }else{
        detail.outletID = [dictTemp objectForKey:@"outlet_id"];
        detail.hookahID = [dictTemp objectForKey:@"hookah_id"];
        detail.maximumNumberOfFeatures = [dictTemp objectForKey:@"maximumNumberOfFeatures"];
        detail.isBool = self.isBool;
        detail.isBoolHookah = self.isBool;
    }
    
    
    
    
    
    
    [self.navigationController pushViewController:detail animated:YES];
    //    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.hookahTempArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier = @"Cell";
    HookahCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    NSDictionary * dict = [self.hookahTempArray objectAtIndex:indexPath.row];
    
    cell.labelNameCell.text = [dict objectForKey:@"content"];
    cell.isBool = [[self.arrayBoolParams objectAtIndex:indexPath.row] boolValue];
    
    cell.buttonDetail.customFullName = [dict objectForKey:@"full_name"];
    cell.buttonDetail.customName = [dict objectForKey:@"content"];
    cell.buttonDetail.customDescription = [dict objectForKey:@"description"];
    cell.buttonDetail.customImageURL = [dict objectForKey:@"image_url"];
    
    
    if (cell.isBool) {
        cell.imageCheck.alpha = 1;
    } else {
        cell.imageCheck.alpha = 0;
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
        [self.chooseHookahModel setIsFilterText:YES];
         [self.chooseHookahModel setFilterText:self.filterTextFild.text];
        NSArray * resultArray = [self.chooseHookahModel filtred:self.hookahArray];
        self.hookahTempArray = resultArray;
        [self.tableView reloadData];
    }else if(self.filterTextFild.text.length<=2){
        [self.chooseHookahModel setIsFilterText:NO];
        self.hookahTempArray = self.hookahArray;
        [self.tableView reloadData];
    }
    
    
}


#pragma mark - HookahCellDelegate

- (void) actionBuutonChoose: (HookahCell*) hookahCell andButtonSender: (CustomButton*) sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:hookahCell];
    
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
    
    self.chooseHookah = [NSString stringWithFormat:@"%@",
                         [[self.hookahTempArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    self.chooseHookahName = [NSString stringWithFormat:@"%@",
                         [[self.hookahTempArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    NSString * resultMaximum;
    if([[[self.hookahTempArray objectAtIndex:indexPath.row] objectForKey:@"maximum_number_of_features"] isEqual:[NSNull null]]){
        resultMaximum = @"0";
    }else{
        resultMaximum = [[self.hookahTempArray objectAtIndex:indexPath.row] objectForKey:@"maximum_number_of_features"];
    }
    
    self.maximumNumberOfFeatures = [NSString stringWithFormat:@"%@",
                                    resultMaximum];
    [self.tableView reloadData];

}

-(void) actionButtonDetail:(HookahCell*) hookahCell andButtonSender: (CustomButton*) sender{
    self.hidesBottomBarWhenPushed = YES;
    HookahDetailController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HookahDetailController"];
    detail.fullName = sender.customFullName;
    detail.name = sender.customName;
    detail.information = sender.customDescription;
    detail.image_url = sender.customImageURL;
    
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
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
