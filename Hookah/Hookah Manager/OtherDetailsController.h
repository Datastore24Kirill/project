//
//  OtherDetailsController.h
//  Hookah Manager
//
//  Created by Mac_Work on 24.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface OtherDetailsController : MainViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonChangePhoto;
@property (strong, nonatomic) NSDictionary * profileInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonCountry;
@property (weak, nonatomic) IBOutlet UIButton *buttonCity;
@property (weak, nonatomic) IBOutlet UIButton *buttonName;
@property (weak, nonatomic) IBOutlet UIButton *buttonDateBirthday;


- (IBAction)actionButtonChangePhoto:(UIButton*)sender;


- (IBAction)actionChangeCountryButton:(UIButton*)sender;
- (IBAction)actionChangeCityButton:(UIButton*)sender;
- (IBAction)actionChangeNameButton:(UIButton*)sender;
- (IBAction)actionChangeDataBirthdayButton:(UIButton*)sender;
- (void) saveCity:(NSString *) cityID;



@end
