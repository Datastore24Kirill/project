//
//  CitiesModel.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "CitiesModel.h"
#import "APIManger.h"
#import "SingleTone.h"

@implementation CitiesModel

@synthesize delegate;

- (void) getCityArrayToTableView: (NSString *) countryID andCompitionBack: (void (^) (void)) compitionBack {
    APIManger * apiManager = [[APIManger alloc] init];
    NSDictionary * params;
    
    if ([[SingleTone sharedManager] changeCountry]) {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:countryID,@"country_id", nil];
    } else {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:countryID,@"country_id", nil];
    }

    [apiManager getDataFromSeverWithMethod:@"geo.getCities" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        if([[response objectForKey:@"response"] isKindOfClass:[NSArray class]]){
            
            [self.delegate setArrayCities:[response objectForKey:@"response"]];
            [self.delegate reloadTable];
            compitionBack();
            
        }else{
            NSLog(@"CITY %@",response);
        }
        
        
        
    }];
}
@end
