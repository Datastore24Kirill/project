//
//  HookahDetailsModel.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 16.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "HookahDetailsModel.h"
#import "OutletTable.h"
#import "DateTimeMethod.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "HelpMethodForOutlets.h"



@implementation HookahDetailsModel
@synthesize delegate;




#pragma mark - SELECTOUTLETS

-(void) selectOutlets:(NSString *) outletID {
    
    //Узнаем есть ли избранное
    HelpMethodForOutlets * helpMethod = [[HelpMethodForOutlets alloc] init];

   
    if(outletID.length != 0){
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"outletID = %@",
                             outletID];
        RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
        
        NSMutableArray * arrayAddress = [NSMutableArray arrayWithArray: [self loadOtherAddress:NO andOutletID:outletID]];
        
            OutletTable * outletTableData = [outletTableDataArray objectAtIndex:0];
            
            NSString *rating;
            if([outletTableData.rating isEqualToString:@"<null>"]){
                rating = @"0";
            }else{
                rating = [NSString stringWithFormat:@"%@",outletTableData.rating];
            }
            [self.delegate setStarCount:rating];
        [self.delegate setLatMap:outletTableData.lat];
        [self.delegate setLonMap:outletTableData.lon];
        
            //Запрашиваем режим работы
            

            NSDictionary *openClose = [helpMethod getScheduleOutletOne:outletID];
            NSString * close = [openClose objectForKey:@"close"];
            NSString * open = [openClose objectForKey:@"open"];
            
            NSLog(@"LOAD %@ open %@ close %@ addressArray %@ isFav %@",outletTableData.address,open,close,arrayAddress,outletTableData.isFavorite);
                [self.delegate loadDefault:outletTableData.address open:open close:close addressArray:arrayAddress
                                isFavorite:outletTableData.isFavorite];
                
        
        
    }else{
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"orgID = %@ AND isFavorite = %@",
                             [self.delegate orgID], @"1"];
        RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
        NSString * dateTimestamp =[DateTimeMethod dateToTimestamp:[self.delegate currentLocalDate]];
    
    if(outletTableDataArray.count==0){
        NSLog(@"NOFAVORITE");
        
        NSMutableArray * arrayAddress = [NSMutableArray arrayWithArray: [self loadOtherAddress:NO andOutletID:@""]];
        if(arrayAddress.count > 0){
            NSDictionary * firstOutlet = [arrayAddress objectAtIndex:0];
            [arrayAddress removeObjectAtIndex:0];
            [self.delegate setOutletID:[firstOutlet objectForKey:@"outletID"]];
            
            //Запрашиваем режим работы
            
           
            //ДАТА И ВРЕМЯ ДОДЕЛАТЬ
            NSDictionary *openClose = [helpMethod getScheduleOutletOne:[firstOutlet objectForKey:@"outletID"]];
            NSString * close = [openClose objectForKey:@"close"];
            NSString * open = [openClose objectForKey:@"open"];
            
            
                
                [self.delegate loadDefault:[firstOutlet objectForKey:@"address"] open:open close:close addressArray:arrayAddress
                                isFavorite:[firstOutlet objectForKey:@"isFavorite"]];
                

            
            //
            
           

        }
        
        
    }else if (outletTableDataArray.count==1){
        OutletTable * outletTableData = [outletTableDataArray objectAtIndex:0];
        
        NSString *rating;
        if([outletTableData.rating isEqualToString:@"<null>"]){
            rating = @"0";
        }else{
            rating = [NSString stringWithFormat:@"%@",outletTableData.rating];
        }
        [self.delegate setStarCount:rating];
        NSArray * arrayOtherAddress = [self loadOtherAddress:YES andOutletID:@""];
        
         [self.delegate setOutletID:outletTableData.outletID];
        //Запрашиваем режим работы
        
        
        //ДАТА И ВРЕМЯ ДОДЕЛАТЬ
        NSDictionary *openClose = [helpMethod getScheduleOutletOne:outletTableData.outletID];
        NSString * close = [openClose objectForKey:@"close"];
        NSString * open = [openClose objectForKey:@"open"];
        
            [self.delegate loadDefault:outletTableData.address open:open close:close addressArray:arrayOtherAddress isFavorite:outletTableData.isFavorite];
            
        
    }else if (outletTableDataArray.count>1){
        NSLog(@"ISFAVORITE %ld",outletTableDataArray.count);
        NSMutableArray * tempArray = [[NSMutableArray alloc] init];
        for(int i = 0; i<outletTableDataArray.count; i++){
             OutletTable * outletTableData = [outletTableDataArray objectAtIndex:i];
            if([outletTableData.isDeleted integerValue] != 1){
                
                double lat = [outletTableData.lat doubleValue];
                double lon = [outletTableData.lon doubleValue];
                NSString * outletID = [NSString stringWithFormat:@"%@", outletTableData.outletID];
                NSString * name = outletTableData.name;
                
                NSString *rating;
                if([outletTableData.rating isEqualToString:@"<null>"]){
                    rating = @"0";
                }else{
                    rating = [NSString stringWithFormat:@"%@",outletTableData.rating];
                }
                
                NSString * isFavorite = [NSString stringWithFormat:@"%@",outletTableData.isFavorite];
                NSString * address = [NSString stringWithFormat:@"%@", outletTableData.address];
                

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
                                               name, @"name",
                                               address,@"address",
                                               outletID,@"outletID",
                                               rating, @"rating",
                                               isFavorite, @"isFavorite",
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
        
        //
        NSComparator compareDistances = ^(id string1, id string2)
        {
            NSNumber *number1 = [NSNumber numberWithFloat:[string1 floatValue]];
            NSNumber *number2 = [NSNumber numberWithFloat:[string2 floatValue]];
            
            return [number1 compare:number2];
        };
        
        // sort list and create nearest list
        NSSortDescriptor *sortDescriptorNearest = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES comparator:compareDistances];
        NSMutableArray * tempTwoArray = (NSMutableArray *)[tempArray sortedArrayUsingDescriptors:@[sortDescriptorNearest]];
        
        if(tempTwoArray.count>0){
            NSDictionary * dictDefault = [tempTwoArray objectAtIndex:0];
            NSMutableArray * favoriteAddress = [NSMutableArray arrayWithArray:tempTwoArray];
            NSMutableArray * arrayAddress = [NSMutableArray arrayWithArray: [self loadOtherAddress:YES andOutletID:@""]];
            
            if(tempArray.count>1){
                
                [favoriteAddress removeObjectAtIndex:0];
                for(int i=0; i<favoriteAddress.count; i++){
                    [arrayAddress insertObject:[favoriteAddress objectAtIndex:i] atIndex:i];
                }
            
            }
            
            [self.delegate setOutletID:[dictDefault objectForKey:@"outletID"]];
            
            //Запрашиваем режим работы
            
            
            //ДАТА И ВРЕМЯ ДОДЕЛАТЬ
            NSDictionary *openClose = [helpMethod getScheduleOutletOne:[dictDefault objectForKey:@"outletID"]];
            NSString * close = [openClose objectForKey:@"close"];
            NSString * open = [openClose objectForKey:@"open"];
                
                [self.delegate loadDefault:[dictDefault objectForKey:@"address"] open:open close:close addressArray:arrayAddress isFavorite:[dictDefault objectForKey:@"isFavorite"]];
                
            
            //
           
        }

    }
    }
    
}

#pragma mark - SETARRAY

- (NSArray *) loadOtherAddress: (BOOL) isFavorite andOutletID: (NSString *) outletID{
 
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    NSPredicate *pred;
    HelpMethodForOutlets * helpMethod = [[HelpMethodForOutlets alloc] init];
    
    if(isFavorite){
        //Узнаем есть ли избранное
        pred = [NSPredicate predicateWithFormat:@"orgID = %@ AND isFavorite = %@",
                             [self.delegate orgID], @"0"];
    }else if(outletID.length != 0){
        pred = [NSPredicate predicateWithFormat:@"orgID = %@ AND outletID != %@",
                [self.delegate orgID],outletID];
    }else{
        pred = [NSPredicate predicateWithFormat:@"orgID = %@",
                             [self.delegate orgID]];
    }
        RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
        
        for(int i=0; i<outletTableDataArray.count; i++){
            OutletTable * outletTableData = [outletTableDataArray objectAtIndex:i];
            
            if([outletTableData.isDeleted integerValue] != 1){
            double lat = [outletTableData.lat doubleValue];
            double lon = [outletTableData.lon doubleValue];
            NSString * outletID = [NSString stringWithFormat:@"%@", outletTableData.outletID];
            NSString * name = outletTableData.name;
                NSString * orgID = [NSString stringWithFormat:@"%@",outletTableData.orgID];
            
            NSString *rating;
            if([outletTableData.rating isEqualToString:@"<null>"]){
                rating = @"0";
            }else{
                rating = [NSString stringWithFormat:@"%@",outletTableData.rating];
            }
            
            NSString * isFavorite = [NSString stringWithFormat:@"%@",outletTableData.isFavorite];
            NSString * address = [NSString stringWithFormat:@"%@", outletTableData.address];
            
            
        
            
            if ([CLLocationManager locationServicesEnabled]){
                
    
                self.myLocationManager = [[CLLocationManager alloc] init];
                self.myLocationManager.delegate = self;
                self.myLocationManager.distanceFilter = kCLDistanceFilterNone;
                self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [self.myLocationManager startUpdatingLocation];
                
                CLLocation *startLocation = self.myLocationManager.location;
                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                
                float betweenDistance=[startLocation distanceFromLocation:location2];
                NSString * logoURL = [helpMethod getOrgImageURL:outletTableData.orgID];
                //int x = (@"Distance is %f km",betweenDistance/1000);
                NSString * distanceString = [NSString stringWithFormat:@"%f",betweenDistance/1000];
                
                NSDictionary * tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           name, @"name",
                                           address,@"address",
                                           outletID,@"outletID",
                                           orgID, @"orgID",
                                           logoURL, @"logoURL",
                                           rating, @"rating",
                                           isFavorite, @"isFavorite",
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
    
    return resultArray;
    
}



- (void) setArrayShares {
    
    
    APIManger * apiManager = [[APIManger alloc] init];
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [self.delegate outletID],@"outlet_id",nil];
    
    
    [apiManager getDataFromSeverWithMethod:@"outlet.getPromoActions" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        if([response isKindOfClass:[NSDictionary class]]){
            if([response objectForKey:@"error_code"]){
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                      [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                
            }else{
                NSDictionary * respDict = [response objectForKey:@"response"];
                NSArray * itemsArray = [respDict objectForKey:@"items"];
                
                [self.delegate loadShares:itemsArray];
                
            }
        }
    }];
}

- (void) setArrayReviews {
    NSLog(@"SETARRAY");
    
    APIManger * apiManager = [[APIManger alloc] init];
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [self.delegate outletID],@"outlet_id",nil];
    
    
    [apiManager getDataFromSeverWithMethod:@"outlet.getReviews" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        if([response isKindOfClass:[NSDictionary class]]){
            if([response objectForKey:@"error_code"]){
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                      [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                
            }else{
                NSDictionary * respDict = [response objectForKey:@"response"];
                NSArray * itemsArray = [respDict objectForKey:@"items"];
                [self.delegate loadReviews:itemsArray];
            
            }
        }
    }];

}

#pragma mark - LOCATION

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    _startLocation = newLocation;
    
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    /* Не удалось получить информацию о местоположении пользователя. */
    NSLog(@"ERROR LOCATION");
}

#pragma mark - FAVORITES

-(void) setFavorites: (BOOL) isFavorite andOutletID: (NSString *) outletID
     complitionBlock: (void (^) (void)) compitionBack{
    APIManger * apiManager = [[APIManger alloc] init];
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             outletID,@"outlet_id",nil];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"outletID = %@",
                         outletID];
 
    if(isFavorite){
        [apiManager getDataFromSeverWithMethod:@"outlet.addToFavourites" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
            
           
            if([response objectForKey:@"error_code"]){
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                      [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                if(errorCode == 382){
                    RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
                    OutletTable * outletTableData = [outletTableDataArray objectAtIndex:0];
                    
                    
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    outletTableData.isFavorite=@"1";
                    [realm commitWriteTransaction];
                    compitionBack();
                }
                
            }else{
                
                
                if([[response objectForKey:@"response"] integerValue] == 1){
                    RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
                    OutletTable * outletTableData = [outletTableDataArray objectAtIndex:0];
                    
                    
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    outletTableData.isFavorite=@"1";
                    [realm commitWriteTransaction];
                    
                      compitionBack();
                    
                }
            

                
                
              
            }

        }];
    }else{
        [apiManager getDataFromSeverWithMethod:@"outlet.removeFromFavourites" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
            
           
            if([response objectForKey:@"error_code"]){
                NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                      [response objectForKey:@"error_msg"]);
                NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
                if(errorCode == 382){
                    RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
                    OutletTable * outletTableData = [outletTableDataArray objectAtIndex:0];
                  
                    
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    outletTableData.isFavorite=@"0";
                    [realm commitWriteTransaction];
                    compitionBack();
                }
                
            }else{
                if([[response objectForKey:@"response"] integerValue] == 1){
                    RLMResults *outletTableDataArray = [OutletTable objectsWithPredicate:pred];
                    OutletTable * outletTableData = [outletTableDataArray objectAtIndex:0];
                    
                
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    outletTableData.isFavorite=@"0";
                    [realm commitWriteTransaction];
                
                    compitionBack();
                }
                
                
            }
            
        }];
        
    }
    
}


@end
