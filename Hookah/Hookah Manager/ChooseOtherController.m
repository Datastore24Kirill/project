//
//  ChooseOtherController.m
//  Hookah Manager
//
//  Created by Viktor on 3/22/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseOtherController.h"
#import "ChooseFlavorCell.h"
#import "ChooseOtherModel.h"
#import "SingleTone.h"
#import "YourOrderController.h"

@interface ChooseOtherController () <UITableViewDelegate, UITableViewDataSource, ChooseFlavorCellDelegate, ChooseOtherModelDelegate>

@property (strong, nonatomic) NSMutableArray * mArray;
@property (assign, nonatomic) NSInteger countFlavor;
@property (strong, nonatomic) ChooseOtherModel * chooseOtherModel;

@end

@implementation ChooseOtherController

- (void) loadView {
    [super loadView];
    
    [[UISwitch appearance] setTintColor:[UIColor clearColor]];

    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self setCustomTitle:@"Прочее"];
    self.darkViewForButtonNext.alpha = 0.f;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.allowsSelection = NO;
    self.chooseOtherModel = [[ChooseOtherModel alloc] init];
    self.chooseOtherModel.delegate = self;
    self.chooseOthers = [NSMutableArray new];
    [self.chooseOtherModel getArray:self.outletID timeBlock:^{
        
        [self.mArray removeAllObjects];
        
        
        NSString * allString = [[SingleTone sharedManager] stringOther];
        
        for (int i = 0; i < self.otherArray.count; i++) {
            NSDictionary * dict = [self.otherArray objectAtIndex:i];
            NSString * nameString = [dict objectForKey:@"name"];
            
            if ([allString rangeOfString:nameString].location == NSNotFound) {
                [self.mArray addObject:[NSNumber numberWithBool:NO]];
            } else {
                [self.mArray addObject:[NSNumber numberWithBool:YES]];
                NSDictionary * dictResult = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [dict objectForKey:@"id"],@"id",
                                             [dict objectForKey:@"name"],@"name",nil];
                [self.chooseOthers addObject:dictResult];

            }
        }
        
        self.countFlavor = 0;
        //Проверка булевых значений
        for (int i = 0; i < self.mArray.count; i++) {
            if ([[self.mArray objectAtIndex:i] boolValue]) {
                self.countFlavor ++;
            }
        }
        //ЭТО НЕ НУЖНО!!!
//        if (self.countFlavor > 0) {
//            self.darkViewForButtonNext.alpha = 0.f;
//        } else {
//            self.darkViewForButtonNext.alpha = 0.4f;
//        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countFlavor = 0;
    self.mArray = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [self.mArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    //Проверка булевых значений
    for (int i = 0; i < self.mArray.count; i++) {
        if ([[self.mArray objectAtIndex:i] boolValue]) {
            self.countFlavor ++;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadOther:(NSArray *) arrayRespone{
    self.otherArray = arrayRespone;
    [self.mainTableView reloadData];
}

#pragma mark - Actions

- (void) actionBackButton: (UIBarButtonItem*) button {
    
    //Если приходит из зименения заказа условия пропускаются
    
    if (!self.isBool) {
        NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
        
        NSMutableDictionary * dictTemp = [[[SingleTone sharedManager] dictOrder] mutableCopy];
        
        for (NSString *key in dict) {
            
            if ([key rangeOfString:@"others"].location != NSNotFound) {
                
                [dictTemp removeObjectForKey:key];
            }
        }
        
        [[SingleTone sharedManager] setDictOrder:dictTemp];
        
        
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonNextAction:(UIButton*)sender {
    
    //Если приходит из зименения заказа условия пропускаются
    
    if (self.isBool) {
        
        
        NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
        
        NSMutableDictionary * dictTemp = [[[SingleTone sharedManager] dictOrder] mutableCopy];
        
        if(self.chooseOthers.count>0){
            for (NSString *key in dict) {
                
                if ([key rangeOfString:@"others"].location != NSNotFound) {
                    
                    [dictTemp removeObjectForKey:key];
                }
            }
        }
        
        
        for(int i=0; i < self.chooseOthers.count; i++){
            NSDictionary * otherChooseDict = [self.chooseOthers objectAtIndex:i];
            NSString * stringKey = [NSString stringWithFormat:@"others[%d]",i];
            NSString * stringKeyName = [NSString stringWithFormat:@"others_name[%d]",i];
            [dictTemp setObject:[otherChooseDict objectForKey:@"id"] forKey:stringKey];
            [dictTemp setObject:[otherChooseDict objectForKey:@"name"] forKey:stringKeyName];
        }
        
        [[SingleTone sharedManager] setDictOrder:dictTemp];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
    
    NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
    
    for(int i=0; i < self.chooseOthers.count; i++){
        NSDictionary * otherChooseDict = [self.chooseOthers objectAtIndex:i];
        NSString * stringKey = [NSString stringWithFormat:@"others[%d]",i];
        NSString * stringKeyName = [NSString stringWithFormat:@"others_name[%d]",i];
        [dict setObject:[otherChooseDict objectForKey:@"id"] forKey:stringKey];
        [dict setObject:[otherChooseDict objectForKey:@"name"] forKey:stringKeyName];
    }
    
    [[SingleTone sharedManager] setDictOrder:dict];

    
    
    YourOrderController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"YourOrderController"];
    detail.outletID = self.outletID;
    [self.navigationController pushViewController:detail animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.otherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"Cell";
    
    NSDictionary * dict = [self.otherArray objectAtIndex:indexPath.row];
    
    ChooseFlavorCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.labelName.text = [dict objectForKey:@"name"];
    cell.delegate = self;
    cell.swichCell.on = [[self.mArray objectAtIndex:indexPath.row] boolValue];
    [cell.swichCell setOnTintColor:[UIColor clearColor]];
    if ([cell.swichCell isOn]) {
        cell.swichCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"imageSwitchOn"]];
    } else {
        cell.swichCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"imageSwitchOff"]];
    }
    
    return cell;
}

#pragma mark - ChooseFlavorCellDelegate

- (void) actionCell: (ChooseFlavorCell*) chooseFavorCell withSwich: (UISwitch*) swich {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:chooseFavorCell];
    
    NSDictionary * dict = [self.otherArray objectAtIndex:indexPath.row];
   

    if ([swich isOn]) {
        swich.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"imageSwitchOn"]];
        
        [self.chooseOthers addObject:dict];
        
        [self.mArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:swich.on]];
    } else {
        swich.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"imageSwitchOff"]];
        
        [self.chooseOthers removeObject:dict];
        
        [self.mArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:swich.on]];
    }
    
    
    
    if (swich.on) {
        self.countFlavor ++;
    } else {
        self.countFlavor --;
    }
    
    
 //ЭТО НЕ НУЖНО!!!!!
//    if (self.countFlavor > 0) {
//        self.darkViewForButtonNext.alpha = 0.f;
//    } else {
//        self.darkViewForButtonNext.alpha = 0.4f;
//    }
}
@end
