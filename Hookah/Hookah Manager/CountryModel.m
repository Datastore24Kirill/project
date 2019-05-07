//
//  CountryModel.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 30.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "CountryModel.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "CountryController.h"

@interface CountryModel ()

@end

@implementation CountryModel

@synthesize delegate;


- (void) getCountryArrayToTableView: (void (^) (void)) compitionBack {
    APIManger * apiManager = [[APIManger alloc] init];
   

    [apiManager getDataFromSeverWithMethod:@"geo.getCountries" andParams:nil andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
       
        if([[response objectForKey:@"response"] isKindOfClass:[NSArray class]]){
            
            [self.delegate setArrayCountry:[response objectForKey:@"response"]];
            [self.delegate reloadTable];
            compitionBack();
            
        }else{
          NSLog(@"CITY %@",response);
        }
       
        
        
    }];
}
@end
