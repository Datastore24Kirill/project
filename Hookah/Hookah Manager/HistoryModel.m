//
//  HistoryModel.m
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "HistoryModel.h"
#import "APIManger.h"
#import "SingleTone.h"

@implementation HistoryModel
@synthesize  delegate;
- (void) getVisitorOrders {
    
    
    
    APIManger * apiManager = [[APIManger alloc] init];
    [apiManager getDataFromSeverWithMethod:@"order.getVisitorOrders" andParams:nil andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
       
        if([response objectForKey:@"error_code"]){
            
        }else{
            if([[response objectForKey:@"response"] isKindOfClass:[NSDictionary class]]){
                NSDictionary * respDict = [response objectForKey:@"response"];
                NSArray * items = [respDict objectForKey:@"items"];
                NSMutableArray * currentOrder = [NSMutableArray new];
                NSMutableArray * finishOrder = [NSMutableArray new];
                
                
                for(int i=0; i < items.count; i++){
                    NSDictionary * itemsDict = [items objectAtIndex:i];
                    if([[itemsDict objectForKey:@"status"] integerValue] == 4
                       || [[itemsDict objectForKey:@"status"] integerValue] == 5){
                        [finishOrder addObject:itemsDict];
                    }
                    if([[itemsDict objectForKey:@"status"] integerValue] == 1
                       || [[itemsDict objectForKey:@"status"] integerValue] == 6){
                        [currentOrder addObject:itemsDict];
                    }
                }
                
                [self.delegate loadDefault:currentOrder finishOrder:finishOrder];
            }
        }
    }];
    
}

+ (NSArray*) setHistoryPastModel {
    
    NSMutableArray * mArray = [NSMutableArray array];
    
    NSArray * arrayName = [NSArray arrayWithObjects:@"Speakeasy bar \"Хука хаус\"", @"Just Smoke Lounge Bar", @"Speakeasy bar \"Хука хаус\"",  nil];
    NSArray * arrayPrice = [NSArray arrayWithObjects:@"1 400", @"790", @"2560", nil];
    
    for (int i = 0; i < arrayName.count; i++) {
        NSDictionary * dictCell = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [arrayName objectAtIndex:i], @"name",
                                   [arrayPrice objectAtIndex:i], @"price", nil];
        [mArray addObject:dictCell];
    }
    
    NSArray * arrayResult = [NSArray arrayWithArray:mArray];
    return arrayResult;
    
}

@end
