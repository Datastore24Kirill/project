//
//  HookahDetailsController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 12.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"


@interface HookahDetailsController : MainViewController

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imagesStar;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) NSString * starCount;
@property (strong, nonatomic) NSString * titleName;
@property (strong, nonatomic) NSString * orgID;
@property (strong, nonatomic) NSString * outletID;
@property (strong, nonatomic) NSString * latMap;
@property (strong, nonatomic) NSString * lonMap;
@property (strong, nonatomic) NSString * imageStingURL;
@property (strong, nonatomic) NSDate * currentLocalDate;



@property (weak, nonatomic) IBOutlet UIButton *buttonBookmarkOn;
@property (weak, nonatomic) IBOutlet UIButton *buttonBookmarkOff;
@property (weak, nonatomic) IBOutlet UIButton *buttonBook;

- (IBAction)actionButtonBookmarkOff:(UIButton *)sender;
- (IBAction)actionButtonBookmarkOn:(UIButton *)sender;
- (IBAction)actionButtonBook:(UIButton *)sender;


-(void) loadDefault:(NSString *) address open:(NSString *) open close: (NSString *) close
       addressArray: (NSArray *) addressArray isFavorite:(NSString*) isFavorite;
- (void) loadReviews:(NSArray *) reviewsArray;
- (void) loadShares:(NSArray *) sharesArray;

@end
