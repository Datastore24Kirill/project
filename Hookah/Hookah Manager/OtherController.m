//
//  OtherController.m
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "OtherController.h"
#import "OtherCell.h"
#import "OtherModel.h"
#import "OtherDetailsController.h"

@interface OtherController () <UITableViewDelegate, UITableViewDataSource, OtherModelDelegate>
@property (strong, nonatomic) OtherModel * otherModel;
@end

@implementation OtherController


- (void) loadView {
    [super loadView];
    
    self.mainTableView.scrollEnabled = NO;
    
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.otherModel = [[OtherModel alloc] init];
    self.otherModel.delegate = self;
    [self.otherModel loadProfile];
    [self createActivitiIndicatorAlertWithView];
    
    [self.tabBarController.tabBar setHidden:NO];
}

-(void) loadDefault:(NSDictionary *) dict{
    
    self.profileInfo = dict;
    self.labelName.text = [dict objectForKey:@"name"];
    [self deleteActivitiIndicator];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"Cell";
    
    OtherCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.labelName.text = @"Настройки";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OtherDetailsController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherDetailsController"];
    detail.profileInfo = self.profileInfo;
    [self.navigationController pushViewController:detail animated:YES];
    
}

@end
