//
//  MapModel.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 27.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MapModel.h"
#import "ScheduleOutletsTable.h"
#import "SingleTone.h"
#import "OrganizationTable.h"

@implementation MapModel

-(NSArray *)loadOutletsToMap: (NSString *) outletID {
    
    RLMResults * outletTableArray;
    if(outletID.length == 0){
       outletTableArray = [OutletTable allObjects];
    }else{
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"outletID = %@",
                             outletID];
        outletTableArray = [OutletTable objectsWithPredicate:pred];
    }
    
  
    NSMutableArray * mainArray = [NSMutableArray new];
    for(int i = 0; i<outletTableArray.count; i++){
        OutletTable * outletTableInfo = [outletTableArray objectAtIndex:i];
        
        BOOL isOpen = [self getScheduleOutlets:outletTableInfo.outletID];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               outletTableInfo.name,@"name",
                               outletTableInfo.lat,@"lat",
                               outletTableInfo.lon,@"lon",
                               [NSNumber numberWithBool:isOpen], @"isOpen",
                               outletTableInfo.isFavorite,@"isFavorite",
                               [self getScheduleOutlets:outletTableInfo.outletID],@"scheduleOutlet",
                               outletTableInfo.rating,@"rating",
                               outletTableInfo.outletID,@"outletID",
                               outletTableInfo.orgID,@"orgID",
                               [self getOrgImageURL:outletTableInfo.orgID], @"orgImage",
                               [self getDistance:outletTableInfo.outletID],@"distance",nil];
        
        
        
        if([[SingleTone sharedManager] isFavoriteFilter]){
            if([[dict objectForKey:@"isFavorite"] integerValue] == 1){
                [mainArray addObject:dict];
            }
        }else{
            [mainArray addObject:dict];
        }
        
        
        
        
    }
    
     NSArray * resultArray;
    
    
    
     if([[SingleTone sharedManager] isMapFilter]){
         resultArray = [NSArray arrayWithArray:mainArray];
         if([[SingleTone sharedManager] isOpenFilter]){
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
     if([[SingleTone sharedManager] isOpenFilter]){
     resultArray = [mainArray filteredArrayUsingPredicate:
     [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *d) {
     return ![[NSString stringWithFormat:@"%@",[obj valueForKey:@"isOpen"]] isEqualToString:@"0"];
     }]];
     
     }
     
     }
     
    
    
    return resultArray;
    
}

-(BOOL) getScheduleOutletsisOpen: (NSString *) outletID{
    
    
    
    NSString * close;
    NSString * open;
    
    
    RLMResults *outletFullTableDataArray = [ScheduleOutletsTable allObjects];
    
    
    for(int i=0; i<outletFullTableDataArray.count; i++){
        ScheduleOutletsTable * dictItems = [outletFullTableDataArray objectAtIndex:i];
        
        close = dictItems.close;
        open = dictItems.open;
        
        
        
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"outletID = %@",
                             outletID];
        RLMResults *outletFullTableDataArray = [OutletTable objectsWithPredicate:pred];
        for(int i=0; i<outletFullTableDataArray.count; i++){
            OutletTable * outletTableData = [outletFullTableDataArray objectAtIndex:i];
            if([dictItems.outletID integerValue] == [outletTableData.outletID integerValue]){
                
                
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"HH:mm";
                // ignore time zone of device
                formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                
                NSDate *openDate = [formatter dateFromString:open];
                NSDate *closeDate = [formatter dateFromString:close];
                
                //                            NSDate *now   = [NSDate date];
                
                
                //
                NSDate* currentDate = [self getLocalDate];
                NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
                
                NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:[NSDate date]];
                NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
                
                NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
                NSDate* now = [[NSDate alloc] initWithTimeInterval:interval sinceDate:[NSDate date]];
                NSString *stringFromNowDate = [formatter stringFromDate:now];
                
                NSDate *nowDate = [formatter dateFromString:stringFromNowDate];
                //
                
                
                //Добавляем дату
                if([nowDate compare: openDate] == NSOrderedAscending){
                    
                    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                    dayComponent.day = 1;
                    
                    NSCalendar *theCalendar = [NSCalendar currentCalendar];
                    NSDate *nextDateNow = [theCalendar dateByAddingComponents:dayComponent toDate:nowDate options:0];
                    nowDate = nextDateNow;
                    
                }
                
                if([closeDate compare:openDate] == NSOrderedAscending){
                    
                    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                    dayComponent.day = 1;
                    
                    NSCalendar *theCalendar = [NSCalendar currentCalendar];
                    NSDate *nextDateClose = [theCalendar dateByAddingComponents:dayComponent toDate:closeDate options:0];
                    closeDate = nextDateClose;
                    
                }
                
                
                
                
                
                
                BOOL inBetween = ([nowDate compare:openDate] == NSOrderedDescending
                                  && [nowDate compare:closeDate] == NSOrderedAscending);
                
                return inBetween;
                
                
            }
            
        }
        
    }
    return NO;
}

-(NSString *) getOrgImageURL: (NSString *) orgID{
    

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"orgID = %@",
                             orgID];
    
    RLMResults *orgTableDataArray = [OrganizationTable objectsWithPredicate:pred];
    
    NSString * imgURL;
    if(orgTableDataArray.count>0){
        OrganizationTable * orgTableData = [orgTableDataArray objectAtIndex:0];
        imgURL = orgTableData.logoURL;
    }else{
        imgURL = @"";
    }
    
    return imgURL;
}


-(NSString *) getDistance: (NSString *) outletID{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"outletID = %@",
                         outletID];
    RLMResults *outletFullTableDataArray = [OutletTable objectsWithPredicate:pred];
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for(int i=0; i<outletFullTableDataArray.count; i++){
        OutletTable * outletTableData = [outletFullTableDataArray objectAtIndex:i];
        
        if([outletTableData.isDeleted integerValue] != 1){
            double lat = [outletTableData.lat doubleValue];
            double lon = [outletTableData.lon doubleValue];
            
            NSString * orgID = [NSString stringWithFormat:@"%@", outletTableData.orgID];
            
            
            if ([CLLocationManager locationServicesEnabled]){
                
                
                self.myLocationManager = [[CLLocationManager alloc] init];
                self.myLocationManager.delegate = self;
                self.myLocationManager.distanceFilter = kCLDistanceFilterNone;
                self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [self.myLocationManager startUpdatingLocation];
                
                CLLocation *startLocation = self.myLocationManager.location;
                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                
                float betweenDistance=[startLocation distanceFromLocation:location2];
                
                //int x = (@"Distance is %f km",betweenDistance/1000);
                NSString * distanceString = [NSString stringWithFormat:@"%f",betweenDistance/1000];
                
                NSDictionary * tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           
                                           orgID,@"orgID",
                                           distanceString,@"distance",nil];
                [tempArray addObject:tempDict];
                
                
                
                
            } else {
                /* Геолокационные службы не активизированы.
                 Попробуйте исправить ситуацию: например предложите пользователю
                 включить геолокационные службы. */
                [self.myLocationManager requestWhenInUseAuthorization];
                if ([self.myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [self.myLocationManager requestWhenInUseAuthorization];
                }
                NSLog(@"Location services are not enabled");
            }
            
        }
    }
    NSComparator compareDistances = ^(id string1, id string2)
    {
        NSNumber *number1 = [NSNumber numberWithFloat:[string1 floatValue]];
        NSNumber *number2 = [NSNumber numberWithFloat:[string2 floatValue]];
        
        return [number1 compare:number2];
    };
    // sort list and create nearest list
    NSSortDescriptor *sortDescriptorNearest = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES comparator:compareDistances];
    NSMutableArray * tempTwoArray = (NSMutableArray *)[tempArray sortedArrayUsingDescriptors:@[sortDescriptorNearest]];
    
    NSArray * resultArray = [NSArray arrayWithArray:tempTwoArray];
    NSString * minDistanceOutlet;
    if(resultArray.count>0){
        NSDictionary * dict = [resultArray objectAtIndex:0];
        minDistanceOutlet = [dict objectForKey:@"distance"];
    }else{
        minDistanceOutlet = @"0";
    }
    
    //
    return  minDistanceOutlet;
    
}


-(NSString *) getScheduleOutlets: (NSString *) outletID{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"outletID = %@",
                         outletID];
    RLMResults *outletFullTableDataArray = [ScheduleOutletsTable objectsWithPredicate:pred];
    if(outletFullTableDataArray.count>0){
        ScheduleOutletsTable * outletTableInfo = [outletFullTableDataArray objectAtIndex:0];
        NSString * result = [NSString stringWithFormat:@"%@ - %@",outletTableInfo.open, outletTableInfo.close];
        return result;
    }else{
       return @"--:-- - --:--";
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
