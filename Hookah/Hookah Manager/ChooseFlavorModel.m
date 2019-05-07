//
//  ChooseFlavorModel.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 28.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseFlavorModel.h"
#import "APIManger.h"
#import "SingleTone.h"


@implementation ChooseFlavorModel
@synthesize delegate;

- (void) getArray: (NSString *) outletID andTobaccoid: (NSString *) tobaccoID timeBlock: (void (^) (void)) timeBlock{
    APIManger * apiManager = [[APIManger alloc] init];
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             outletID,@"outlet_id",
                             tobaccoID,@"tobacco_id",nil];
    
    [apiManager getDataFromSeverWithMethod:@"order.getTobaccoAroma" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        
        if([response objectForKey:@"error_code"]){
            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                  [response objectForKey:@"error_msg"]);
            NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
            
            
        }else{
            
            if([response isKindOfClass:[NSDictionary class]]){
                NSArray * respArray = [response objectForKey:@"response"];
                
                [self.delegate loadFlavor:respArray];
                
            }
            
        }
        
        timeBlock();
        
    }];
}
@end
