//
//  SingleTone.h
//  Sadovod
//
//  Created by Кирилл Ковыршин on 18.01.16.
//  Copyright © 2016 Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChooseTableModel.h"

@interface SingleTone : NSObject


@property (strong, nonatomic) NSString * stringAlertForWebView;
@property (strong, nonatomic) NSString * token;
@property (strong, nonatomic) NSDate * birthdayDate;
@property (strong, nonatomic) NSString * cityID;
@property (strong, nonatomic) NSMutableDictionary * dictOrder;
@property (strong, nonatomic) NSMutableDictionary * dictOrderChanhge;

@property (assign, nonatomic) BOOL isFavoriteFilter;
@property (assign, nonatomic) BOOL isMapFilter;
@property (assign, nonatomic) BOOL isOpenFilter;

@property (assign, nonatomic) BOOL changeCountry;
@property (strong, nonatomic) NSString * country;

@property (strong, nonatomic) ChooseTableModel * arrayTime;
@property (strong, nonatomic) NSString * stringFlavor;
@property (strong, nonatomic) NSString * stringOther;



+ (id)sharedManager;

@end
