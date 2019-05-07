//
//  SharesView.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 16.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol SharesViewDelgate;

@interface SharesView : UIView

@property (weak, nonatomic) id <SharesViewDelgate> delegate;

- (instancetype)initWithView: (UIView*) mainView andDataShares: (NSArray*) dataShares
                    andTitle: (NSString*) title andFrame: (CGRect) frame;


@end

@protocol SharesViewDelgate <NSObject>


- (void) actionShares: (SharesView*) sharesView withButtonShares: (CustomButton*) button;

@end
