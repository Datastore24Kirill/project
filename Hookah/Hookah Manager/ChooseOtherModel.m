//
//  ChooseOtherModel.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 28.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseOtherModel.h"
#import "APIManger.h"
#import "SingleTone.h"

@implementation ChooseOtherModel
@synthesize delegate;

- (void) getArray: (NSString *) outletID timeBlock: (void (^) (void)) timeBlock {
    APIManger * apiManager = [[APIManger alloc] init];
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             outletID,@"outlet_id",nil];
    
    [apiManager getDataFromSeverWithMethod:@"order.getOther" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        
        if([response objectForKey:@"error_code"]){
            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                  [response objectForKey:@"error_msg"]);
            NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
            
            
        }else{
            
            if([response isKindOfClass:[NSDictionary class]]){
                NSArray * respArray = [response objectForKey:@"response"];
                
                [self.delegate loadOther:respArray];
                
            }
            
        }
        
        timeBlock();
    }];
}
@end
