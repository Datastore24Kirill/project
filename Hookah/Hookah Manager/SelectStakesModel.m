//
//  TesnModelCategory.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 10.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "SelectStakesModel.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "OrganizationTable.h"
#import "OutletTable.h"
#import "UserInformationTable.h"
#import "DateTimeMethod.h"
#import "ScheduleOutletsTable.h"
#import "HelpMethodForOutlets.h"



@implementation SelectStakesModel
@synthesize delegate;


- (NSArray*) setArray {
    
    
    FilterView * filterView = [self.delegate filterView];
    
    NSMutableArray * mainArray = [NSMutableArray array];
    
    RLMResults *orgTableDataArray;
    if(self.isFilterText){
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",
                             self.filterText];
        orgTableDataArray = [OrganizationTable objectsWithPredicate:pred];
        
    }else{
        orgTableDataArray = [OrganizationTable allObjects];
    }
    
    
    if(orgTableDataArray.count >0){
        for (int i = 0; i < orgTableDataArray.count; i++) {
            OrganizationTable * orgTableData = [orgTableDataArray objectAtIndex:i];
            //Перевод строки в число
            NSNumberFormatter *formatNumber = [[NSNumberFormatter alloc] init];
            formatNumber.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *rating;
            if([orgTableData.rating isEqualToString:@"<null>"]){
                rating = [formatNumber numberFromString:@"0"];
            }else{
               rating = [formatNumber numberFromString:orgTableData.rating];
            }
            
         
            //
            
            //Узнаем есть ли избранное
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"orgID = %@ AND isFavorite = %@",
                                 orgTableData.orgID, @"1"];
            RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
            
            
            NSNumber *isFavorite;
            if(outletTableDataArray.count>0){
                isFavorite=[NSNumber numberWithBool:YES];
            }else{
                isFavorite=[NSNumber numberWithBool:NO];
            }
            HelpMethodForOutlets * helpMethod = [[HelpMethodForOutlets alloc] init];
            BOOL isOpen = [helpMethod getScheduleOutlets:orgTableData.orgID];
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              orgTableData.logoURL, @"imageName",
                                              isFavorite, @"bookmark",
                                              rating, @"stars",
                                              [helpMethod getDistance:orgTableData.orgID],@"distance",
                                              orgTableData.name, @"name",
                                              [NSNumber numberWithBool:isOpen],@"isOpen",
                                              orgTableData.orgID,@"orgID", nil];
                
                
                
                if(filterView.buttonBookmark.isBool == YES){
                    if(isFavorite == [NSNumber numberWithBool:YES]){
                        [mainArray addObject:dict];
                    }
                    
                }else{
                    
                    [mainArray addObject:dict];
                }
            
            
            
           
        }
        
        
    }
    
    
    NSArray * resultArray;
   
    
    if(filterView.buttonMap.isBool == YES){
        resultArray = [NSArray arrayWithArray:mainArray];
        if(filterView.buttonOpen.isBool == YES){
            resultArray = [mainArray filteredArrayUsingPredicate:
                           [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *d) {
                return ![[NSString stringWithFormat:@"%@",[obj valueForKey:@"isOpen"]] isEqualToString:@"0"];
            }]];
            
        }
        NSMutableArray *tempArray = [(NSArray*)resultArray mutableCopy];
  
        NSComparator compareDistances = ^(id string1, id string2)
        {
            NSNumber *number1 = [NSNumber numberWithFloat:[string1 floatValue]];
            NSNumber *number2 = [NSNumber numberWithFloat:[string2 floatValue]];
            
            return [number1 compare:number2];
        };
        
        // sort list and create nearest list
        NSSortDescriptor *sortDescriptorNearest = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES comparator:compareDistances];
        NSMutableArray * tempTwoArray = (NSMutableArray *)[tempArray sortedArrayUsingDescriptors:@[sortDescriptorNearest]];
        
        resultArray = [NSArray arrayWithArray:tempTwoArray];
        
    }else{
        
        resultArray = [NSArray arrayWithArray:mainArray];
        if(filterView.buttonOpen.isBool == YES){
            resultArray = [mainArray filteredArrayUsingPredicate:
             [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *d) {
                return ![[NSString stringWithFormat:@"%@",[obj valueForKey:@"isOpen"]] isEqualToString:@"0"];
            }]];
            
        }
        
    }
    
    
   
    
    
    return resultArray;
 
}






-(void) updateOrganizationTable{
    if([[SingleTone sharedManager] token]){
        APIManger * apiManager = [[APIManger alloc] init];
        UserInformationTable * userInformationDataObject = [[UserInformationTable alloc] init];
        
        RLMResults *userTableDataArray =[UserInformationTable allObjects];
        NSString * cityID;
        NSString * orgRequestTime;
        
        if (userTableDataArray.count >0 ){
            userInformationDataObject = [userTableDataArray objectAtIndex:0];
            if(userInformationDataObject.city_id){
                cityID = userInformationDataObject.city_id;
            }else{
                cityID = nil;
            }
            
            
            if(![userInformationDataObject.orgRequestTime isEqualToString:@"(null)"]){
                orgRequestTime = userInformationDataObject.orgRequestTime;
            }else{
                orgRequestTime = @"0";
            }
            
        }else{
            cityID = nil;
            orgRequestTime = @"0";
        }
        
        
        NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:cityID,@"city_id",
                                 orgRequestTime,@"last_request_time",nil];
        if(cityID.length !=0){
            [apiManager getDataFromSeverWithMethod:@"organization.getByCity" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
                
                if([response isKindOfClass:[NSDictionary class]]){
                    NSDictionary * respDict = [response objectForKey:@"response"];
                    
                    NSArray * items = [respDict objectForKey:@"items"];
                    for(int i=0; i<items.count; i++){
                        OrganizationTable * orgTable = [[OrganizationTable alloc] init];
                        NSDictionary * itemDict = [items objectAtIndex:i];
                        if([[itemDict objectForKey:@"is_deleted"] integerValue] == 0){
                            
                            NSString * orgID = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"id"]];
                            NSString * rating = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"rating"]];
                            NSString * isDeleted = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"is_deleted"]];
                            
                            [orgTable insertDataIntoDataBaseWithOrgID:orgID name:[itemDict objectForKey:@"name"] logoURL:[itemDict objectForKey:@"logo_url"] rating:rating isDeleted:isDeleted];
                        }
                        
                    }
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    if([respDict objectForKey:@"request_time"]){
                        userInformationDataObject.orgRequestTime=[NSString stringWithFormat:@"%@",[respDict objectForKey:@"request_time"]];
                    }
                    
                    [realm commitWriteTransaction];
                    [self.delegate setIsLoadOrganization:YES];
                    [self.delegate checkLoadDataBase];
                    
                    
                }
                
            }];
            
            
        }
    }
}

-(void) updateOutletTable {
    if([[SingleTone sharedManager] token]){
        APIManger * apiManager = [[APIManger alloc] init];
        UserInformationTable * userInformationDataObject = [[UserInformationTable alloc] init];
        
        RLMResults *userTableDataArray =[UserInformationTable allObjects];
        NSString * cityID;
        NSString * outletRequestTime;
        
        if (userTableDataArray.count >0 ){
            userInformationDataObject = [userTableDataArray objectAtIndex:0];
            if(userInformationDataObject.city_id){
                cityID = userInformationDataObject.city_id;
            }else{
                cityID = nil;
            }
            
            
            if(![userInformationDataObject.outletRequestTime isEqualToString:@"(null)"]){
                outletRequestTime = userInformationDataObject.outletRequestTime;
            }else{
                outletRequestTime = @"0";
            }
            
            
        }else{
            cityID = nil;
            outletRequestTime = @"0";
        }
        
        NSDictionary * paramsOutlet = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       cityID, @"city_id",
                                       outletRequestTime, @"last_request_time", nil];
        
        if(cityID.length !=0){
            [apiManager getDataFromSeverWithMethod:@"outlet.getByCity" andParams:paramsOutlet andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
                
                if([response isKindOfClass:[NSDictionary class]]){
                    NSDictionary * respDict = [response objectForKey:@"response"];
                    
                    NSArray * items = [respDict objectForKey:@"items"];
                    for(int i=0; i<items.count; i++){
                        OutletTable * outletTable = [[OutletTable alloc] init];
                        NSDictionary * itemDict = [items objectAtIndex:i];
                        if([[itemDict objectForKey:@"is_deleted"] integerValue] == 0){
                            
                            NSString * outletID = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"id"]];
                            NSString * orgID = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"organization_id"]];
                            NSString * isFavorite = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"is_favourite"]];
                            NSString * lat = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"lat"]];
                            NSString * lon = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"lon"]];
                            NSString * useMix = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"use_mix"]];
                            NSString * useTaste = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"use_taste"]];
                            NSString * rating = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"rating"]];
                            NSString * isDeleted = [NSString stringWithFormat:@"%@",[itemDict objectForKey:@"is_deleted"]];
                            
                            [outletTable insertDataIntoDataBaseWithOutletID:outletID orgID:orgID name:[itemDict objectForKey:@"name"] rating:rating isFavorite:isFavorite address:[itemDict objectForKey:@"address"] lat:lat lon:lon useMix:useMix useTaste:useTaste isDeleted:isDeleted];
                        }
                    }
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    if([respDict objectForKey:@"request_time"]){
                        userInformationDataObject.outletRequestTime=[NSString stringWithFormat:@"%@",[respDict objectForKey:@"request_time"]];
                    }
                    
                    [realm commitWriteTransaction];
                    
                    NSString * dateTimestamp =[DateTimeMethod dateToTimestamp:[self getLocalDate]];
                    
                    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [[SingleTone sharedManager] cityID],@"city_id",
                                             dateTimestamp,@"day_time",nil];
                    
                    [apiManager getDataFromSeverWithMethod:@"outlet.getScheduleByCity" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
                        NSLog(@"PARAMS %@ SHED %@",params,response);
                        if([response objectForKey:@"error_code"]){
                            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                                  [response objectForKey:@"error_msg"]);
                            NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                            
                            
                            
                        }else{
                            if([response isKindOfClass:[NSDictionary class]]){
                                
                                NSDictionary * respDict = [response objectForKey:@"response"];
                                NSArray * arrayItems = [respDict objectForKey:@"items"];
                                for(int i=0; i<arrayItems.count; i++){
                                    NSDictionary * dictItems = [arrayItems objectAtIndex:i];
                                    ScheduleOutletsTable * sheduleTable = [[ScheduleOutletsTable alloc] init];
                                    
                                    NSString * close = [DateTimeMethod timeFormattedHHMM:[[dictItems objectForKey:@"close"] intValue]];
                                    NSString * open = [DateTimeMethod timeFormattedHHMM:[[dictItems objectForKey:@"open"] intValue]];
                                    
                                    [sheduleTable insertDataIntoDataBaseWithOutletID:[NSString stringWithFormat:@"%@",[dictItems objectForKey:@"outlet_id"]] open:open close:close];
                                }
                            }
                        }
                        
                        [self.delegate setIsLoadOoutlet:YES];
                        [self.delegate checkLoadDataBase];
                        
                    }];
                    
                   
                }
                
            }];
        }
        
    }
    
}

-(NSDate *) getLocalDate {
    NSString* format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    // Set up an NSDateFormatter for UTC time zone
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Cast the input string to NSDate
    NSDate* utcDate = [NSDate date];
    
    // Set up an NSDateFormatter for the device's local time zone
    NSDateFormatter* formatterLocal = [[NSDateFormatter alloc] init];
    [formatterLocal setDateFormat:format];
    [formatterLocal setTimeZone:[NSTimeZone localTimeZone]];
    
    // Create local NSDate with time zone difference
    NSDate* localDate = [formatterUtc dateFromString:[formatterLocal stringFromDate:utcDate]];
    
    return localDate;
}





@end
