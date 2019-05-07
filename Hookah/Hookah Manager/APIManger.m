//
//  APIManger.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "APIManger.h"
#import <AFNetworking/AFNetworking.h>

@implementation APIManger
//Информация о пользователе
- (void) getDataFromSeverWithMethod: (NSString *) method andParams: (NSDictionary *) params andToken: (NSString *) token complitionBlock: (void (^) (id response)) compitionBack{
    
    
    
    //-----------
    NSString * url = [NSString stringWithFormat:@"http://api.hookahmanager.ru/v1/%@?token=%@",method,token];
    
    //    NSLog(@"URL: %@",url);
    NSString * encodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    //-------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //Запрос
    [manager GET: encodedURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Вызов блока
        compitionBack (responseObject);
        //Ошибки
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) postDataFromSeverWithMethod: (NSString *) method andParams: (NSDictionary *) params andToken: (NSString *) token complitionBlock: (void (^) (id response)) compitionBack{
    
    
    
    //-----------
    NSString * url = [NSString stringWithFormat:@"http://api.hookahmanager.ru/v1/%@?token=%@",method,token];
    
    //    NSLog(@"URL: %@",url);
    NSString * encodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    //-------------------
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //Запрос
    [manager POST:encodedURL parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        compitionBack (responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
    
}
@end
