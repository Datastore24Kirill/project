//
//  FilterView.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "FilterView.h"

#import "UIView+BorderView.h"
#import "Macros.h"

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        UIView * borderViewTop = [UIView createBorderViewWithView:self andHeight:0];
        UIView * borderViewBot = [UIView createBorderViewWithView:self andHeight:49];
        [self addSubview:borderViewTop];
        [self addSubview:borderViewBot];
        
        
        
        self.buttonBookmark = [CustomButton buttonWithType:UIButtonTypeCustom];
        self.buttonBookmark.frame = CGRectMake(0.f, 0.f, 130.f, 50);
        self.buttonBookmark.backgroundColor = [UIColor clearColor];
        self.buttonBookmark.isBool = NO;
        [self.buttonBookmark addTarget:self action:@selector(actionButtonBookmark:)
                      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonBookmark];
        
        self.imageBookmark = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 26.f, 26)];
        self.imageBookmark.image = [UIImage imageNamed:@"bookmarkImageOff"];
        [self.buttonBookmark addSubview:self.imageBookmark];
        
        self.labelButtonBookMark = [[UILabel alloc] initWithFrame:CGRectMake(45.f, 0.f, 180, 50)];
        self.labelButtonBookMark.text = @"Избранные";
        self.labelButtonBookMark.textColor = [UIColor whiteColor];
        self.labelButtonBookMark.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:14];
        [self.buttonBookmark addSubview:self.labelButtonBookMark];
        
        self.buttonMap = [CustomButton buttonWithType:UIButtonTypeCustom];
        self.buttonMap.frame = CGRectMake(130.f, 0.f, 85.f, 50);
        self.buttonMap.backgroundColor = [UIColor clearColor];
        self.buttonMap.isBool = NO;
        [self.buttonMap addTarget:self action:@selector(actionButtonMap:)
                      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonMap];
        
        self.imageMap = [[UIImageView alloc] initWithFrame:CGRectMake(3, 15, 18.f, 22)];
        self.imageMap.image = [UIImage imageNamed:@"MapImageOff"];
        [self.buttonMap addSubview:self.imageMap];
        
        self.labelButtonMap = [[UILabel alloc] initWithFrame:CGRectMake(35.f, 0.f, 55, 50)];;
        self.labelButtonMap.text = @"Рядом";
        self.labelButtonMap.textColor = [UIColor whiteColor];
        self.labelButtonMap.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:14];
        [self.buttonMap addSubview:self.labelButtonMap];
        
        self.buttonOpen = [CustomButton buttonWithType:UIButtonTypeCustom];
        self.buttonOpen.frame = CGRectMake(215.f, 0.f, 105.f, 50);
        self.buttonOpen.backgroundColor = [UIColor clearColor];
        self.buttonOpen.isBool = NO;
        [self.buttonOpen addTarget:self action:@selector(actionButtonOpen:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonOpen];
        
        self.imageOpen = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 20.f, 20)];
        self.imageOpen.image = [UIImage imageNamed:@"timeImage"];
        [self.buttonOpen addSubview:self.imageOpen];
        
        self.labelButtonOpen = [[UILabel alloc] initWithFrame:CGRectMake(35.f, 0.f, 60, 50)];
        self.labelButtonOpen.text = @"Открыто";
        self.labelButtonOpen.textColor = [UIColor whiteColor];
        self.labelButtonOpen.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:14];
        [self.buttonOpen addSubview:self.labelButtonOpen];
        
    }
    return self;
}

#pragma mark - Actions

- (void) actionButtonBookmark: (CustomButton*) sender {
    
    [self.delegate actionButtonBookMark:self andButton:sender];
}

- (void) actionButtonMap: (CustomButton*) sender {
    [self.delegate actionButtonMap:self andButton:sender];
}

- (void) actionButtonOpen: (CustomButton*) sender {
    [self.delegate actionButtonOpen:self andButton:sender];
}

@end
