//
//  MenuBarModel.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 11.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MenuBarModel.h"

@implementation MenuBarModel

+ (NSArray*) setArray {
    
    NSMutableArray * mArray = [NSMutableArray array];
    
    NSArray * arrayImageOff = [NSArray arrayWithObjects:@"OrderImageOff", @"MapImageOff",
                                                        @"HistoryImageOff", @"OtherImageOff", nil];
    
    NSArray * arrayImageOn = [NSArray arrayWithObjects:@"OrderImageOn", @"MapImageOn",
                               @"HistoryImageOn", @"OtherImageOn", nil];
    
    NSArray * arrayText = [NSArray arrayWithObjects:@"Заказ", @"Карта", @"История", @"Прочее", nil];
    
    for (int i = 0; i < arrayImageOff.count; i++) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[arrayImageOn objectAtIndex:i], @"imageOFF",
                                                                         [arrayImageOff objectAtIndex:i], @"imageON",
                                                                         [arrayText objectAtIndex:i], @"text", nil];
        
        [mArray addObject:dict];
        
    }
    
    NSArray * resultArray = [NSArray arrayWithArray:mArray];
    
    
    return resultArray;
    
}

@end
