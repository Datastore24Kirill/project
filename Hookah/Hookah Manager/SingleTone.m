//
//  SingleTone.m
//  Sadovod
//
//  Created by Кирилл Ковыршин on 18.01.16.
//  Copyright © 2016 Viktor. All rights reserved.
//

#import "SingleTone.h"

@implementation SingleTone

@synthesize stringAlertForWebView;
@synthesize token;
@synthesize cityID;
@synthesize isOpenFilter;
@synthesize isMapFilter;
@synthesize isFavoriteFilter;
@synthesize dictOrder;
@synthesize changeCountry;
@synthesize arrayTime;
@synthesize stringFlavor;
@synthesize country;


#pragma mark Singleton Methods

+ (id)sharedManager{
    static SingleTone *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
