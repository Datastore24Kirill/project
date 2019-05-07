//
//  CustomButton.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomButtonDelegate <NSObject>

@optional
-(void) loadTableWithCustomID:(NSString *) customID andCustomName: (NSString *) customName;

@end

@interface CustomButton : UIButton

@property (assign, nonatomic) id <CustomButtonDelegate> delegate;

@property (assign, nonatomic) BOOL isBool;
@property (assign, nonatomic) CGFloat size;
@property (strong, nonatomic) NSString * customFullName;
@property (strong, nonatomic) NSString * customName;
@property (strong, nonatomic) NSString * customDescription;
@property (strong, nonatomic) NSString * customImageURL;
@property (strong, nonatomic) NSString * customID;
@property (strong, nonatomic) NSString * customIDWithDelegate;
@property (strong, nonatomic) NSArray * customArray;
@property (strong, nonatomic) NSArray * customArrayTwo;


@property (strong, nonatomic) NSString * customTitleName;
@property (strong, nonatomic) NSString * customOrgID;
@property (strong, nonatomic) NSString * customOutletID;
@property (strong, nonatomic) NSString * customimageStingURL;

@property (assign, nonatomic) NSInteger type;




@end
