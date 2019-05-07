//
//  MapController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 27.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface MapController : MainViewController

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) NSString * outletIDToLoad;
@property (strong, nonatomic) NSString * latToLoad;
@property (strong, nonatomic) NSString * lonToLoad;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *rateStarsImages;

@property (weak, nonatomic) IBOutlet UIButton *buttonDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonBook;

- (IBAction)actionButtonDetails:(id)sender;
- (IBAction)actionButtonBook:(id)sender;



@end
