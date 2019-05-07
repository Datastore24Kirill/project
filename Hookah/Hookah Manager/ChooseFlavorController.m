//
//  ChooseFlavorController.m
//  Hookah Manager
//
//  Created by Viktor on 3/22/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseFlavorController.h"
#import "ChooseFlavorCell.h"
#import "ChooseFlavorModel.h"
#import "ChooseOtherController.h"
#import "SingleTone.h"
#import "YourOrderController.h"

@interface ChooseFlavorController () <UITableViewDelegate, UITableViewDataSource, ChooseFlavorCellDelegate,ChooseFlavorModelDelegate>

@property (strong, nonatomic) NSMutableArray * mArray;
@property (assign, nonatomic) NSInteger countFlavor;
@property (strong, nonatomic) ChooseFlavorModel * chooseFlavorModel;

@end

@implementation ChooseFlavorController

- (void) loadView {
    [super loadView];
    
    [[UISwitch appearance] setTintColor:[UIColor clearColor]];

    self.navigationController.navigationBarHidden = NO;
    
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self setCustomTitle:@"Выберите вкус"];
    
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.allowsSelection = NO;
    self.chooseFlavorModel = [[ChooseFlavorModel alloc] init];
    self.chooseFlavorModel.delegate = self;
    self.chooseFlovers = [NSMutableArray new];
    [self.chooseFlavorModel getArray:self.outletID andTobaccoid:self.toobaccoID timeBlock:^{
        
        [self.mArray removeAllObjects];
        NSString * allString = [[SingleTone sharedManager] stringFlavor];
      
        for (int i = 0; i < self.flavorArray.count; i++) {
            
            NSDictionary * dict = [self.flavorArray objectAtIndex:i];
            NSString * nameString = [dict objectForKey:@"name"];
            
            if ([allString rangeOfString:nameString].location == NSNotFound) {
                [self.mArray addObject:[NSNumber numberWithBool:NO]];
            } else {
                [self.mArray addObject:[NSNumber numberWithBool:YES]];
                NSDictionary * dictResult = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [dict objectForKey:@"id"],@"id",
                                       [dict objectForKey:@"name"],@"name",nil];
                [self.chooseFlovers addObject:dictResult];
            }
        }
        
        self.countFlavor = 0;
        //Проверка булевых значений
        for (int i = 0; i < self.mArray.count; i++) {
            if ([[self.mArray objectAtIndex:i] boolValue]) {
                self.countFlavor ++;
            }
        }
        if (self.countFlavor > 0) {
            self.darkViewForButtonNext.alpha = 0.f;
        } else {
            self.darkViewForButtonNext.alpha = 0.4f;
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];

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
    
    if(self.countFlavor>0){
        self.labelFlovers.alpha = 1.f;
    }else{
        self.labelFlovers.alpha = 0.f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadFlavor:(NSArray *) arrayRespone{
    self.flavorArray = arrayRespone;
    [self.mainTableView reloadData];
    
}

#pragma mark - Actions

- (void) actionBackButton: (UIBarButtonItem*) button {
    
    NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
    
    NSMutableDictionary * dictTemp = [[[SingleTone sharedManager] dictOrder] mutableCopy];
    
    for (NSString *key in dict) {
        
        if ([key rangeOfString:@"tobaccos"].location != NSNotFound && [key rangeOfString:@"feature_id"].location != NSNotFound) {
            
            [dictTemp removeObjectForKey:key];
        }
    }
    
    [[SingleTone sharedManager] setDictOrder:dictTemp];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonNextAction:(UIButton*)sender {
    
    //Если приходит из зименения заказа условия пропускаются, возвращаемся в окну оформления заказа
    
    if (self.isBool) {
        
        NSInteger countForOrder;
        if (self.isBoolHookah) {
            countForOrder = self.navigationController.viewControllers.count - 4;
        } else {
            countForOrder = self.navigationController.viewControllers.count - 3;
        }
        
        
        YourOrderController * controller = [[self.navigationController viewControllers] objectAtIndex:countForOrder];
        
        NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
        
        NSMutableDictionary * dictTemp = [[[SingleTone sharedManager] dictOrder] mutableCopy];
        if(self.chooseFlovers.count>0){
            for (NSString *key in dict) {
                
   
                if ([key rangeOfString:@"tobaccos"].location != NSNotFound && [key rangeOfString:@"feature_id"].location != NSNotFound) {
                    
                    [dictTemp removeObjectForKey:key];
                }
                
            }      
        }
        
        
    
        for(int k=0; k < self.chooseFlovers.count; k++){
            
            NSDictionary * flovChooseDict = [self.chooseFlovers objectAtIndex:k];
            
            NSString * stringKey = [NSString stringWithFormat:@"tobaccos[%d][feature_id]",k];
            NSString * stringKeyName = [NSString stringWithFormat:@"tobaccos[%d][feature_id_name]",k];
            if(k>0){
                NSString * stringKeyTobacco = [NSString stringWithFormat:@"tobaccos[%d][id]",k];
                [dictTemp setObject:self.toobaccoID forKey:stringKeyTobacco];
                NSString * stringKeyTobaccoName = [NSString stringWithFormat:@"tobaccos[%d][id_name]",k];
                [dictTemp setObject:self.toobaccoName forKey:stringKeyTobaccoName];
                [[SingleTone sharedManager] setDictOrder:dict];
            }
            
            [dictTemp setObject:[flovChooseDict objectForKey:@"id"] forKey:stringKey];
            [dictTemp setObject:[flovChooseDict objectForKey:@"name"] forKey:stringKeyName];
            
          
            
            self.countTabaco +=1;
        }
        
        [[SingleTone sharedManager] setDictOrder:dictTemp];
        
        
        
        [self.navigationController popToViewController:controller animated:YES];
        
    } else {
        
        NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
        
        
        
        for(int i=0; i < self.chooseFlovers.count; i++){
            
            NSDictionary * flovChooseDict = [self.chooseFlovers objectAtIndex:i];
            NSString * stringKey = [NSString stringWithFormat:@"tobaccos[%d][feature_id]",i];
            NSString * stringKeyName = [NSString stringWithFormat:@"tobaccos[%d][feature_id_name]",i];
            if(i>0){
                NSString * stringKeyTobacco = [NSString stringWithFormat:@"tobaccos[%d][id]",i];
                [dict setObject:self.toobaccoID forKey:stringKeyTobacco];
                NSString * stringKeyTobaccoName = [NSString stringWithFormat:@"tobaccos[%d][id_name]",i];
                [dict setObject:self.toobaccoName forKey:stringKeyTobaccoName];
                [[SingleTone sharedManager] setDictOrder:dict];
            }
            
            [dict setObject:[flovChooseDict objectForKey:@"id"] forKey:stringKey];
            [dict setObject:[flovChooseDict objectForKey:@"name"] forKey:stringKeyName];
            
            
            
            
            self.countTabaco +=1;
        }
        
        [[SingleTone sharedManager] setDictOrder:dict];
        
        
        ChooseOtherController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseOtherController"];
        detail.outletID = self.outletID;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flavorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"Cell";
    
    NSDictionary * dict = [self.flavorArray objectAtIndex:indexPath.row];
    ChooseFlavorCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    cell.labelName.text = [dict objectForKey:@"name"];
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
    
    NSDictionary * dict = [self.flavorArray objectAtIndex:indexPath.row];

    if ([swich isOn]) {
        swich.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"imageSwitchOn"]];
         [self.chooseFlovers addObject:dict];
    } else {
        swich.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"imageSwitchOff"]];
         [self.chooseFlovers removeObject:dict];
    }
    
    
   
    
    [self.mArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:swich.on]];
    
    if (swich.on) {
        self.countFlavor ++;
    } else {
        self.countFlavor --;
    }
    
    if(self.countFlavor>0){
        self.labelFlovers.alpha = 1.f;
    }else{
        self.labelFlovers.alpha = 0.f;
    }
    
    NSLog(@"MAXXXX %@ CURRENT %ld",self.maximumNumberOfFeatures,self.countFlavor);
    if(![self.maximumNumberOfFeatures isEqual:[NSNull null]]){
        if(([self.maximumNumberOfFeatures integerValue]  < self.countFlavor) && [self.maximumNumberOfFeatures integerValue] !=0){
            [self showAlertWithMessage:
             [NSString stringWithFormat:@"Нельзя выбрать более %@ вкусов", self.maximumNumberOfFeatures]];
        }
        
    }
    
    if (self.countFlavor > 0) {
        self.darkViewForButtonNext.alpha = 0.f;
    } else {
        self.darkViewForButtonNext.alpha = 0.4f;
    }
}


@end
