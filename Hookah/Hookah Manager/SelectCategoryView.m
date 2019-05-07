//
//  SelectCategoryView.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 10.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "SelectCategoryView.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "Macros.h"

@implementation SelectCategoryView

- (instancetype)initWithPoint:(CGPoint)point andMainImage: (NSString*) mainImage
                  andBookmark: (BOOL) bookmark andNumberStars: (NSInteger) numberStars
                      andName: (NSString*) name andOrgID:(NSString *) orgID
{
    self = [super init];
    if (self) {
        
        for(UIView * view in self.subviews) {
            
            [view removeFromSuperview];
            
        }
        
        self.rateStarsArray = [NSMutableArray array];
        
        self.frame = CGRectMake(point.x, point.y, 160.f, 140.f);
        if (isiPhone7) {
            self.frame = CGRectMake(point.x, point.y, 187.5f, 164.f);
        } else if (isiPhone7Plus) {
            self.frame = CGRectMake(point.x, point.y, 207.f, 181.1f);
        }

        
        self.buttonCategory = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect buttonRect = CGRectZero;
        buttonRect.size.height = CGRectGetHeight(self.bounds);
        buttonRect.size.width = CGRectGetWidth(self.bounds);
        self.buttonCategory.frame = buttonRect;
        self.titleName = name;
        self.orgID = orgID;
        self.starCount = [NSString stringWithFormat:@"%ld",numberStars];
        self.imageStingURL = mainImage;
        [self.buttonCategory addTarget:self action:@selector(actionButtonCategory:)
                                            forControlEvents:UIControlEventTouchUpInside];
        self.buttonCategory.backgroundColor = [UIColor clearColor];
        [self addSubview:self.buttonCategory];
        
        
        //self.mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(11.f, -11.f, 139.f, 139.f)];
        self.mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 10.f, 160.f, 100.f)];
        if (isiPhone7) {
            self.mainImage.frame = CGRectMake(0.f, 10.f, 187.5f, 117.f);
        } else if (isiPhone7Plus) {
            self.mainImage.frame = CGRectMake(0.f, 10.f, 207.f, 129.3f);
        }
        NSURL *imgURL = [NSURL URLWithString:mainImage];
        
        

        //SingleTone с ресайз изображения
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:imgURL
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                                                                        BOOL finished, NSURL *imageURL) {
                                
                                if(image){
                                    [self.mainImage setClipsToBounds:YES];
                                    
                                    //self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
                                    self.mainImage.clipsToBounds =YES;
                                     self.mainImage.image = image;
                                     [self.buttonCategory addSubview:self.mainImage];
                                    self.bookmarkImage = [[UIImageView alloc] initWithFrame:CGRectMake(122.f, 5.f, 32.f, 32.f)];
                                    if (isiPhone7) {
                                        self.bookmarkImage.frame = CGRectMake(144.f, 6.f, 37.5f, 37.5f);
                                    } else if (isiPhone7Plus) {
                                        self.bookmarkImage.frame = CGRectMake(165.6f, 8.f, 41.4f, 41.4f);
                                    }
                                    
                                    
                                    if (bookmark) {
                                        self.bookmarkImage.image = [UIImage imageNamed:@"bookmarkImageOn"];
                                    } else {
                                        self.bookmarkImage.image = [UIImage imageNamed:@"bookmarkImageOff"];
                                    }
                                    [self.buttonCategory addSubview:self.bookmarkImage];
                                    
                                    for (int i = 0; i < 5; i++) {
                                        
                                        UIImageView * imageView = [[UIImageView alloc] initWithFrame:
                                                                   CGRectMake(40.f + 16.f * i, 110.f, 16.f, 16.f)];
                                        if (isiPhone7) {
                                            imageView.frame = CGRectMake(46.88f + 18.75f * i, 129.f, 18.75f, 18.75f);
                                        } else if (isiPhone7Plus) {
                                            imageView.frame = CGRectMake(51.75f + 20.7f * i, 142.3f, 20.7f, 20.7f);
                                        }
                                        if (numberStars > i) {
                                            imageView.image = [UIImage imageNamed:@"rateStarImageOn"];
                                        } else {
                                            imageView.image = [UIImage imageNamed:@"rateStarImageOff"];
                                        }
                                        [self.rateStarsArray addObject:imageView];
                                        [self.buttonCategory addSubview:imageView];
                                    }

                                   

                                }else{
                                    
                                }
                            }];

        

           }
    return self;
}

#pragma mark - Action

- (void) actionButtonCategory: (UIButton*) sender {
    
    [self.delegate actionSelectCategoryView:self andButton:sender];
    
}



@end
