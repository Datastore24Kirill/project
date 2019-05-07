//
//  ViewForPickers.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 2/10/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewForPickersDelegate <NSObject>

@required
@property (strong, nonatomic) NSString * chooseTime;


@end

@interface ViewForPickers : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <ViewForPickersDelegate> delegate;
@property (strong, nonatomic)  UIPickerView * pickerHours;
@property (strong, nonatomic)  UIPickerView * pickerMinutes;

- (void) createPickersWithData: (NSArray*) data andNext:(BOOL) next count:(NSInteger) count;
- (void) deletePickers;

@end
