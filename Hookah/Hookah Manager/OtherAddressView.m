//
//  otherAddressView.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 16.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "OtherAddressView.h"
#import "HexColors.h"
#import "Macros.h"
#import "UIView+BorderView.h"

@implementation OtherAddressView

- (instancetype)initWithData: (NSArray*) dataOtherAdress andTitlName: (NSString*) titlName andView: (UIView*) mainView
{
    self = [super init];
    if (self) {
        
        
        
        self.frame = CGRectMake(0.f, 298.f, 320.f, 23.f + 51 * (dataOtherAdress.count));
        if (isiPhone7) {
            self.frame = CGRectMake(0.f, 361.f, 320.f, 23.f + 51 * (dataOtherAdress.count));
        }
        if (isiPhone7Plus) {
            self.frame = CGRectMake(0.f, 424.f, 320.f, 23.f + 51 * (dataOtherAdress.count));
        }
        
        
        UILabel * titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 9.f, 290.f, 14.f)];
        titelLabel.text = titlName;
        titelLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];
        titelLabel.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:12];
        [self addSubview:titelLabel];

        for (int i = 0; i < dataOtherAdress.count; i++) {
            
            NSDictionary * dictOtherAddress = [dataOtherAdress objectAtIndex:i];
            
            CustomButton * buttonAddress = [CustomButton buttonWithType:UIButtonTypeSystem];
            buttonAddress.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |
                                              
                                              UIViewAutoresizingFlexibleHeight
                                              );;
            buttonAddress.frame = CGRectMake(15.f, 23.f + 51.f * i, 305.f, 51.f);
            buttonAddress.customTitleName = [dictOtherAddress objectForKey:@"name"];
            buttonAddress.customOrgID = [dictOtherAddress objectForKey:@"orgID"];
            buttonAddress.customOutletID = [dictOtherAddress objectForKey:@"outletID"];
            buttonAddress.customImageURL = [dictOtherAddress objectForKey:@"logoURL"];
            buttonAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [buttonAddress setTitle:[dictOtherAddress objectForKey:@"address"] forState:UIControlStateNormal];
            [buttonAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            buttonAddress.titleLabel.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:16];
            [buttonAddress addTarget:self action:@selector(actionButtonAddress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buttonAddress];
            
            UIImageView * imageArrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainView.bounds) - 19.f, 41.f + 51.f * i, 7.f, 14.f)];
            imageArrow.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |
                                          
                                           UIViewAutoresizingFlexibleHeight
                                           );;
            imageArrow.image = [UIImage imageNamed:@"imageArrow"];
            [self addSubview:imageArrow];
            
            UIView * borderView = [UIView createBorderViewWithView:mainView andHeight:73.f + 51.f * i];
            [self addSubview:borderView];
            
        }
    }
    return self;
}

#pragma mark - Action

- (void) actionButtonAddress: (UIButton*) sender {
    
    [self.delegate actionAdress:self andButton:sender];
    
}



@end
