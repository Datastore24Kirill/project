//
//  OtherModel.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 31.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "OtherModel.h"
#import "APIManger.h"
#import "SingleTone.h"


@implementation OtherModel
@synthesize delegate;

-(void)loadProfile{
    APIManger * apiManager = [[APIManger alloc] init];
    [apiManager getDataFromSeverWithMethod:@"visitor.getProfile" andParams:nil andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        NSLog(@"RESPORDER %@",response);
        if([response objectForKey:@"error_code"]){
            
        }else{
            [self.delegate loadDefault:[response objectForKey:@"response"]];
        }
    }];
}
@end
