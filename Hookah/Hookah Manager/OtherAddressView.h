//
//  otherAddressView.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 16.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol OtherAddressViewDelegate;

@interface OtherAddressView : UIView

@property (weak, nonatomic) id <OtherAddressViewDelegate> delegate;

- (instancetype)initWithData: (NSArray*) dataOtherAdress andTitlName: (NSString*) titlName andView: (UIView*) mainView;

@end

@protocol OtherAddressViewDelegate <NSObject>

- (void) actionAdress: (OtherAddressView*) otherAddressView andButton: (UIButton*) button;

@end
