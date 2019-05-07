//
//  CountryController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "CountryController.h"
#import "CountryModel.h"
#import "CitiesController.h"
#import "UIView+BorderView.h"
#import "SingleTone.h"
#import "OtherDetailsController.h"


@interface CountryController () <CountryModelDelegate>

@property (strong, nonatomic) NSString * nameCountry;

@end

@implementation CountryController

- (void) loadView {
    [super loadView];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = NO;
    [self setCustomTitle:[NSString stringWithFormat:NSLocalizedString(@"CountryController_title", nil)]];
    
    
    self.countryTableView.backgroundColor = [UIColor clearColor];
    self.countryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayCountry = [[NSArray alloc] init];
    [self createActivitiIndicatorAlertWithView];
    
    CountryModel * countryModel = [[CountryModel alloc] init];
    countryModel.delegate = self;
    
    [countryModel getCountryArrayToTableView:^{
        [self deleteActivitiIndicator];
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayCountry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier = @"CountryCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary * countryInfo = [self.arrayCountry objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [countryInfo objectForKey:@"name"];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![[SingleTone sharedManager] changeCountry]) {
        CitiesController * city = [self.storyboard instantiateViewControllerWithIdentifier:@"CitiesController"];
        city.countryID = [NSString stringWithFormat:@"%@", [[self.arrayCountry objectAtIndex:indexPath.row] objectForKey:@"id"]];
        
        [self.navigationController pushViewController:city animated:YES];
    } else {
        
        NSDictionary * countryInfo = [self.arrayCountry objectAtIndex:indexPath.row];
        self.nameCountry = [NSString stringWithFormat:@"%@", [countryInfo objectForKey:@"name"]];
        
        [[SingleTone sharedManager] setCountry:[NSString stringWithFormat:@"%@", [[self.arrayCountry objectAtIndex:indexPath.row] objectForKey:@"id"]]];
        
        NSInteger countViewController = self.navigationController.viewControllers.count;
        
        OtherDetailsController * controller = [self.navigationController.viewControllers objectAtIndex:countViewController-2];
        [controller.buttonCountry setTitle:self.nameCountry forState:UIControlStateNormal];
        [[SingleTone sharedManager] setChangeCountry:NO];
        [self.navigationController popToViewController:controller animated:YES];
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 51.f;
    
}

#pragma  mark - RELOAD TABLE

-(void) reloadTable{
    [self.countryTableView reloadData];
}







@end
