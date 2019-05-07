//
//  CellSharesView.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "CellSharesView.h"
#import "UIView+BorderView.h"
#import "Macros.h"
#import "HexColors.h"

@implementation CellSharesView

- (instancetype)initWithView: (UIView*) mainView andText: (NSString *) text andDictionary: (NSDictionary *) dictData {
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(mainView.bounds), 50.f);
        
        UIView * borderView = [UIView createBorderViewWithView:self andHeight:49.f];
        [self addSubview:borderView];
        
        UILabel * labelName = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 5.f, 200, 40.f)];
        labelName.text = text;
        labelName.textColor = [UIColor whiteColor];
        labelName.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:16];
        [self addSubview:labelName];
        
        UIImageView * imageShares = [[UIImageView alloc] initWithFrame:
                                     CGRectMake(CGRectGetWidth(mainView.bounds) - 87.f, 10.f, 30.f, 30.f)];
        imageShares.image = [UIImage imageNamed:@"sharesImage"];
        
        
        
        [self addSubview:imageShares];
        
        CustomButton * buttonDetail = [CustomButton buttonWithType:UIButtonTypeCustom];
        buttonDetail.customName = [dictData objectForKey:@"name"];
        buttonDetail.customFullName = [dictData objectForKey:@"full_name"];
        buttonDetail.customDescription = [dictData objectForKey:@"description"];
        buttonDetail.customImageURL = [dictData objectForKey:@"image_url"];
        buttonDetail.frame = CGRectMake(CGRectGetWidth(mainView.bounds) - 44.f, 10.f, 32.f, 30.f);
        [buttonDetail setImage:[UIImage imageNamed:@"buttonSharesDetail"] forState:UIControlStateNormal];
        [buttonDetail addTarget:self action:@selector(actionButtonDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonDetail];

    }
    return self;
}

#pragma mark - Actions

- (void) actionButtonDetail: (CustomButton*) sender {
    
    [self.delegate actionCellSharesViewDetail:self withButton:sender];
    
}


@end
