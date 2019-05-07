//
//  CellSharesView.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@protocol CellSharesViewDelegate;

@interface CellSharesView : UIView

@property (weak, nonatomic) id <CellSharesViewDelegate> delegate;

- (instancetype)initWithView: (UIView*) mainView andText: (NSString *) text andDictionary: (NSDictionary *) dictData;

@end

@protocol CellSharesViewDelegate <NSObject>

- (void) actionCellSharesViewDetail: (CellSharesView*) cellSharesView withButton: (CustomButton*) button;

@end
