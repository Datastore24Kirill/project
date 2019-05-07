//
//  ReviewsView.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 16.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReviewsViewDelegate;

@interface ReviewsView : UIView

@property (weak, nonatomic) id <ReviewsViewDelegate> delegate;
@property (strong, nonatomic) UIButton * buttonReview;
@property (strong, nonatomic) NSMutableArray * arrayViewes; //Массив ячеек для опознавания необходимой при анимации

@property (assign, nonatomic) CGFloat nextHeight;



- (instancetype)initWithView: (UIView*) mainView andDataReviews: (NSArray*) dataReviews
                    andTitle: (NSString*) title andFrame: (CGRect) frame;

@end

@protocol ReviewsViewDelegate <NSObject>

- (void) actionAddReview: (ReviewsView*) reviewsView andButton: (UIButton*) button;
- (void) setAnimashimMainView: (ReviewsView*) reviewsView andSize: (CGFloat) size;


@end
