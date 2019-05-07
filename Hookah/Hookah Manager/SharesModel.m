//
//  SharesModel.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "SharesModel.h"
#import "APIManger.h"
#import "SingleTone.h"

@implementation SharesModel
@synthesize delegate;

- (NSArray*) setArray {
    
    NSMutableArray * tempArray = [NSMutableArray new];
    [tempArray addObjectsFromArray:[self.delegate hookah_items]];
    [tempArray addObjectsFromArray:[self.delegate tobacco_items]];
    
    NSArray * resultArray = [NSArray arrayWithArray:tempArray];
    NSLog(@"HOOK1 %@",[self.delegate hookah_items]);
    NSLog(@"HOOK2 %@",[self.delegate tobacco_items]);
    return resultArray;
}


@end
