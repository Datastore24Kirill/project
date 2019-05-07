//
//  SelectCategoryView.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 10.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+CustomButton.h"

@protocol SelectCategoryViewDelegate;

@interface SelectCategoryView : UIView

@property (strong, nonatomic) UIImageView * mainImage;
@property (strong, nonatomic) UIImageView * bookmarkImage;
@property (strong, nonatomic) NSMutableArray * rateStarsArray;
@property (strong, nonatomic) UIButton * buttonCategory;
@property (strong, nonatomic) NSString * titleName;
@property (strong, nonatomic) NSString * orgID;
@property (strong, nonatomic) NSString * imageStingURL;
@property (strong, nonatomic) NSString * starCount;




@property (weak, nonatomic) id <SelectCategoryViewDelegate> delegate;

//Инициализация
- (instancetype)initWithPoint:(CGPoint)point andMainImage: (NSString*) mainImage
                  andBookmark: (BOOL) bookmark andNumberStars: (NSInteger) numberStars andName: (NSString*) name andOrgID:(NSString *) orgID;


@end

@protocol SelectCategoryViewDelegate <NSObject>

- (void) actionSelectCategoryView: (SelectCategoryView*) selectCategoryView andButton: (UIButton*) sender;

@end
