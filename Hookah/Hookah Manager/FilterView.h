//
//  FilterView.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol FilterViewDelegate;

@interface FilterView : UIView

//Buttons
@property (strong, nonatomic) CustomButton * buttonBookmark;
@property (strong, nonatomic) CustomButton * buttonMap;
@property (strong, nonatomic) CustomButton * buttonOpen;

//TextLabels
@property (strong, nonatomic) UILabel * labelButtonBookMark;
@property (strong, nonatomic) UILabel * labelButtonMap;
@property (strong, nonatomic) UILabel * labelButtonOpen;

//ImageView
@property (strong, nonatomic) UIImageView * imageBookmark;
@property (strong, nonatomic) UIImageView * imageMap;
@property (strong, nonatomic) UIImageView * imageOpen;

@property (weak, nonatomic) id <FilterViewDelegate> delegate;

@end

@protocol FilterViewDelegate <NSObject>

- (void) actionButtonBookMark: (FilterView*) filterView andButton: (CustomButton*) sender;
- (void) actionButtonMap: (FilterView*) filterView andButton: (CustomButton*) sender;
- (void) actionButtonOpen: (FilterView*) filterView andButton: (CustomButton*) sender;

@end
