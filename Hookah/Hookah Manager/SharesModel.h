//
//  SharesModel.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SharesModelDelegate <NSObject>

@required

@property (strong, nonatomic) NSArray * hookah_items;
@property (strong, nonatomic) NSArray * tobacco_items;


@end

@interface SharesModel : NSObject
@property (assign, nonatomic) id <SharesModelDelegate> delegate;
- (NSArray*) setArray;

@end
