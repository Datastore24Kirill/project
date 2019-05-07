//
//  ReviewsView.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 16.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ReviewsView.h"
#import "HexColors.h"
#import "Macros.h"
#import "UIView+BorderView.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "DateTimeMethod.h"
#import "CustomButton.h"
#import "CustomLabel.h"

@implementation ReviewsView

- (instancetype)initWithView: (UIView*) mainView andDataReviews: (NSArray*) dataReviews
                    andTitle: (NSString*) title andFrame: (CGRect) frame
{
    self = [super init];
    if (self) {
        
        self.arrayViewes = [NSMutableArray array];
        
        self.nextHeight = 50;
        
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
        self.frame = frame;
        self.layer.cornerRadius = 5.f;
        [self.layer setShadowColor: [UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:5.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 13.f, 290.f, 21.f)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:HM_FONT_NEUCGA_REGULAR size:20];
        [self addSubview:titleLabel];
        
        
        
        for (int i = 0; i < dataReviews.count; i++) {
            
            UIView * cellView = [[UIView alloc] init];
            cellView.userInteractionEnabled = YES;
            cellView.backgroundColor = nil;
            [self addSubview:cellView];
            
            UIView * borderView = [UIView createGrayBorderViewWithView:mainView andHeight:0];
            [cellView addSubview:borderView];
        
            NSDictionary * dictData = [dataReviews objectAtIndex:i];
            
            UILabel * labelMessage = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f,
                                                                               CGRectGetWidth(mainView.bounds) - 30, 67.f)];
            labelMessage.numberOfLines = 0;
            labelMessage.text = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"comment"]];
            labelMessage.textColor = [UIColor hx_colorWithHexRGBAString:@"414141"];
            labelMessage.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:14];
            [cellView addSubview:labelMessage];
    
            CGFloat constant = 0;
            if ([self getLabelHeight:labelMessage] > 0 && [self getLabelHeight:labelMessage] < 67) {
                CGRect rect = labelMessage.frame;
                constant = 67 - [self getLabelHeight:labelMessage];
                rect.size.height = [self getLabelHeight:labelMessage];
                labelMessage.frame = rect;
            }
            
            cellView.frame = CGRectMake(0, self.nextHeight, mainView.frame.size.width, 150 - constant);
            
            self.nextHeight += cellView.frame.size.height;
            
            
            UIImageView * imageAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(12.f, 93.f - constant, 40.f, 40.f)];
            
            //SingleTone с ресайз изображения
            NSURL *imgURL = [NSURL URLWithString:[dictData objectForKey:@"visitor_avatar_url"]];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:imgURL
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished,
                                                                                                        NSURL *imageURL) {
                                    
                                    if(image){
                                        imageAvatar.layer.cornerRadius = 20.f;
                                        imageAvatar.clipsToBounds =YES;
                                        imageAvatar.image = image;
                                    }else{
                                        //Тут обработка ошибки загрузки изображения
                                    }
                                }];

            [cellView addSubview:imageAvatar];
            
            CustomLabel * labelName = [[CustomLabel alloc] initWithFrame:CGRectMake(64.f, 97.f - constant, 147.f, 16.f)];
            labelName.text = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"visitor_name"]];
            labelName.textColor = [UIColor hx_colorWithHexRGBAString:@"656565"];
            labelName.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_MEDIUM size:14];
            [cellView addSubview:labelName];

            NSDate * localDate = [DateTimeMethod timestampToDate:[dictData objectForKey:@"date_time"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [formatter setDateFormat:@"dd MMMM yyyy"];

            NSString *stringFromDate = [formatter stringFromDate:localDate];
            
                       CustomLabel * labelDate = [[CustomLabel alloc] initWithFrame:CGRectMake(64.f, 116.f - constant, 116.f, 14.f)];
            labelDate.text = [NSString stringWithFormat:@"%@",stringFromDate];
            labelDate.textColor = [UIColor hx_colorWithHexRGBAString:@"9E9E9E"];
            labelDate.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_MEDIUM size:12];
            [cellView addSubview:labelDate];
            
            for (int j = 0; j < 5; j++) {
                
                UIImageView * imageStarView = [[UIImageView alloc] initWithFrame:
                                               CGRectMake((CGRectGetWidth(mainView.bounds) - 95) + 16.f * j, 97.f - constant, 16.f, 16.f)];
                if ([[dictData objectForKey:@"mark"] integerValue] > j) {
                    imageStarView.image = [UIImage imageNamed:@"rateStarImageOn"];
                } else {
                    imageStarView.image = [UIImage imageNamed:@"rateStarImageOff"];
                }
                [cellView addSubview:imageStarView];
            }
            
            CGRect buttonFrame = CGRectZero;
            buttonFrame.size.width = CGRectGetWidth(cellView.bounds);
            buttonFrame.size.height = CGRectGetHeight(cellView.bounds);
            
            CustomButton * buttonShowText = [CustomButton buttonWithType:UIButtonTypeSystem];
            buttonShowText.frame = cellView.frame;
            buttonShowText.isBool = YES;
            [buttonShowText addTarget:self action:@selector(actionButtonShowText:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buttonShowText];
            
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   labelMessage, @"message", buttonShowText, @"button", cellView, @"view",  nil];

            [self.arrayViewes addObject:dict];
            
        }
        
        self.buttonReview = [UIButton buttonWithType:UIButtonTypeSystem];
        self.buttonReview.frame = CGRectMake(0.f, self.nextHeight, CGRectGetWidth(self.bounds), 50);
        self.buttonReview.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];
        [self.buttonReview setTitle:@"Оставить отзыв" forState:UIControlStateNormal];
        [self.buttonReview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.buttonReview addTarget:self action:@selector(actionButtonReview:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.buttonReview];
    }
    return self;
}

#pragma mark - Actions

- (void) actionButtonReview: (UIButton*) sender {
    
    [self.delegate actionAddReview:self andButton:sender];
}

- (void) actionButtonShowText: (CustomButton*) sender {
    
    for (int i = 0; i < self.arrayViewes.count; i++) {
        
        NSDictionary * dict = [self.arrayViewes objectAtIndex:i];
        
        if ([sender isEqual:[dict objectForKey:@"button"]]) {
            
            if ([self getLabelHeight:[dict objectForKey:@"message"]] > 67) {
                
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents]; //Блок анимации
                
                CGFloat size;
                if (sender.isBool) {
                    size = [self getLabelHeight:[dict objectForKey:@"message"]] - 67;
                    sender.size = size;
                } else {
                    size = -sender.size;
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect newRect = sender.frame;
                    newRect.size.height += size;
                    sender.frame = newRect;
                }];
                
                [self animNeedOnjectsInMainView:[dict objectForKey:@"view"] andSize:size];
                
                [self createAnimationWithNumaber:i andSize:size];
            } else {
                NSLog(@"Анимация не необходима");
            }
        }
    }
    if (sender.isBool) {
        sender.isBool = NO;
    } else {
        sender.isBool = YES;
    }
}

#pragma mark - Other

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

#pragma mark - Animation

- (void) createAnimationWithNumaber: (NSInteger) number andSize: (CGFloat) size {
    
    for (int i = 0; i < self.arrayViewes.count; i++) {
        if (i > number) {
            
            NSDictionary * dict = [self.arrayViewes objectAtIndex:i];
            UIView * view = [dict objectForKey:@"view"];
            CustomButton * button = [dict objectForKey:@"button"];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect newRect = view.frame;
                newRect.origin.y += size;
                view.frame = newRect;
                
                CGRect buttonRect = button.frame;
                buttonRect.origin.y += size;
                button.frame = buttonRect;
                
            }];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect mainRect = self.frame;
        mainRect.size.height += size;
        self.frame = mainRect;
        
        
        CGRect buttonRect = self.buttonReview.frame;
        buttonRect.origin.y += size;
        self.buttonReview.frame = buttonRect;
        [self.delegate setAnimashimMainView:self andSize:size];
    }completion:^(BOOL finished) {
        
    }];

}

- (void) animNeedOnjectsInMainView: (UIView*) mainView andSize: (CGFloat) size {
    
    for (UIView * view in mainView.subviews) {
        if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[CustomLabel class]]) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect newRect = view.frame;
                newRect.origin.y += size;
                view.frame = newRect;
            }];
        } else if (([view isKindOfClass:[UILabel class]] && ![view isKindOfClass:[CustomLabel class]])) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect newRect = view.frame;
                newRect.size.height += size;
                view.frame = newRect;
            }];
        }
    }
    
}





@end
