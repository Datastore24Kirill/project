//
//  OtherDetailsModel.m
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "OtherDetailsModel.h"
#import "APIManger.h"
#import "SingleTone.h"


@implementation OtherDetailsModel

+ (NSArray*) setArrayOtherDetails {
    
    NSArray * arrayType = [NSArray arrayWithObjects:@"Страна", @"Город", @"Имя", @"Дата рождение", nil];
    
    return arrayType;
    
}

-(void)saveCity: (NSString *) cityID andBlock: (void (^) (id response)) compitionBlock{
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             cityID,@"city_id", nil];
    
    APIManger * apiManager = [[APIManger alloc] init];
    
    [apiManager postDataFromSeverWithMethod:@"visitor.saveCity" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        NSLog(@"RESPONSE %@",response);
        compitionBlock(response);
    }];
    
    
    
}

-(void)saveAll: (NSDictionary *) params andBlock: (void (^) (id response)) compitionBlock{
    
    
    APIManger * apiManager = [[APIManger alloc] init];
    
    [apiManager postDataFromSeverWithMethod:@"visitor.saveProfile" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        NSLog(@"RESPONSE %@",response);
        compitionBlock(response);
    }];
    
    
    
}

@end
