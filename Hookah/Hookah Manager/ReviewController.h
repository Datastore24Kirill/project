//
//  ReviewController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 18.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface ReviewController : MainViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelRating;
@property (weak, nonatomic) IBOutlet UILabel *labelCommet;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsRate;
@property (weak, nonatomic) IBOutlet UIButton *buttonPublish;
@property (weak, nonatomic) IBOutlet UITextView *textViewComment;
@property (weak, nonatomic) IBOutlet UIView *viewComment;
@property (strong, nonatomic) NSString * outletID;

- (IBAction)actionButtonRate:(UIButton *)sender;
- (IBAction)actionButtonPublish:(UIButton *)sender;
- (void) showErrorMessage: (NSString *) errorMsg;

@end
