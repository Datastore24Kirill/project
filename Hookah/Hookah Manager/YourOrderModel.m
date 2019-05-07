//
//  YourOrderModel.m
//  Hookah Manager
//
//  Created by Mac_Work on 23.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "YourOrderModel.h"
#import "OutletTable.h"
#import "OrganizationTable.h"
#import "DateTimeMethod.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "HelpMethodForOutlets.h"
#import "MainViewController.h"


@implementation YourOrderModel
@synthesize delegate;

- (NSArray *) setArrayType {

    NSArray * array = [NSArray arrayWithObjects:@"Столик", @"Время", @"Кальян", @"Табак", @"Прочее", nil];
    return array; 
}

- (void) setTestArrayDescription:(BOOL) isHistory andOrderID:(NSString *) orderID {
    NSMutableDictionary * dict;
    if(isHistory){
        
        [self loadOrder:orderID andBlock:^(id response) {
            if([response objectForKey:@"error_code"]){
                NSLog(@"ERROR RESPONSE %@",[response objectForKey:@"error_code"]);
            }else{
                [self.delegate loadArrayDescription:[response objectForKey:@"response"] andHistory:YES];
            }
            
        }];
    }else{
        dict = [[SingleTone sharedManager] dictOrder];
    
        [self.delegate loadArrayDescription:dict andHistory:NO];

    }
 
}


-(void) selectOutlets:(NSString *) outletID {
    
    //Узнаем есть ли избранное
    HelpMethodForOutlets * helpMethod = [[HelpMethodForOutlets alloc] init];
    
    NSLog(@"OUTLET %@ %ld", outletID, outletID.length);
    if(outletID.length != 0){
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"outletID = %@",
                             outletID];
        RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
        
        
        OutletTable * outletTableData = [outletTableDataArray objectAtIndex:0];
        NSLog(@"OUTLLLL %@",outletTableData);
        
        NSString *rating;
        if([outletTableData.rating isEqualToString:@"<null>"]){
            rating = @"0";
        }else{
            rating = [NSString stringWithFormat:@"%@",outletTableData.rating];
        }
        [self.delegate setStarCount:rating];
        
        //Запрашиваем режим работы
        
        
        NSDictionary *openClose = [helpMethod getScheduleOutletOne:outletID];
        NSString * close = [openClose objectForKey:@"close"];
        NSString * open = [openClose objectForKey:@"open"];
        
        
        NSPredicate *predOrg = [NSPredicate predicateWithFormat:@"orgID = %@",
                             outletTableData.orgID];
        RLMResults *orgTableDataArray = [OrganizationTable objectsWithPredicate:predOrg];
        
        
        OrganizationTable * orgTableData = [orgTableDataArray objectAtIndex:0];
        

        [self.delegate loadDefault:outletTableData.address open:open close:close
                        isFavorite:outletTableData.isFavorite andLogoURL: orgTableData.logoURL andRating: outletTableData.rating];
        
        
        
    }else{
        [self.delegate deleteActiviti];
    }
    
}

-(void) loadCoastOrdertimeBlock: (void (^) (void)) timeBlock {
    NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder];
    APIManger * apiManager = [[APIManger alloc] init];
    
    NSLog(@"PARAMSCOAST %@",dict);
    [apiManager postDataFromSeverWithMethod:@"order.getTotal" andParams:dict andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        NSLog(@"RESPCOAST %@",response);
        if([response isKindOfClass:[NSDictionary class]]){
            [self.delegate setTotalCoast:[response objectForKey:@"response"]];
        }
        
        timeBlock();
        
    }];
}

-(void) createOrder: (void (^) (id response)) compitionBlock{
    NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder] ;
    NSMutableDictionary * resultdict = [[[SingleTone sharedManager] dictOrder] mutableCopy];
    [resultdict removeObjectForKey:@"table_name"];
    [resultdict removeObjectForKey:@"hookah_name"];
    
    for(NSString * key in dict){
        
        if([key rangeOfString:@"others_name"].location != NSNotFound) {
            [resultdict removeObjectForKey:key];
        }
        
        if([key rangeOfString:@"feature_id_name"].location != NSNotFound ) {
            [resultdict removeObjectForKey:key];
        }
        
        if([key rangeOfString:@"id_name"].location != NSNotFound ) {
            [resultdict removeObjectForKey:key];
        }
        
    }
    
    
    // original string
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    
    //Время начала
    NSString *strStart = [NSString stringWithFormat:@"%@%@:00",[DateTimeMethod getCurrentDateFormattedHHMMYYYY],[resultdict objectForKey:@"begin_at"]];
    
    NSDateFormatter *dateFormatterStart = [[NSDateFormatter alloc] init];
    [dateFormatterStart setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateStart = [dateFormatterStart dateFromString:strStart];
    
    NSString * startTimeStamp = [DateTimeMethod dateToTimestamp:dateStart];
    [resultdict setObject:startTimeStamp forKey:@"begin_at"];
    //
    
    //Время конца
    NSString *strEnd = [NSString stringWithFormat:@"%@%@:00",[DateTimeMethod getCurrentDateFormattedHHMMYYYY],[resultdict objectForKey:@"end_at"]];
    
    NSDateFormatter *dateFormatterEnd = [[NSDateFormatter alloc] init];
    [dateFormatterEnd setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateEnd = [dateFormatterStart dateFromString:strEnd];
    
    NSString * endTimeStamp = [DateTimeMethod dateToTimestamp:dateEnd];
    [resultdict setObject:endTimeStamp forKey:@"end_at"];
    //
    
//
    
    NSLog(@"DICTIONARY %@",resultdict);
    
    
    
    APIManger * apiManager = [[APIManger alloc] init];
    [apiManager postDataFromSeverWithMethod:@"order.createOrder" andParams:resultdict andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        if([response objectForKey:@"error_code"]){
            compitionBlock(response);
        }else{
            compitionBlock(response);
        }
        NSLog(@"RESPONSE %@",response);
    }];
}

-(void)cancelOrder: (NSString *) orderID andBlock: (void (^) (id response)) compitionBlock{
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             orderID,@"id", nil];
    
    APIManger * apiManager = [[APIManger alloc] init];
    
    [apiManager getDataFromSeverWithMethod:@"order.cancelOrder" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        if([response objectForKey:@"error_code"]){
            compitionBlock(response);
        }else{
            compitionBlock(response);
        }
        NSLog(@"RESPONSE %@",response);
    }];
    
}

-(void) updateOrder:(NSString *) orderID andBlock: (void (^) (id response)) compitionBlock{
    NSMutableDictionary * dict = [[SingleTone sharedManager] dictOrder] ;
    NSMutableDictionary * resultdict = [[[SingleTone sharedManager] dictOrder] mutableCopy];
    [resultdict removeObjectForKey:@"table_name"];
    [resultdict removeObjectForKey:@"hookah_name"];
    
    for(NSString * key in dict){
        
        if([key rangeOfString:@"others_name"].location != NSNotFound) {
            [resultdict removeObjectForKey:key];
        }
        
        if([key rangeOfString:@"feature_id_name"].location != NSNotFound ) {
            [resultdict removeObjectForKey:key];
        }
        
        if([key rangeOfString:@"id_name"].location != NSNotFound ) {
            [resultdict removeObjectForKey:key];
        }
        
    }
    
    
    // original string

    
    
    //Время начала
    NSString *strStart = [NSString stringWithFormat:@"%@%@:00",[DateTimeMethod getCurrentDateFormattedHHMMYYYY],[resultdict objectForKey:@"begin_at"]];
    
    NSDateFormatter *dateFormatterStart = [[NSDateFormatter alloc] init];
    [dateFormatterStart setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateStart = [dateFormatterStart dateFromString:strStart];
    
    NSString * startTimeStamp = [DateTimeMethod dateToTimestamp:dateStart];
    [resultdict setObject:startTimeStamp forKey:@"begin_at"];
    //
    
    //Время конца
    NSString *strEnd = [NSString stringWithFormat:@"%@%@:00",[DateTimeMethod getCurrentDateFormattedHHMMYYYY],[resultdict objectForKey:@"end_at"]];
    
    NSDateFormatter *dateFormatterEnd = [[NSDateFormatter alloc] init];
    [dateFormatterEnd setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateEnd = [dateFormatterStart dateFromString:strEnd];
    
    NSString * endTimeStamp = [DateTimeMethod dateToTimestamp:dateEnd];
    [resultdict setObject:endTimeStamp forKey:@"end_at"];
    //
    
    //
    
    NSLog(@"DICTIONARY %@",resultdict);
    [resultdict setObject:orderID forKey:@"id"];
    
    
    APIManger * apiManager = [[APIManger alloc] init];
    [apiManager postDataFromSeverWithMethod:@"order.updateOrder" andParams:resultdict andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        if([response objectForKey:@"error_code"]){
            compitionBlock(response);
        }else{
            compitionBlock(response);
        }
        NSLog(@"RESPONSE %@",response);
    }];
}

-(void)loadOrder: (NSString *) orderID andBlock: (void (^) (id response)) compitionBlock{
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             orderID,@"id", nil];
    NSLog(@"PARAMS1 %@",params);
    APIManger * apiManager = [[APIManger alloc] init];
    
    [apiManager getDataFromSeverWithMethod:@"order.getOrder" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        NSLog(@"RESPONSE1 %@",response);
        compitionBlock(response);
        
        
    }];
    
}

@end
