//
//  SharesView.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 16.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "SharesView.h"
#import "HexColors.h"
#import "Macros.h"
#import "UIView+BorderView.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения


@implementation SharesView

- (instancetype)initWithView: (UIView*) mainView andDataShares: (NSArray*) dataShares
                    andTitle: (NSString*) title andFrame: (CGRect) frame
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.frame = frame;
        self.layer.cornerRadius = 5.f;
        
        
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 13.f, 290.f, 21.f)];
//        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:HM_FONT_NEUCGA_REGULAR size:20];
        [self addSubview:titleLabel];
        
        for (int i = 0; i < dataShares.count; i++) {
            
            NSDictionary * dictData = [dataShares objectAtIndex:i];
            
            
            
            UIView * borderView = [UIView createGrayBorderViewWithView:mainView andHeight:50.f + 105.f * i];
            [self addSubview:borderView];
            
            UIImageView * mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 65.f + 105.f * i, 100.f, 75.f)];
            mainImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            //SingleTone с ресайз изображения
            
            NSURL *imgURL = [NSURL URLWithString:[dictData objectForKey:@"image_url"]];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:imgURL
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished,
                                                                                                        NSURL *imageURL) {
                                    
                                    if(image){
                                        
                                        //self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
                                      
                                        mainImage.clipsToBounds =YES;
                                        mainImage.image = image;
                                        
                                    }else{
                                        //Тут обработка ошибки загрузки изображения
                                    }
                                }];

            
            
            [self addSubview:mainImage];
            
            UILabel * shareTitle = [[UILabel alloc] initWithFrame:CGRectMake(130.f, 65.f + 105.f * i,
                                                                             CGRectGetWidth(mainView.bounds) - 145, 14.f)];
            shareTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            shareTitle.text = [dictData objectForKey:@"name"];
            shareTitle.textColor = [UIColor hx_colorWithHexRGBAString:@"29B98F"];
            shareTitle.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_MEDIUM size:12];
            [self addSubview:shareTitle];
            
            UILabel * labelText = [[UILabel alloc] initWithFrame:CGRectMake(130, 84.f + 105.f * i,
                                                                            CGRectGetWidth(mainView.bounds) - 145, 56)];
            labelText.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            labelText.numberOfLines = 4;
            labelText.text = [dictData objectForKey:@"description"];
            labelText.textColor = [UIColor hx_colorWithHexRGBAString:@"656565"];
            labelText.font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:12];
            [labelText sizeToFit];
            [self addSubview:labelText];
            
            CustomButton * buttonShares = [CustomButton buttonWithType:UIButtonTypeCustom];
            
            buttonShares.customFullName = [dictData objectForKey:@"full_name"];
            buttonShares.customName = [dictData objectForKey:@"name"];
            buttonShares.customDescription = [dictData objectForKey:@"description"];
            buttonShares.customImageURL = [dictData objectForKey:@"image_url"];
            buttonShares.customArray = [dictData objectForKey:@"hookah_items"];
            buttonShares.customArrayTwo = [dictData objectForKey:@"tobacco_items"];
            buttonShares.frame = CGRectMake(0, 50 + 105 * i, mainView.bounds.size.width, 105);
            [buttonShares addTarget:self action:@selector(actionButtonShares:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buttonShares];

        }

    }
    return self;
}

#pragma mark - Actions

- (void) actionButtonShares: (CustomButton*) sender {
    
    [self.delegate actionShares:self withButtonShares:sender];
    
}



@end
