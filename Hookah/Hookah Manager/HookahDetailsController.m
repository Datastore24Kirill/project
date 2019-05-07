//
//  HookahDetailsController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 12.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "HookahDetailsController.h"
#import "OtherAddressView.h"
#import "SharesView.h"
#import "ReviewsView.h"
#import "HookahDetailsModel.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "ReviewController.h"
#import "SharesController.h"
#import "CustomButton.h"
#import "MapController.h"
#import "ChooseTableController.h"
#import "DateTimeMethod.h"
#import "SingleTone.h"


@interface HookahDetailsController () <OtherAddressViewDelegate, ReviewsViewDelegate,
                                        HookahDetailsModelDelegate, SharesViewDelgate>

@property (strong, nonatomic) OtherAddressView * otherAddressView;
@property (strong, nonatomic) NSArray * arrayOtherAddress;

@property (strong, nonatomic) SharesView * sharesView;

@property (strong, nonatomic) ReviewsView * reviewView;

@property (strong, nonatomic) HookahDetailsModel * detailModel;

@end

@implementation HookahDetailsController

- (void) loadView {
    [super loadView];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIImage *mapImage = [UIImage imageNamed:@"MapImageOff"];
    mapImage = [mapImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:mapImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionMapButton:)];
    self.navigationItem.rightBarButtonItem = mapButton;
    
    
    
    [self setCustomTitle:self.titleName];
    
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    self.currentLocalDate = [self getLocalDate];
    
    
    
    self.detailModel = [[HookahDetailsModel alloc] init];
    self.detailModel.delegate = self;
    
    NSString * outletID;
    if([self.outletID isEqual: [NSNull null]]){
        outletID = @"";
    }else{
        outletID = self.outletID;
    }
    
    [self.detailModel selectOutlets:outletID];
    
    //Кастомное числовое число для колличества звезд
    NSInteger starCountInteger = [self.starCount integerValue];
    
    for (int j = 0; j < 5; j++) {
        UIImageView * imageStarView = [self.imagesStar objectAtIndex:j];
        if (starCountInteger > j) {
            imageStarView.image = [UIImage imageNamed:@"rateStarImageOn"];
        } else {
            imageStarView.image = [UIImage imageNamed:@"rateStarImageOff"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createActivitiIndicatorAlertWithView];
    [self.detailModel selectOutlets:self.outletID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)actionButtonBookmarkOff:(UIButton *)sender {
    
    __block UIButton * buttonOn =self.buttonBookmarkOn;
    __block UIButton * buttonOff =self.buttonBookmarkOff;
    NSLog(@"ON");
     [self.detailModel setFavorites:YES andOutletID: self.outletID complitionBlock:^{
         [UIView animateWithDuration:0.2 animations:^{
             buttonOff.alpha = 0.f;
         } completion:^(BOOL finished) {
             [UIView animateWithDuration:0.2 animations:^{
                 buttonOn.alpha = 1.f;
             }];
         }];
     }];
    
    
    
}

- (IBAction)actionButtonBookmarkOn:(UIButton *)sender {
    NSLog(@"OFF");
    
    __block UIButton * buttonOn =self.buttonBookmarkOn;
    __block UIButton * buttonOff =self.buttonBookmarkOff;
    [self.detailModel setFavorites:NO andOutletID: self.outletID complitionBlock:^{
        
        [UIView animateWithDuration:0.2 animations:^{
            buttonOn.alpha = 0.f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
               buttonOff.alpha = 1.f;
            }];
        }];
        
    }];
}



- (void) actionBackButton: (UIBarButtonItem*) button {
    
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController popViewControllerAnimated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void) actionMapButton: (UIBarButtonItem*) button {
    self.hidesBottomBarWhenPushed = NO;
    MapController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"MapController"];
    detail.outletIDToLoad = self.outletID;
    detail.lonToLoad = self.lonMap;
    detail.latToLoad = self.latMap;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (IBAction)actionButtonBook:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = NO;
    ChooseTableController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTableController"];
    detail.outletID = self.outletID;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
    NSLog(@"actionButtonBook");
    
}

#pragma mark - OtherAddressViewDelegate

- (void) actionAdress: (OtherAddressView*) otherAddressView andButton: (CustomButton*) button {
    HookahDetailsController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HookahDetailsController"];
    detail.titleName = button.customTitleName;
    detail.orgID = button.customOrgID;
    detail.outletID = button.customOutletID;
    detail.imageStingURL = button.customImageURL;
    [self.navigationController pushViewController:detail animated:YES];
    
    NSLog(@"Address");
    
}

#pragma mark - ReviewsViewDelegate

- (void) actionAddReview: (ReviewsView*) reviewsView andButton: (UIButton*) button {
    
    self.hidesBottomBarWhenPushed = YES;
    ReviewController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewController"];
    detail.outletID = self.outletID;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void) setAnimashimMainView: (ReviewsView*) reviewsView andSize: (CGFloat) size {
    

        self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.reviewView.frame));

    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}

#pragma mark - SharesViewDelgate

- (void) actionShares: (SharesView*) sharesView withButtonShares: (CustomButton*) button {
    
    self.hidesBottomBarWhenPushed = YES;
    SharesController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"SharesController"];
    detail.fullName = button.customFullName;
    detail.name = button.customName;
    detail.information = button.customDescription;
    detail.image_url = button.customImageURL;
    detail.hookah_items = button.customArray;
    detail.tobacco_items = button.customArrayTwo;
    [self.navigationController pushViewController:detail animated:YES];
   
    
}

#pragma mark - HookahDetailsModelDelegate

-(void) loadDefault:(NSString *) address open:(NSString *) open close: (NSString *) close
       addressArray: (NSArray *) addressArray isFavorite:(NSString*) isFavorite{
    NSURL *imgURL = [NSURL URLWithString:self.imageStingURL];
    
    if([isFavorite integerValue]==0){
        self.buttonBookmarkOff.alpha = 1.f;
        self.buttonBookmarkOn.alpha = 0.f;
        
    }else{
        self.buttonBookmarkOff.alpha = 0.f;
        self.buttonBookmarkOn.alpha = 1.f;
        
    }
    
    //SingleTone с ресайз изображения
    
   
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imgURL
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if(image){
                                [self.mainImage setClipsToBounds:YES];
                                
                                //self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
                                self.mainImage.clipsToBounds =YES;
                                self.mainImage.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |
                                                                   UIViewAutoresizingFlexibleLeftMargin |
                                                                   UIViewAutoresizingFlexibleRightMargin |
                                                                   UIViewAutoresizingFlexibleHeight
                                                                   );
                                self.mainImage.image = image;
                                
                                self.addressLabel.text = address;
                            
                                
                                
                                
                                self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",open,close];
                                
                                
                                
                            }else{
                                //Тут обработка ошибки загрузки изображения
                                
                            }
                        }];
    [self deleteActivitiIndicator];
    
    self.arrayOtherAddress = addressArray;
    
    
    
    
    if (self.arrayOtherAddress.count > 1) {
        self.otherAddressView = [[OtherAddressView alloc] initWithData:self.arrayOtherAddress
                                                           andTitlName:@"Другие адреса" andView:self.view];
//        self.otherAddressView.frame = CGRectMake(0.f, CGRectGetMaxY(self.buttonBook.frame) + 10, 320.f, 23.f + 51 * self.arrayOtherAddress.count);
        self.otherAddressView.delegate = self;
        [self.mainScrollView addSubview:self.otherAddressView];
    }
    
    
    [self.detailModel setArrayShares];
    


}

-(void) loadShares:(NSArray *) sharesArray{
    CGRect rectShares = CGRectZero;
    rectShares.size = CGSizeMake(CGRectGetWidth(self.view.bounds), 90.f + 105.f * sharesArray.count);
    if (self.otherAddressView == nil) {
        rectShares.origin.y = CGRectGetMaxY(self.buttonBook.frame) + 34.f;
    } else {
        rectShares.origin.y = CGRectGetMaxY(self.otherAddressView.frame) + 7.f;
    }
    self.sharesView = [[SharesView alloc] initWithView:self.view andDataShares:sharesArray
                                              andTitle:@"Акции" andFrame:rectShares];
    self.sharesView.delegate = self;
    [self.mainScrollView addSubview:self.sharesView];
    
    [self.detailModel setArrayReviews];
    
}

-(void) loadReviews:(NSArray *) reviewsArray{
    CGRect rectReviews = CGRectZero;
    rectReviews.size = CGSizeMake(CGRectGetWidth(self.view.bounds), 100.f + 150 * reviewsArray.count);
    rectReviews.origin.y = CGRectGetMaxY(self.sharesView.frame) - 20.f;
    self.reviewView = [[ReviewsView alloc] initWithView:self.view andDataReviews:reviewsArray
                                               andTitle:@"Отзывы" andFrame:rectReviews];
    
    self.reviewView.frame = CGRectMake(0, CGRectGetMaxY(self.sharesView.frame) - 20.f, CGRectGetWidth(self.view.bounds), self.reviewView.nextHeight + 50);
    
    if (CGRectGetMaxY(self.reviewView.frame) < self.view.frame.size.height) {
        CGRect newFrame = self.reviewView.frame;
        newFrame.size.height += self.view.frame.size.height - (CGRectGetMaxY(self.reviewView.frame) + 64);
        self.reviewView.frame = newFrame;
        self.reviewView.buttonReview.frame = CGRectMake(0, self.reviewView.frame.size.height - 50, self.view.frame.size.width, 50);
    }
    
    self.reviewView.delegate = self;
    
    [self.mainScrollView addSubview:self.reviewView];
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.reviewView.frame));
}



@end
