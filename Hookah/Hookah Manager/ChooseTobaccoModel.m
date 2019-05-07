//
//  ChooseTobaccoModel.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 01.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseTobaccoModel.h"
#import "APIManger.h"
#import "SingleTone.h"

@implementation ChooseTobaccoModel
@synthesize delegate;

- (void) getArray: (NSString *) outletID andHookahID: (NSString *) hookahID timeBlock: (void (^) (void)) timeBlock {
    
    
    APIManger * apiManager = [[APIManger alloc] init];
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             outletID,@"outlet_id",
                             hookahID,@"hookah_id",nil];
    
    [apiManager getDataFromSeverWithMethod:@"order.getTobaccos" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        
        if([response objectForKey:@"error_code"]){
            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                  [response objectForKey:@"error_msg"]);
            NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
        }else{
            
            if([response isKindOfClass:[NSDictionary class]]){
                NSArray * respArray = [response objectForKey:@"response"];
                
                [self.delegate loadTobacco:respArray];
            }
        }
        timeBlock();
    }];
    
}

-(NSArray *) filtred:(NSArray *) array{
    
    if(self.isFilterText){
        
        array = [array filteredArrayUsingPredicate:
                 [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *d) {
            return [[NSString stringWithFormat:@"%@",[obj valueForKey:@"name"]] rangeOfString:self.filterText].location != NSNotFound;
        }]];
    }
    return array;
    
}

@end
