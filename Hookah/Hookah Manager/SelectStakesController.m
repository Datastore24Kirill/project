//
//  SelectStakesController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 09.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "SelectStakesController.h"
#import "SelectStakesModel.h"
#import "UserInformationTable.h"
#import "HookahDetailsController.h"
#import "SingleTone.h"
#import "Macros.h"
#import "CustomButton.h"

@interface SelectStakesController () <SelectStakesModelDelegate, UITextFieldDelegate, FilterViewDelegate>


@property (assign, nonatomic) CGFloat cellHeight;
@property (strong, nonatomic) SelectStakesModel * selectStakesModel;
@property (assign, nonatomic) CGPoint scrollViewOffset;


@property (assign, nonatomic) CGFloat heightKeyboard;



@end

@implementation SelectStakesController

- (void) loadView {
    [super loadView];
    
    self.mainScrollView.userInteractionEnabled = YES;
    
//    [self setCustomTitle: @"Выберите кальянную"];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    UIImage *myImage = [UIImage imageNamed:@"filterImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(testMethod:)];
    self.navigationItem.rightBarButtonItem = menuButton;
    [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];

    
    
    
    
    self.navView = [[NavSearch alloc]initWithFrame:
                       CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 24.0)];
    self.navView.textFildSearch.delegate = self;
    self.navigationItem.titleView = self.navView;
    
    self.filterView = [[FilterView alloc] initWithFrame:CGRectMake(0.f, 64.f, CGRectGetWidth(self.view.bounds), 1)];
    self.filterView.delegate = self;
    [self.view addSubview:self.filterView];

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myNotificationMethod:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFildNotificationMethod:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.navView.textFildSearch];
    
    
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    for(UIView * view in self.mainScrollView.subviews) {
        
        [view removeFromSuperview];
        
    }
    self.selectStakesModel = [SelectStakesModel new];
    self.selectStakesModel.delegate = self;
    
    if([self checkCity]){
        if(!self.isLoadOoutlet && !self.isLoadOrganization){
            
            [self.selectStakesModel updateOutletTable];
            [self.selectStakesModel updateOrganizationTable];
            [self createActivitiIndicatorAlertWithView];
        }else{
         
            
            [self loadViewFromDataBase:[self.selectStakesModel setArray]];
        }
        
    }else{
        [self goBackToCountry];
    }
    
    [[self mainScrollView] setContentOffset:self.scrollViewOffset animated:NO];
    
}

#pragma mark - Data Base

- (void) checkLoadDataBase{
    //Узнаем есть ли избранное

    
    [self deleteActivitiIndicator];
    if(self.isLoadOoutlet && self.isLoadOrganization){
    
        [self loadViewFromDataBase:[self.selectStakesModel setArray]];
       
    }
}

-(void) loadViewFromDataBase:(NSArray *) mainArray {
    

    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 0.f);
    self.mainArrayData = mainArray;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < self.mainArrayData.count; i++) {
        
        
        NSDictionary * dict = [self.mainArrayData objectAtIndex:i];
        
        SelectCategoryView * view = [[SelectCategoryView alloc] initWithPoint:CGPointMake(0.f, 0.f)
                                                                 andMainImage:[dict objectForKey:@"imageName"]
                                                                  andBookmark:[[dict objectForKey:@"bookmark"] boolValue]
                                                               andNumberStars:[[dict objectForKey:@"stars"] integerValue]
                                                                      andName:[dict objectForKey:@"name"]
                                                                     andOrgID:[dict objectForKey:@"orgID"]];
        view.frame = CGRectMake(0 + CGRectGetWidth(view.bounds) * x,
                                0 + CGRectGetHeight(view.bounds) * y,
                                CGRectGetWidth(view.bounds),
                                CGRectGetHeight(view.bounds));

        view.delegate = self;
        
        if (self.cellHeight == 0) {
            self.cellHeight = CGRectGetHeight(view.bounds);
        }
        
        [self.mainScrollView addSubview:view];
        
            x += 1;
            if (x > 1) {
                x = 0;
                y += 1;
        }
    }
    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, (y + 1) * self.cellHeight);
    
    self.heightKeyboard = self.mainScrollView.contentSize.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Actions

- (void) testMethod: (UIButton*) button {
    NSLog(@"sendmail");
}

- (void) actionCancel: (UIBarButtonItem*) button {
    
    NSLog(@"Cancel");
    
    [self.navView.textFildSearch resignFirstResponder];
    self.navView.textFildSearch.text = @"";
    self.filterView.buttonBookmark.isBool = NO;
    self.filterView.buttonMap.isBool = NO;
    self.filterView.buttonOpen.isBool = NO;
    [self.selectStakesModel setIsFilterText:NO];
    
    [[SingleTone sharedManager] setIsMapFilter:NO];
    [[SingleTone sharedManager] setIsOpenFilter:NO];
    [[SingleTone sharedManager] setIsFavoriteFilter:NO];
    
    self.filterView.imageBookmark.image = [UIImage imageNamed:@"bookmarkImageOff"];
    self.filterView.imageMap.image = [UIImage imageNamed:@"MapImageOff"];
    self.filterView.imageOpen.image = [UIImage imageNamed:@"HistoryImageOff"];
    for(UIView * view in self.mainScrollView.subviews){
        [view removeFromSuperview];
    }
    [self loadViewFromDataBase:[self.selectStakesModel setArray]];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
}

#pragma mark - SelectCategoryViewDelegate

- (void) actionSelectCategoryView: (SelectCategoryView*) selectCategoryView andButton: (UIButton*) sender {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navView.textFildSearch resignFirstResponder];
    HookahDetailsController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HookahDetailsController"];
    detail.titleName = selectCategoryView.titleName;
    detail.orgID = selectCategoryView.orgID;
    detail.starCount = selectCategoryView.starCount;
    detail.imageStingURL = selectCategoryView.imageStingURL;
    [self setScrollViewOffset:self.mainScrollView.contentOffset];
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

#pragma mark - Other

-(void) goBackToCountry{
    [self deleteActivitiIndicator];
    UIViewController * mainController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                         instantiateViewControllerWithIdentifier:@"CountryController"]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainController];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:navController];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    
}

-(BOOL)checkCity{
    UserInformationTable * userInformationDataObject = [[UserInformationTable alloc] init];
    RLMResults *userTableDataArray =[UserInformationTable allObjects];
    
    if (userTableDataArray.count >0 ){
        userInformationDataObject = [userTableDataArray objectAtIndex:0];
        if(userInformationDataObject.city_id.length != 0){
            [[SingleTone sharedManager] setCityID:userInformationDataObject.city_id];
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
   
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rectScroll = self.mainScrollView.frame;
        rectScroll.origin.y += 49;
        self.mainScrollView.frame = rectScroll;
        
        CGRect filterFrame = self.filterView.frame;
        filterFrame.size.height += 49;
        self.filterView.frame = filterFrame;
        
    }];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)];
    [menuButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:14], NSFontAttributeName,
                                        [UIColor hx_colorWithHexRGBAString:@"bababa"], NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = menuButton;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rectScroll = self.mainScrollView.frame;
        rectScroll.origin.y -= 49;
        self.mainScrollView.frame = rectScroll;
        
        CGRect filterFrame = self.filterView.frame;
        filterFrame.size.height -= 49;
        self.filterView.frame = filterFrame;
        
        self.mainScrollView.contentSize = CGSizeMake(0, self.heightKeyboard);
        
    }];
    
    UIImage *myImage = [UIImage imageNamed:@"filterImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(testMethod:)];
    self.navigationItem.rightBarButtonItem = menuButton;
}

#pragma mark - FilterViewDelegate

- (void) actionButtonBookMark: (FilterView*) filterView andButton: (CustomButton*) sender {
    
    if (!sender.isBool) {
        
            filterView.imageBookmark.image = [UIImage imageNamed:@"bookmarkImageOn"];
       
        
        sender.isBool = YES;
        [[SingleTone sharedManager] setIsFavoriteFilter:YES];
        NSLog(@"SINGLETON %d",[[SingleTone sharedManager] isFavoriteFilter]);
        
        for(UIView * view in self.mainScrollView.subviews){
            [view removeFromSuperview];
        }
        self.mainArrayData = [self.selectStakesModel setArray];
        [self loadViewFromDataBase:self.mainArrayData];
        
        
    } else {

        
           filterView.imageBookmark.image = [UIImage imageNamed:@"bookmarkImageOff"];
        
        sender.isBool = NO;
        [[SingleTone sharedManager] setIsFavoriteFilter:NO];
        
        self.mainArrayData = [self.selectStakesModel setArray];
        for(UIView * view in self.mainScrollView.subviews){
            [view removeFromSuperview];
        }
        self.mainArrayData = [self.selectStakesModel setArray];
        [self loadViewFromDataBase:self.mainArrayData];
        
    }
    
}
- (void) actionButtonMap: (FilterView*) filterView andButton: (CustomButton*) sender {
    
    if (!sender.isBool) {
        
            filterView.imageMap.image = [UIImage imageNamed:@"MapImageOn"];
        
        sender.isBool = YES;
        [[SingleTone sharedManager] setIsMapFilter:YES];
        
        for(UIView * view in self.mainScrollView.subviews){
            [view removeFromSuperview];
        }
        self.mainArrayData = [self.selectStakesModel setArray];
        [self loadViewFromDataBase:self.mainArrayData];
    } else {
        
            filterView.imageMap.image = [UIImage imageNamed:@"MapImageOff"];
        
        sender.isBool = NO;
        [[SingleTone sharedManager] setIsMapFilter:NO];
        
        self.mainArrayData = [self.selectStakesModel setArray];
        for(UIView * view in self.mainScrollView.subviews){
            [view removeFromSuperview];
        }
        self.mainArrayData = [self.selectStakesModel setArray];
        [self loadViewFromDataBase:self.mainArrayData];

    }
    
}
- (void) actionButtonOpen: (FilterView*) filterView andButton: (CustomButton*) sender {
    
    if (!sender.isBool) {
        
            filterView.imageOpen.image = [UIImage imageNamed:@"HistoryImageOn"];
    
        sender.isBool = YES;
        [[SingleTone sharedManager] setIsOpenFilter:YES];
        
        for(UIView * view in self.mainScrollView.subviews){
            [view removeFromSuperview];
        }
        self.mainArrayData = [self.selectStakesModel setArray];
        [self loadViewFromDataBase:self.mainArrayData];
    } else {
        
            filterView.imageOpen.image = [UIImage imageNamed:@"HistoryImageOff"];
        
        sender.isBool = NO;
        [[SingleTone sharedManager] setIsOpenFilter:NO];
        
        self.mainArrayData = [self.selectStakesModel setArray];
        for(UIView * view in self.mainScrollView.subviews){
            [view removeFromSuperview];
        }
        self.mainArrayData = [self.selectStakesModel setArray];
        [self loadViewFromDataBase:self.mainArrayData];
    }
    
}

#pragma mark - NotificationKeyboard 

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    
    self.mainScrollView.contentSize = CGSizeMake(0, self.heightKeyboard + keyboardFrameBeginRect.size.height);
    
}

- (void) textFildNotificationMethod: (NSNotification*) notification {
    
    UITextField * textFild = notification.object;
    
    NSLog(@"%@", textFild.text); ///Вывод текст с текст филда
    
    
    if(textFild.text.length>2){
       
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.4f
                                                          target:[NSBlockOperation blockOperationWithBlock:^{
            for(UIView * view in self.mainScrollView.subviews){
                [view removeFromSuperview];
            }
            
            [self.selectStakesModel setIsFilterText:YES];
            [self.selectStakesModel setFilterText:textFild.text];
            self.mainArrayData = [self.selectStakesModel setArray];
            [self loadViewFromDataBase:self.mainArrayData];
                            }]
                                                        selector:@selector(main)
                                                        userInfo:nil
                                                         repeats:NO
                          ];
        
        
        
        
    }else if(textFild.text.length<=2){
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.4f
                                                          target:[NSBlockOperation blockOperationWithBlock:^{
            for(UIView * view in self.mainScrollView.subviews){
                [view removeFromSuperview];
            }
            [self.selectStakesModel setIsFilterText:NO];
            
            self.mainArrayData = [self.selectStakesModel setArray];
            [self loadViewFromDataBase:self.mainArrayData];
        }]
                                                        selector:@selector(main)
                                                        userInfo:nil
                                                         repeats:NO
                          ];

        
      
    }
    
    
    
}

@end
