//
//  MenuBarController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 09.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MenuBarController.h"
#import "MenuBarModel.h"

@interface MenuBarController ()

@property (strong, nonatomic) NSArray * mainArray;

@end

@implementation MenuBarController

- (void) loadView {
    [super loadView];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIColor * color = [UIColor hx_colorWithHexRGBAString:@"272a2a"];
    self.tabBar.barTintColor = [color colorWithAlphaComponent:0.4];
    
    self.mainArray = [MenuBarModel setArray];
    
    for (int i = 0; i < self.mainArray.count; i++) {
        
        NSDictionary * dictData = [self.mainArray objectAtIndex:i];
        
        
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        
        UIImage *imageOff = [UIImage imageNamed:[dictData objectForKey:@"imageOFF"]];
        UIImage *imageOn = [UIImage imageNamed:[dictData objectForKey:@"imageON"]];
        imageOff = [imageOff imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        imageOn = [imageOn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = imageOn;
        item.selectedImage = imageOff;
        item.title = [dictData objectForKey:@"text"];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];        
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
