//
//  AppDelegate.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInformationTable.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "HexColors.h"
@import GoogleMaps;

@interface AppDelegate ()
@property (strong, nonatomic) UserInformationTable * selectedDataObject;
@property (strong, nonatomic) RLMResults *tableDataArray;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SharesController"];
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = vc;
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = nil;
    }
    
    [GMSServices provideAPIKey:@"AIzaSyBNLE56vAD8zI_tkryadJkOJ4r7TMLi_lM"];
    
    [self checkToken];
    NSLog(@"CURRENT %@",[NSDate date]);
    
    [[SingleTone sharedManager] setChangeCountry:NO];
    [[SingleTone sharedManager] setDictOrder:[@{} mutableCopy]];
    [[SingleTone sharedManager] setStringFlavor:@""];
    [[SingleTone sharedManager] setStringOther:@""];
    [[SingleTone sharedManager] setCountry:@""];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) checkToken{
    self.tableDataArray=[UserInformationTable allObjects];
    if (self.tableDataArray.count >0 ){
        self.selectedDataObject = [self.tableDataArray objectAtIndex:0];
         NSLog(@"FETCH %@",self.selectedDataObject);
        
        NSString * token = self.selectedDataObject.token;
        NSString * cityID = self.selectedDataObject.city_id;
        [[SingleTone sharedManager] setToken:token];
        [[SingleTone sharedManager] setCityID:cityID];
        NSLog(@"TOKENS %@", token);
        
        APIManger * apiManager = [[APIManger alloc] init];
        
        [apiManager getDataFromSeverWithMethod:@"visitor.validateToken" andParams:nil andToken:token
                                                                               complitionBlock:^(id response) {
            NSDictionary * respDict = [response objectForKey:@"response"];
            NSLog(@"RESPONSE %@",response);
        if ([[response objectForKey:@"error_code"] integerValue] == 2){
            NSLog(@"ERROR TOKEN");
            [self authCheck:NO andState:@"0"];
        }else{
            if ([[respDict objectForKey:@"state"] integerValue] == 0){
                [self authCheck:YES andState:@"0"];
            }else if ([[respDict objectForKey:@"state"] integerValue] == 1){
                [self authCheck:YES andState:@"1"];
            }else if ([[respDict objectForKey:@"state"] integerValue] == 2){
                [self authCheck:YES andState:@"2"];
            }
        }
            
            //ТУТ нужно условие работы с токеном...
        }];
    }else{
        [self authCheck:NO andState:@""];
    }
}

-(void) authCheck: (BOOL) check andState: (NSString *) state{
    
    NSString * controller;
    if(check){
        if([state integerValue] == 0){
            
            controller = @"RegistrationMainController";
            
        }else if([state integerValue] == 1){
            
            controller = @"CountryController";
            
        }else if([state integerValue] == 2){
           
        
            controller = @"MenuBarController";

            
        }
        
    }else{
        controller = @"LoginPhoneController";
    }
    
    UIViewController * mainController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                         instantiateViewControllerWithIdentifier:controller]; //or the homeController
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}




@end
