//
//  HistoryController.m
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "HistoryController.h"
#import "HistoryCell.h"
#import "HistoryModel.h"
#import "HexColors.h"
#import "DateTimeMethod.h"
#import "YourOrderController.h"

@interface HistoryController () <UITableViewDelegate, UITableViewDataSource, HistoryCellDelegate,HistoryModelDelegate>

@property (strong, nonatomic) NSArray * arrayData;
@property (strong, nonatomic) NSArray * arrayPastData;
@property (strong, nonatomic) HistoryModel * historyModel;

@end

@implementation HistoryController

- (void) loadView {
    [super loadView];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
    
    UILabel * CustomText = [[UILabel alloc]initWithTitle:@"История заказов"];
    self.navigationItem.titleView = CustomText;
    
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    self.viewCurrent.layer.cornerRadius = 5;
    self.pasrOrdersView.layer.cornerRadius = 5;
    self.pasrOrdersView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    [self.pasrOrdersView.layer setShadowOffset:CGSizeMake(0, -2)];
    [self.pasrOrdersView.layer setShadowOpacity:0.7];
    [self.pasrOrdersView.layer setShadowRadius:2.0f];
//    [self.pasrOrdersView.layer setShouldRasterize:YES];
    
    self.tableCurrent.showsVerticalScrollIndicator = NO;
//    self.tableCurrent.allowsSelection = NO;
    self.tableCurrent.scrollEnabled = NO;
    
    self.pastOrdersTable.showsVerticalScrollIndicator = NO;
//    self.pastOrdersTable.allowsSelection = NO;
    self.pastOrdersTable.scrollEnabled = NO;

}

- (void) viewDidLoad {
    [super viewDidLoad];
    
   
    

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.historyModel = [[HistoryModel alloc] init];
    self.historyModel.delegate = self;
    [self.historyModel getVisitorOrders];
    
    
    
    
}

-(void) loadDefault:(NSArray *) currentOrder finishOrder:(NSArray *) finishOrder{
    
    self.arrayData = currentOrder;
    self.arrayPastData = finishOrder;
    
    if (self.arrayData.count == 0) {
        self.viewCurrent.alpha = 0.f;
    }
    if (self.arrayPastData.count == 0) {
        self.pasrOrdersView.alpha = 0;
    }
    
    CGRect tableCurrentRect = self.viewCurrent.frame;
    tableCurrentRect.size.height = 81.f * self.arrayData.count + 80.f;
    self.viewCurrent.frame = tableCurrentRect;
    
    CGRect tablePastRect = self.pasrOrdersView.frame;
    if (self.arrayData.count == 0) {
        tablePastRect.origin.y = 0;
    } else {
        tablePastRect.origin.y = CGRectGetMaxY(self.viewCurrent.frame) - 30.f;
    }
    tablePastRect.size.height = 81.f * self.arrayPastData.count + 50.f;
    self.pasrOrdersView.frame = tablePastRect;
    
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.pasrOrdersView.frame));
    
    [self.tableCurrent reloadData];
    [self.pastOrdersTable reloadData];
    
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.tableCurrent]) {
        return self.arrayData.count;
    } else {
        return self.arrayPastData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"Cell";
    NSDictionary * dictCell;
    
    if ([tableView isEqual:self.tableCurrent]) {
        dictCell = [self.arrayData objectAtIndex:indexPath.row];
    } else {
        dictCell = [self.arrayPastData objectAtIndex:indexPath.row];
    }
    
    
    HistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.labelName.text = [dictCell objectForKey:@"name"];
    
    cell.typeCell = [[dictCell objectForKey:@"status"] integerValue];
    
    NSDate * orderDate = [DateTimeMethod timestampToDate:[dictCell objectForKey:@"begin_at"]];
    

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm"];
    NSString *orderDateString = [dateFormatter stringFromDate:orderDate];
    
    cell.labelDate.text = orderDateString;
    cell.labelTable.text = [NSString stringWithFormat:@"Столик %@",[dictCell objectForKey:@"table"]];
    NSString * totalPrice = [dictCell objectForKey:@"total"];
    

    
    totalPrice = [totalPrice stringByReplacingOccurrencesOfString:@".00"
                                         withString:@""];
    
    cell.labelPrice.text = [NSString stringWithFormat:@"%@ ₽", totalPrice];
    
    if ([tableView isEqual:self.tableCurrent]) {
        if ([[dictCell objectForKey:@"status"] integerValue] == 6) {
            [cell.buttonCell setTitle:@"Зарезервирован" forState:UIControlStateNormal];
        }
        if ([[dictCell objectForKey:@"status"] integerValue] == 1) {
            [cell.buttonCell setTitle:@"Активный" forState:UIControlStateNormal];
        }
    } else {
        
        if ([[dictCell objectForKey:@"status"] integerValue] == 5) {
            CGRect buttonRect = cell.buttonCell.frame;
            buttonRect.origin.x = CGRectGetWidth(cell.contentView.bounds) - 73.f;
            buttonRect.size.width = 58.f;
            cell.buttonCell.frame = buttonRect;
            [cell.buttonCell setTitle:@"Отменен" forState:UIControlStateNormal];
            cell.buttonCell.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"D04A4A"];
        }else if ([[dictCell objectForKey:@"status"] integerValue] == 4){
           
            [cell.buttonCell setTitle:@"Завершен" forState:UIControlStateNormal];
            
        }
        
    }

    cell.buttonCell.layer.cornerRadius = 3.f;
    
    if ([tableView isEqual:self.tableCurrent]) {
        cell.buttonCell.userInteractionEnabled = NO;
    }
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary * dictCell;
    if ([tableView isEqual:self.tableCurrent]) {
        dictCell = [self.arrayData objectAtIndex:indexPath.row];
    } else {
        dictCell = [self.arrayPastData objectAtIndex:indexPath.row];
    }
    
    HistoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YourOrderController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"YourOrderController"];
    controller.typeOrder = cell.typeCell;
    controller.orderID = [dictCell objectForKey:@"id"];
    controller.isHistory = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - HistoryCellDelegate

- (void) actionButtonCell: (HistoryCell*) historyCell withButton: (CustomButton*) sender {
    
    
    NSLog(@"Hello cell");
    
}






@end
