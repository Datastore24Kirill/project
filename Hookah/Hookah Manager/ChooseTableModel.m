//
//  ChooseTableModel.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 2/1/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ChooseTableModel.h"
#import "APIManger.h"
#import "SingleTone.h"
#import "ScheduleOutletsTable.h"
#import "DateTimeMethod.h"

@implementation ChooseTableModel
@synthesize delegate;

- (void) getArray: (NSString *) outletID {

    
    APIManger * apiManager = [[APIManger alloc] init];
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                           outletID,@"outlet_id", nil];
    
    [apiManager getDataFromSeverWithMethod:@"outlet.getRoomsAndTables" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        
        if([response objectForKey:@"error_code"]){
            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                  [response objectForKey:@"error_msg"]);
            NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
            
            
        }else{
            
            if([response isKindOfClass:[NSDictionary class]]){
                NSArray * respArray = [response objectForKey:@"response"];

                
                self.allExistTables = [NSMutableArray new];
                for(int i=0; i< respArray.count; i++){
                    NSDictionary * dictRoom = [respArray objectAtIndex: i];
                    NSArray * tables = [dictRoom objectForKey:@"tables"];
                    for(int k=0; k< tables.count; k++){
                        NSDictionary * dictTable = [tables objectAtIndex:k];
                        [self.allExistTables addObject:[dictTable objectForKey:@"id"]];
                    }
                }
                
                [self.delegate loadTable:respArray endCountTables:self.allExistTables];
            }

        }
    }];
    
}

- (NSMutableArray*) getArrayForPickerLocal: (NSString *) outletID {
    
    NSMutableArray * array = [NSMutableArray array];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"outletID = %@",
                         [NSString stringWithFormat:@"%@",outletID]];
    RLMResults *scheduleOutletsArray = [ScheduleOutletsTable objectsWithPredicate:pred];

    if(scheduleOutletsArray.count > 0){
        ScheduleOutletsTable * scheduleOutlets = [scheduleOutletsArray objectAtIndex:0];
        
        
        NSArray * timeOutletsOpen = [scheduleOutlets.open componentsSeparatedByString:@":"];
        NSArray * timeOutletsClose = [scheduleOutlets.close componentsSeparatedByString:@":"];
        
        NSMutableArray * arrayHours = [NSMutableArray array];
        //Текущие часы и минуты
        NSString * currentHours = [DateTimeMethod getCurrentDateFormattedHH];
        NSString * currentMinutes = [DateTimeMethod getCurrentDateFormattedMM];
        //
        
        int startArray;
        
        startArray = [[timeOutletsOpen objectAtIndex:0] intValue];
        
        if([[timeOutletsClose objectAtIndex:0] integerValue]<[[timeOutletsOpen objectAtIndex:0] integerValue]){
            
            for (int i = startArray; i < 24 ; i++)
            {
                [arrayHours addObject:[NSString stringWithFormat:@"%d",i]];
                
            }
            
            for (int k = 0; k < [[timeOutletsClose objectAtIndex:0] intValue]+1; k++)
            {
                [arrayHours addObject:[NSString stringWithFormat:@"%d",k]];
                
            }
            
            
        }else{
            for (int i = startArray; i < [[timeOutletsClose objectAtIndex:0] intValue]+1; i++)
            {
                [arrayHours addObject:[NSString stringWithFormat:@"%d",i]];
                
            }
        }
        
        
        NSInteger  resultHours =  [currentHours integerValue] - [[timeOutletsOpen objectAtIndex:0] integerValue];
        
        for(int i=0; i<resultHours; i++){
            [arrayHours removeObjectAtIndex:0];
        }
        
        for(int i=0; i<arrayHours.count; i++){
            
             NSMutableArray * arrayMinutes = [NSMutableArray arrayWithObjects: @"00", @"15", @"30", @"45", nil];
            
            
           
            //Условие, которое перезаписывает минуты 04
            
            
            if([currentMinutes integerValue] > [[timeOutletsOpen objectAtIndex:1] integerValue] && [currentHours integerValue] < [[timeOutletsOpen objectAtIndex:0] integerValue] ){
                
                currentMinutes = [timeOutletsOpen objectAtIndex:1];
                
            }else if([currentMinutes integerValue] <= [[timeOutletsOpen objectAtIndex:1] integerValue] && [currentHours integerValue] == [[timeOutletsOpen objectAtIndex:0] integerValue] ){
                currentMinutes = [timeOutletsOpen objectAtIndex:1];
            }
            
            //Время начала работы если не 00
            
            
            
            if(![currentMinutes isEqualToString:@"00"] && i==0){
               [arrayMinutes removeAllObjects];
                if([currentMinutes integerValue] == 0){
                    [arrayMinutes addObject:@"00"];
                    [arrayMinutes addObject:@"15"];
                    [arrayMinutes addObject:@"30"];
                    [arrayMinutes addObject:@"45"];
                    
                }else if([currentMinutes integerValue] >0
                         && [currentMinutes integerValue] <=15){
                    [arrayMinutes addObject:@"15"];
                    [arrayMinutes addObject:@"30"];
                    [arrayMinutes addObject:@"45"];
                    
                    
                }else if([currentMinutes integerValue] >15
                         && [currentMinutes integerValue] <=30){
                    [arrayMinutes addObject:@"30"];
                    [arrayMinutes addObject:@"45"];
                }else if([currentMinutes integerValue] >30
                         && [currentMinutes integerValue] <=45){
                    [arrayMinutes addObject:@"45"];
                }else{
                    
                    [arrayHours removeObjectAtIndex:0];

                    [arrayMinutes addObject:@"00"];
                    [arrayMinutes addObject:@"15"];
                    [arrayMinutes addObject:@"30"];
                    [arrayMinutes addObject:@"45"];
                    
                }
                
            }
            
   
            //Время окончания работы, если не 00
            if(![[timeOutletsClose objectAtIndex:1] isEqualToString:@"00"] && i==arrayHours.count-1){
                [arrayMinutes removeAllObjects];
                if([[timeOutletsClose objectAtIndex:1] integerValue] >0
                   && [[timeOutletsClose objectAtIndex:1] integerValue] <15){
                    
                    [arrayMinutes addObject:@"00"];
                    
                }else if([[timeOutletsClose objectAtIndex:1] integerValue] >=15
                         && [[timeOutletsClose objectAtIndex:1] integerValue] <30){
                    [arrayMinutes addObject:@"00"];
                    [arrayMinutes addObject:@"15"];
                }else if([[timeOutletsClose objectAtIndex:1] integerValue] >=30
                         && [[timeOutletsClose objectAtIndex:1] integerValue] <45){
                    [arrayMinutes addObject:@"00"];
                    [arrayMinutes addObject:@"15"];
                    [arrayMinutes addObject:@"30"];
                }else if([[timeOutletsClose objectAtIndex:1] integerValue] >=45){
                    [arrayMinutes addObject:@"00"];
                    [arrayMinutes addObject:@"15"];
                    [arrayMinutes addObject:@"30"];
                    [arrayMinutes addObject:@"45"];
                    
                }
                
            }
            //
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [arrayHours objectAtIndex:i], @"hours",
                                   arrayMinutes, @"minutes", nil];
            
            
            
            [array addObject:dict];
            
        }
        
    }else{
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"--", @"hours",
                               @[@"--"], @"minutes", nil];
        [array addObject:dict];
        
       
    }
    
    return array;
    
   
    
    
    
}


//Данные по все столам

- (void) getArrayCloseTimeForServer:(NSString *) outletID orderID: (NSString *) orderID ccomplitionBlock: (void (^) (NSArray* response)) compitionBlockOne {

    APIManger * apiManager = [[APIManger alloc] init];
    NSString * dateTimestamp =[DateTimeMethod dateToTimestamp:[NSDate date]];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                             outletID,@"outlet_id",
                             dateTimestamp,@"date",nil];
    
    if(orderID){
        [params setObject:orderID forKey:@"order_id"];
    }
    

    
    [apiManager getDataFromSeverWithMethod:@"order.getTableBusyTimes" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        if([response objectForKey:@"error_code"]){
            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                  [response objectForKey:@"error_msg"]);
            NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
            
            
            
        }else{
            if([[response objectForKey:@"response"] isKindOfClass:[NSArray class]]){
                //Получаем часы и минуты для пикера
//                NSMutableArray * arrayLocal = [self getArrayForPickerLocal:@"1"];
                NSArray * respArray = [response objectForKey:@"response"];
                if(respArray.count >0){
                    
                    
                    
                    NSMutableArray * resultArray = [NSMutableArray arrayWithArray: [self workAndManyTablesWithArray:respArray andOutletID:outletID]];
                    
                    compitionBlockOne(resultArray);
                
                }else{
                    NSMutableArray * resultArray = [NSMutableArray arrayWithArray: [self workAndManyTablesWithArray:respArray andOutletID:outletID]];
                    
                    compitionBlockOne(resultArray);
                }
            }else{
                
            }
        }
        
    }];

}

//Данные по конкретному столу
- (void) getArrayCloseTimeForServer:(NSString *) outletID andTableID:(NSString *) tableID
                           orderID:(NSString *) orderID ccomplitionBlock: (void (^) (NSArray* response)) compitionBlock {
    
    APIManger * apiManager = [[APIManger alloc] init];
    NSString * dateTimestamp =[DateTimeMethod dateToTimestamp:[NSDate date]];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                             outletID,@"outlet_id",
                             tableID,@"table_id",
                             dateTimestamp,@"date",nil];
    if(orderID){
        [params setObject:orderID forKey:@"order_id"];
    }
    

    [apiManager getDataFromSeverWithMethod:@"order.getTableBusyTimes" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        
        if([response objectForKey:@"error_code"]){
            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                  [response objectForKey:@"error_msg"]);
            NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
            
            
            
        }else{
            if([[response objectForKey:@"response"] isKindOfClass:[NSArray class]]){
                NSArray * respArray = [response objectForKey:@"response"];
                
                NSMutableArray * arrayResult;
                if(respArray.count>0){
                    arrayResult = [NSMutableArray arrayWithArray:[self workListTablesWithArray:respArray andOutletID:outletID]];
                }else{
                    arrayResult = [NSMutableArray arrayWithArray:[self workListTablesWithArray:nil andOutletID:outletID]];
                }
                for(int i=0;i<respArray.count; i++){
                    NSDictionary * dict = [respArray objectAtIndex:i];
                    
                }
                
                
                
                    compitionBlock(arrayResult);

            }
            
        }
        
    }];
    
}

- (NSInteger)getObjectIndex:(NSMutableArray *)array byName:(NSString *)theName {
    NSInteger idx = 0;
    for (NSDictionary* dict in array) {
        if ([[dict objectForKey:@"hours"] isEqualToString:theName])
            return idx;
        ++idx;
    }
    return NSNotFound;
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



#pragma mark - ManyTables
//Создание массива для одного столика--
- (NSMutableArray*) workListTablesWithArray: (NSArray*) array andOutletID: (NSString *) outletID  {
    
    self.mainArray = array;
    
    //Работа с созданием интервала работы заведения------------------------------------------
    //Получаем часы и минуты для пикера
  
    NSMutableArray * arrayLocal = [self getArrayForPickerLocal:outletID];
    //Конвертруем в строки--------------------------
    NSMutableArray * arrayString = [self converArrayWithArray:arrayLocal];
    
    for(int l=0; l<4; l++){
        [arrayString removeLastObject];
    }
    //Образка времени-------------------------------------------------------------------------
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary * respDict = [array objectAtIndex:i];
        
        //Время начала занятого времени
        NSString * beginAt = [DateTimeMethod timeFormattedHHMM:
                              [[respDict objectForKey:@"begin_at"] intValue]];
        
        //Время окончания занятого времени
        NSString * endAt = [DateTimeMethod timeFormattedHHMM:
                            [[respDict objectForKey:@"end_at"] intValue]];
        
        [self createBusyTimeWithStartTime:beginAt andEndTime:endAt mainArray:arrayString];
        
         
    }
    

    
    if (arrayString.count > 0) {
        //Преобразование массива строк в рабочий массив--------------------------
        arrayString = [self unconvertArrayWithArray:arrayString];
    }
    
    self.oneTableArray = [NSMutableArray arrayWithArray:arrayString];
    
    return arrayString;

}

//Создание массива для всех столиков--
- (NSMutableArray*) workAndManyTablesWithArray: (NSArray*) array andOutletID: (NSString *) outletID {
    
    self.mainArray = array;
    
    //Работа с созданием интервала работы заведения------------------------------------------
    //Получаем часы и минуты для пикера
    NSMutableArray * arrayLocal = [self getArrayForPickerLocal:outletID];
    //Конвертруем в строки--------------------------
    NSMutableArray * arrayString = [self converArrayWithArray:arrayLocal];
    
    if(arrayString.count>=4){
        for(int l=0; l<4; l++){
            [arrayString removeLastObject];
        }
    }
    
    
    //Создаем массив столов
    NSMutableArray * arrayTables = [self createArrayTablesWithMainArray:array andTimeArray:arrayString];
    
    //Образка времени-------------------------------------------------------------------------
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary * respDict = [array objectAtIndex:i];
        NSMutableArray * workArray;
        
        for (int j = 0; j < arrayTables.count; j++) {
            NSDictionary * dictTables = [arrayTables objectAtIndex:j];
            if ([[respDict objectForKey:@"table_id"] integerValue] == [[dictTables objectForKey:@"table_id"] integerValue]) {
                workArray = [dictTables objectForKey:@"array"];
                break;
            }
        }
                    //Время начала занятого времени
                    NSString * beginAt = [DateTimeMethod timeFormattedHHMM:
                                          [[respDict objectForKey:@"begin_at"] intValue]];
            
                    //Время окончания занятого времени
                    NSString * endAt = [DateTimeMethod timeFormattedHHMM:
                                        [[respDict objectForKey:@"end_at"] intValue]];

                    [self createBusyTimeWithStartTime:beginAt andEndTime:endAt mainArray:workArray];
    }
    
    self.moreTableArray = [NSMutableArray arrayWithArray:arrayTables];
    
    //Объединение всех столов-----------------------------------------------
    NSMutableArray * resultArray = [self createTimeForAllTablesWithArrayTables:arrayTables];
    
    //Сортирвока с учетоем стартового времени-------------------------------
    NSString * startTime = [arrayString objectAtIndex:0];
    resultArray = [self sortArrayMethodWithArrat:resultArray andStartTime:startTime];
    
    //Преобразование массива строк в рабочий массив--------------------------
    resultArray = [self unconvertArrayWithArray:resultArray];
    self.oneTableArray = [NSMutableArray arrayWithArray:resultArray];
    
    return resultArray;

}

//Преобразование рабочего массива в массив строк
- (NSMutableArray*) converArrayWithArray: (NSMutableArray*) array {
    
    NSMutableArray * arrayString = [NSMutableArray array];

    for (int i = 0; i < array.count; i++) {
        NSDictionary * dict = [array objectAtIndex:i];
        NSArray * arrayMinutes = [dict objectForKey:@"minutes"];
        
        for (int j = 0; j < arrayMinutes.count; j++) {
            
            NSInteger hours = [[dict objectForKey:@"hours"] integerValue];
            NSInteger minutes = [[arrayMinutes objectAtIndex:j] integerValue];
            
            
            NSString * stringTime = [NSString stringWithFormat:@"%02ld:%02ld", hours,
                                                                     minutes];
            [arrayString addObject:stringTime];
        }
    }
    return arrayString;
  
}

//Преобразование массива строк в рабочий массив
-(NSMutableArray*) unconvertArrayWithArray: (NSMutableArray*) array {
    
    NSMutableArray * resultArray = [NSMutableArray array];
    
    for (int i =0; i < array.count; i++) {
        NSString * tempString = [array objectAtIndex:i];
        NSString * tempHours = [tempString substringToIndex:2];
        NSString * tempMinutes = [tempString substringFromIndex:3];
        
        
        
        NSDictionary * dictPerams = [resultArray lastObject];
        NSString * hoursString = [dictPerams objectForKey:@"hours"];

        NSMutableArray * arrayMinutes;
        
        if (tempHours == hoursString) {
            arrayMinutes = [dictPerams objectForKey:@"minutes"];
            [arrayMinutes addObject:tempMinutes];
        } else {
            arrayMinutes = [NSMutableArray array];
            [arrayMinutes addObject:tempMinutes];
            
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:tempHours, @"hours", arrayMinutes, @"minutes", nil];
            [resultArray addObject:dict];
        }
    }
    
    return resultArray;
}


//Обрезка диапазона времени с учетом забронированного времени
- (void) createBusyTimeWithStartTime: (NSString*) startTime andEndTime: (NSString*) endTime mainArray: (NSMutableArray*) mainArray {
    
    NSMutableArray * arrayTimeBusy = [NSMutableArray array];
    
    //Новая строка с начальным временем минус 1 час
    NSString * newTime = [self cutTimeForHoursWithStartTime:startTime];
    
    NSInteger hours = [[newTime substringToIndex:2] integerValue];
    NSInteger minutes = [[newTime substringFromIndex:3] integerValue];

    //Создания диапазона строк занятого времени
    while (![newTime isEqualToString: endTime]) {
        
        NSString * stringTime = [NSString stringWithFormat:@"%02ld:%02ld", hours, minutes];
        
        newTime = stringTime;
        
        if (![newTime isEqualToString: endTime]) {
            [arrayTimeBusy addObject:stringTime];
        }
        if (minutes < 45) {
            minutes += 15;
        } else {
            hours = (hours + 1) % 24;
            minutes = 0;
        }
    }
    
    //Поиск и удаление объектов из общего массиво времени
    for (int i = 0; i < arrayTimeBusy.count; i++) {
        NSString * searchString = [arrayTimeBusy objectAtIndex:i];
        BOOL isSearch = NO;
        
        if (mainArray.count != 0) {
            for (int j = 0; j < mainArray.count; j++) {
                if ([searchString isEqualToString:[mainArray objectAtIndex:j]]) {
                    isSearch = YES;
                    break;
                }
            }
            if (isSearch) {
                [mainArray removeObject:searchString];
            }
        }
        

    }
    
    
}

//Обрезка стартового времени на один час меньше
- (NSString*) cutTimeForHoursWithStartTime: (NSString*) startTime {
    
    NSInteger hours = [[startTime substringToIndex:2] integerValue];
    hours -= 1;
    NSInteger minutes = [[startTime substringFromIndex:3] integerValue];
    if (minutes < 45) {
        minutes += 15;
    } else {
        hours = (hours + 1) % 24;
        minutes = 0;
    }
    NSString * tempString = [NSString stringWithFormat:@"%02ld:%02ld", hours, minutes];
    return tempString;
    
}

//Создание массива с массивом данных по столам
#pragma mark - CreateArrayTables

- (NSMutableArray*) createArrayTablesWithMainArray: (NSArray*) array andTimeArray: (NSMutableArray*) timeArray {
    
    NSMutableArray * arrayTables = [NSMutableArray array];
    
    for (int i = 0; i < self.allExistTables.count; i++) {
        
        NSInteger stringId = [[self.allExistTables objectAtIndex:i] integerValue];
        
        BOOL isSearch = NO;
        for (int j = 0; j < arrayTables.count; j++) {
            NSDictionary * dictTables = [arrayTables objectAtIndex:j];
            NSInteger stringTabelsId = [[dictTables objectForKey:@"table_id"] integerValue];
            if (stringId == stringTabelsId) {
                isSearch = YES;
                break;
            }
        }
        if (!isSearch) {
            NSMutableArray * arrayTimeTable = [NSMutableArray arrayWithArray:timeArray];
            NSDictionary * dictTables = [NSDictionary dictionaryWithObjectsAndKeys: arrayTimeTable, @"array",
                                                                                    [NSNumber numberWithInteger:stringId], @"table_id", nil];
            [arrayTables addObject:dictTables];
        }
    }
    return arrayTables;
    
}

//Объединение массивов столов----------------------
- (NSMutableArray*) createTimeForAllTablesWithArrayTables: (NSMutableArray*) arrayTables {
    
    
    NSDictionary * dictTime = [arrayTables objectAtIndex:0];
    NSMutableArray * firstArray = [dictTime objectForKey:@"array"];
    NSMutableArray * resultArray = [NSMutableArray arrayWithArray:firstArray];

    
    for (int i = 0; i < arrayTables.count - 1; i++) {
        
        NSDictionary * tempDict = [arrayTables objectAtIndex:i + 1];
        NSMutableArray * tempArray = [tempDict objectForKey:@"array"];
        
        [resultArray addObjectsFromArray:tempArray];
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:resultArray];
        NSArray *arrayWithoutDuplicates = [orderedSet array];
        resultArray = [NSMutableArray arrayWithArray:arrayWithoutDuplicates];
    }
    return resultArray;
}

//Сортировка времени с учетом стартового времени------------------
- (NSMutableArray*) sortArrayMethodWithArrat: (NSMutableArray*) array andStartTime: (NSString*) startTime {
    
    [array sortUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        
        NSInteger hours1 = [[obj1 substringToIndex:2] integerValue];
        NSInteger minutes1 = [[obj1 substringFromIndex:3] integerValue];
        
        NSInteger hours2 = [[obj2 substringToIndex:2] integerValue];
        NSInteger minutes2 = [[obj2 substringFromIndex:3] integerValue];
        
        if (hours1 > hours2) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if (hours1 < hours2) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (hours1 == hours2) {
            
            if (minutes1 > minutes2) {
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                return (NSComparisonResult)NSOrderedAscending;
            }
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    //Обрезаем массив и состовляем по начальному времени--------
    NSMutableArray * lowerArray = [NSMutableArray array];
    NSMutableArray * upperArray = [NSMutableArray array];
    
    NSInteger startHours = [[startTime substringToIndex:2] integerValue];
    NSInteger startMinutes = [[startTime substringFromIndex:3] integerValue];
    
    for (int i = 0; i < array.count; i++) {
        
        NSString * tempString = [array objectAtIndex:i];
        NSInteger tempHours = [[tempString substringToIndex:2] integerValue];
        NSInteger tempMinutes = [[tempString substringFromIndex:3] integerValue];
        
        if (tempHours < startHours) {
            [lowerArray addObject:[array objectAtIndex:i]];
        } else if (tempHours > startHours) {
            [upperArray addObject:[array objectAtIndex:i]];
        } else if (tempHours == startHours) {
            
            if (tempMinutes < startMinutes) {
                [lowerArray addObject:[array objectAtIndex:i]];
            } else {
                [upperArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    
    [array removeAllObjects];
    [array addObjectsFromArray:upperArray];
    [array addObjectsFromArray:lowerArray];
    return array;
    
}

#pragma mark - ChooseTimes

- (NSArray*) getFinishTime:(NSString *) chooseTime andTableID: (NSString*) tableID andOutletID: (NSString *) outletID {
    
    NSMutableArray * copyArrayTimes = [NSMutableArray arrayWithArray:[self getMinTimeWithTime:chooseTime endTableID:tableID andOutletID:outletID]];

        NSInteger startHours = [[chooseTime substringToIndex:2] integerValue];
        NSInteger startMinutes = [[chooseTime substringFromIndex:3] integerValue];
        startHours = (startHours +1)%24;
    
        NSString * stringTimeMinimal = [NSString stringWithFormat:@"%02ld:%02ld", startHours, startMinutes];
    
        NSMutableArray * myArray = [NSMutableArray arrayWithArray:copyArrayTimes];
        for(int i=0; i< copyArrayTimes.count; i++){
    
            if([[copyArrayTimes objectAtIndex:i] isEqualToString:stringTimeMinimal]){
                break;
            }
            [myArray removeObjectAtIndex:0];
        }
    
    myArray = [self unconvertArrayWithArray:myArray];
    NSArray * resultArray = [NSArray arrayWithArray:myArray];
    return resultArray;
}


- (NSMutableArray *) getMinTimeWithTime: (NSString*) time endTableID: (NSString*) tableID andOutletID: (NSString *) outletID {
    
    NSMutableArray * arrayLocal = [self getArrayForPickerLocal:outletID];
    arrayLocal = [self converArrayWithArray:arrayLocal];
    NSString * startString = [arrayLocal objectAtIndex:0];
    //Время начала работы
    NSInteger startHours = [[startString substringToIndex:2] integerValue];
    
    NSMutableArray * arrayStartTimeBusy = [NSMutableArray array];
    
    //Выбранное время
    NSInteger timeHours = [[time substringToIndex:2] integerValue];
    NSInteger timeMinutes = [[time substringFromIndex:3] integerValue];
    
    for (int i = 0; i < self.mainArray.count; i++) {
        
        NSDictionary * respDict = [self.mainArray objectAtIndex:i];

        if (tableID == nil || [tableID integerValue] == [[respDict objectForKey:@"table_id"] integerValue]) {
            //Время начала занятого времени
            NSString * beginAt = [DateTimeMethod timeFormattedHHMM:
                                  [[respDict objectForKey:@"begin_at"] intValue]];
            
            
            
            //Проверка времени--------------------------
            NSInteger busyHours = [[beginAt substringToIndex:2] integerValue];
            NSInteger busyMinutes = [[beginAt substringFromIndex:3] integerValue];
            
            if (busyHours > timeHours) {
                [arrayStartTimeBusy addObject:beginAt];
            } else if (busyHours == timeHours) {
                
                if (busyMinutes > timeMinutes) {
                    [arrayStartTimeBusy addObject:beginAt];
                }
            }else if (busyHours < timeHours && busyHours < startHours){
                [arrayStartTimeBusy addObject:beginAt];
            }
        }
    }
   
    if (arrayStartTimeBusy.count > 0) {
        arrayStartTimeBusy = [self sortArrayMethodWithArrat:arrayStartTimeBusy andStartTime:startString];
        
        NSString * endElement = [arrayStartTimeBusy objectAtIndex:0];
        arrayLocal = [self cutArrayWithArray:arrayLocal andBusyTime:endElement];
    }
    
    return arrayLocal;
    
}

- (NSMutableArray*) cutArrayWithArray: (NSMutableArray*) localArray andBusyTime: (NSString*) busyTime {
    
    for (int i = 0; i < localArray.count; i++) {
        if ([[localArray objectAtIndex:i] isEqualToString:busyTime]) {
            
            [localArray removeObjectsInRange:NSMakeRange(i+1, localArray.count - (i+1))];
            break;
        }
    }
    
    return localArray;
    
}

#pragma mark - ChoodeTableForTime

- (NSDictionary*) chooseTableForTime: (NSString*) time {
    

    
    NSArray * needTable;
    NSString * tableID;
    
    for (int i = 0; self.moreTableArray.count; i++) {
        
        BOOL isBool = NO; //Поиск нужного числа
        NSDictionary * dictTable = [self.moreTableArray objectAtIndex:i];
        NSArray * arrayTime = [dictTable objectForKey:@"array"];
        NSString * tempID = [dictTable objectForKey:@"table_id"];
        for (int j = 0; j < arrayTime.count; j++) {
            
            NSString * tempTime = [arrayTime objectAtIndex:j];
            
            if ([tempTime isEqualToString:time]) {
                isBool = YES;
                needTable = arrayTime;
                tableID = tempID;
                break;
            }
        }
        if (isBool) {
            break;
        }
    }
    
    NSDictionary * resultDict = [NSDictionary dictionaryWithObjectsAndKeys:needTable, @"array", tableID, @"table_id", nil];
    return resultDict;
    
}





@end
