//
//  OtherDetailsController.m
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "OtherDetailsController.h"
#import "OtherDetailsModel.h"
#import "OrderCell.h"
#import "SingleTone.h"
#import "DateTimeMethod.h"
#import "UserInformationTable.h"
#import "CitiesController.h"
#import "SelectStakesModel.h"

#import "OrganizationTable.h"
#import "OutletTable.h"
#import "ScheduleOutletsTable.h"

@interface OtherDetailsController ()

@property (strong, nonatomic) OtherDetailsModel * otherDetailsModel;
@property (strong, nonatomic) UserInformationTable * selectedDataObject;
@property (strong, nonatomic) RLMResults *tableDataArray;
@property (strong, nonatomic) NSString * countryID;

@end

@implementation OtherDetailsController

- (void) loadView {
    [super loadView];
    
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.tabBar setHidden:YES];
    [self setCustomTitle:@"Настройки"];
    
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.buttonName setTitle:[self.profileInfo objectForKey:@"name"] forState:UIControlStateNormal];
    NSDictionary * city = [self.profileInfo objectForKey:@"city"];
    [self.buttonCity setTitle:[city objectForKey:@"name"] forState:UIControlStateNormal];
    
    NSDictionary * country = [self.profileInfo objectForKey:@"country"];
    self.countryID = [country objectForKey:@"id"];
    [self.buttonCountry setTitle:[country objectForKey:@"name"] forState:UIControlStateNormal];
    NSDate * datebrth = [DateTimeMethod timestampToDate:[self.profileInfo objectForKey:@"birthday"]];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *brthDateString = [dateFormatter stringFromDate:datebrth];
    
    [[SingleTone sharedManager] setBirthdayDate:datebrth];
    
    [self.buttonDateBirthday setTitle:brthDateString forState:UIControlStateNormal];
    self.otherDetailsModel = [[OtherDetailsModel alloc] init];


    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataPickerChange:) name:@"NOTIFICATION_POST_DATA" object:nil];

    
}

- (void) dataPickerChange: (NSNotification*) notification {
    UIDatePicker * dataPicker = notification.object;
    NSLog(@"DDDD %@", dataPicker.date);
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void) actionBackButton: (UIBarButtonItem*) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionButtonChangePhoto:(UIButton*)sender {
    NSLog(@"ChangePhoto");
}

- (IBAction)actionChangeCountryButton:(UIButton*)sender {
    [[SingleTone sharedManager] setChangeCountry:YES];
    [self.buttonCity setTitle:@"Выберите город" forState:UIControlStateNormal];
    [self pushControllerWithIdentifier:@"CountryController"];
}

- (IBAction)actionChangeCityButton:(UIButton*)sender {
    [[SingleTone sharedManager] setChangeCountry:YES];
    CitiesController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"CitiesController"];
    detail.countryID  = self.countryID;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (IBAction)actionChangeNameButton:(CustomButton*)sender {
    [self showTextFildNameWithButton:sender withBlockAction:^{
        

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMMM yyyy"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        NSDate * birthdayDate =[formatter dateFromString:self.buttonDateBirthday.titleLabel.text];
        
        NSString * dateTimestamp =[DateTimeMethod dateToTimestamp:birthdayDate];
        NSLog(@"actionChangeNameButton %@ birth %@",sender.customName,dateTimestamp);
        
        self.tableDataArray=[UserInformationTable allObjects];
        if (self.tableDataArray.count >0 ){
            self.selectedDataObject = [self.tableDataArray objectAtIndex:0];
        }
        NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.selectedDataObject.city_id,@"city_id",
                                 sender.customName,@"name",
                                 dateTimestamp,@"birthday",
                                 nil];
        NSLog(@"PARAMS %@",params);
        [self.otherDetailsModel saveAll:params andBlock:^(id response) {
            if([response objectForKey:@"error_code"]){
                NSLog(@"ERROR RESPONSE %@",[response objectForKey:@"error_code"]);
            }
        }];
    }];
}

- (IBAction)actionChangeDataBirthdayButton:(UIButton*)sender {
    [self showDataPickerBirthdayActionWithButton:sender withBlockAction:^{
        NSString * dateTimestamp =[DateTimeMethod dateToTimestamp:[[SingleTone sharedManager] birthdayDate]];
        NSLog(@"actionChangeNameButton2 %@ birth %@ - %@",self.buttonName.titleLabel.text,dateTimestamp,self.buttonName.titleLabel.text);
        
        self.tableDataArray=[UserInformationTable allObjects];
        if (self.tableDataArray.count >0 ){
            self.selectedDataObject = [self.tableDataArray objectAtIndex:0];
        }
        
        NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.selectedDataObject.city_id,@"city_id",
                                 self.buttonName.titleLabel.text,@"name",
                                 dateTimestamp,@"birthday",
                                 nil];
        [self.otherDetailsModel saveAll:params andBlock:^(id response) {
            if([response objectForKey:@"error_code"]){
                NSLog(@"ERROR RESPONSE %@",[response objectForKey:@"error_code"]);
            }
        }];

    }];
    
}

-(void) saveCity:(NSString *) cityID{
    NSLog(@"CITY %@",cityID);
    [self.otherDetailsModel saveCity:cityID andBlock:^(id response) {
        if([response objectForKey:@"error_code"]){
            NSLog(@"ERROR RESPONSE %@",[response objectForKey:@"error_code"]);
        }else{
            self.tableDataArray=[UserInformationTable allObjects];
            if (self.tableDataArray.count >0 ){
                self.selectedDataObject = [self.tableDataArray objectAtIndex:0];
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                self.selectedDataObject.city_id=[NSString stringWithFormat:@"%@",cityID];
                self.selectedDataObject.orgRequestTime = @"0";
                self.selectedDataObject.outletRequestTime = @"0";
                [realm commitWriteTransaction];
                
                RLMResults *orgTableDataArray = [OrganizationTable allObjects];
                RLMResults *outletTableDataArray = [OutletTable allObjects];
                RLMResults *scheduleOutletsTableTableDataArray = [ScheduleOutletsTable allObjects];
                
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm] deleteObjects:orgTableDataArray];
                [[RLMRealm defaultRealm] commitWriteTransaction];
                
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm] deleteObjects:outletTableDataArray];
                [[RLMRealm defaultRealm] commitWriteTransaction];
                
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm] deleteObjects:scheduleOutletsTableTableDataArray];
                
                [[RLMRealm defaultRealm] commitWriteTransaction];
                
                SelectStakesModel * selectStakesModel = [[SelectStakesModel alloc] init];
                [selectStakesModel updateOutletTable];
                [selectStakesModel updateOrganizationTable];
            }
            
        }
    }];
}



@end
