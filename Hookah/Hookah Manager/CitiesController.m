//
//  CitiesController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "CitiesController.h"
#import "CitiesModel.h"
#import "UIView+BorderView.h"
#import "ButtonMenu.h"
#import "MenuBarController.h"
#import "UserInformationTable.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "OtherDetailsController.h"


@interface CitiesController () <CitiesModelDelegate>

@property (strong, nonatomic) UserInformationTable * selectedDataObject;
@property (strong, nonatomic) RLMResults *tableDataArray;

@property (strong, nonatomic) NSString * nameCities;


@end

@implementation CitiesController

- (void) loadView {
    [super loadView];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = NO;

    
    [self setCustomTitle:[NSString stringWithFormat:NSLocalizedString(@"CitiesController_title", nil)]];
    
    self.citiesTableView.backgroundColor = [UIColor clearColor];
    self.citiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Кнопка Назад---------------------------------------------
    UIButton * buttonBack = [ButtonMenu createButtonBack];
    [buttonBack addTarget:self action:@selector(buttonBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mailbuttonBack =[[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    self.navigationItem.leftBarButtonItem = mailbuttonBack;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CitiesModel * citiesModel = [[CitiesModel alloc] init];
    citiesModel.delegate = self;
    
    [self createActivitiIndicatorAlertWithView];
    
    if([[[SingleTone sharedManager] country] length] !=0){
        self.countryID = [[SingleTone sharedManager] country];
    }
    
    [citiesModel getCityArrayToTableView:self.countryID andCompitionBack:^{
        [self deleteActivitiIndicator];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayCities.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier = @"CitiesCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary * cityInfo = [self.arrayCities objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [cityInfo objectForKey:@"name"];
    cell.textLabel.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    UIView * borderView = [UIView createBorderViewWithView:self.view andHeight:50.f];
    [cell addSubview:borderView];
    
    if (indexPath.row == 0) {
        UIView * borderView = [UIView createBorderViewWithView:self.view andHeight:0.f];
        [cell addSubview:borderView];
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![[SingleTone sharedManager] changeCountry]) {
        NSDictionary * cityInfo = [self.arrayCities objectAtIndex:indexPath.row];
        
       
        [self createActivitiIndicatorAlertWithView];
        APIManger * apiManager = [[APIManger alloc] init];
        NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:[cityInfo objectForKey:@"id"],@"city_id", nil];
        [apiManager postDataFromSeverWithMethod:@"visitor.saveCity" andParams:params andToken: [[SingleTone sharedManager] token] complitionBlock:^(id response) {
           
            if([[response objectForKey:@"response"] integerValue] == 1){
                [self deleteActivitiIndicator];
                
                self.tableDataArray=[UserInformationTable allObjects];
                if (self.tableDataArray.count >0 ){
                    self.selectedDataObject = [self.tableDataArray objectAtIndex:0];
                    
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    self.selectedDataObject.city_id=[NSString stringWithFormat:@"%@",[cityInfo objectForKey:@"id"]];
                    [realm commitWriteTransaction];
                }
                [[SingleTone sharedManager] setCityID:self.selectedDataObject.city_id];
                [self pushControllerWithIdentifier:@"MenuBarController"];
                
            }else{
                [self deleteActivitiIndicator];
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                      [response objectForKey:@"error_msg"]);
            }
            
        }];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        
        NSDictionary * countryInfo = [self.arrayCities objectAtIndex:indexPath.row];
        self.nameCities = [NSString stringWithFormat:@"%@", [countryInfo objectForKey:@"name"]];
      
        
        NSInteger countViewController = self.navigationController.viewControllers.count;
        
        [[SingleTone sharedManager] setCountry:@""];
        
        OtherDetailsController * controller = [self.navigationController.viewControllers objectAtIndex:countViewController-2];
        [controller saveCity:[NSString stringWithFormat:@"%@", [countryInfo objectForKey:@"id"]]];
        [controller.buttonCity setTitle:self.nameCities forState:UIControlStateNormal];
        
        [self.navigationController popToViewController:controller animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 51.f;
}

#pragma mark - Actions

- (void) buttonBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
                                 

                                     
#pragma  mark - RELOAD TABLE

-(void) reloadTable{
    [self.citiesTableView reloadData];
}



@end
