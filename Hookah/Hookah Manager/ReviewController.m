//
//  ReviewController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 18.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ReviewController.h"
#import "ReviewModel.h"

@interface ReviewController () <ReviewModelDelegate>

@property (strong, nonatomic) ReviewModel * reviewModel;
@property (assign, nonatomic) NSInteger  countStars;

@end

@implementation ReviewController

- (void) loadView {
    [super loadView];
    
    self.viewComment.layer.cornerRadius = 5.f;
    
    [self setCustomTitle:@"Оставить отзыв"];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reviewModel = [[ReviewModel alloc] init];
    self.reviewModel.delegate = self;
    [self setRateWithNumber:0];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.textViewComment becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionButtonRate:(UIButton *)sender {
    
    for (int i = 0; i < self.buttonsRate.count; i++) {
        
        UIButton * button = [self.buttonsRate objectAtIndex:i];
        if ([sender isEqual:button]) {
            [self setRateWithNumber:i + 1];
        }
    }
}

- (void) actionBackButton: (UIBarButtonItem*) button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionButtonPublish:(UIButton *)sender {
    if(self.countStars == 0){
        [self showAlertWithMessage:@"Оцените заведение"];
    }else if (self.textViewComment.text.length == 0){
        [self showAlertWithMessage:@"Напишите комментарий"];
    }else{
        [self.reviewModel sendReview:^{
            [self showAlertWithMessageWithBlock:@"Отзыв успешно принят" block:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } mark:[NSString stringWithFormat:@"%ld",self.countStars]  comment:self.textViewComment.text];
    }
    
    
    NSLog(@"actionButtonPublish");
    
}

- (void) keyboardWillShow: (NSNotification*) notification {
    
    [self animationMethodWithDictParams:[self paramsKeyboardWithNotification:notification]];
}

- (void) keyboardWillHide: (NSNotification*) notification {
    
    [self animationMethodWithDictParams:[self paramsKeyboardWithNotification:notification]];
}

#pragma mark - Other

- (NSDictionary*) paramsKeyboardWithNotification: (NSNotification*) notification {
    
    CGFloat animationDuration = [[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    NSValue* keyboardFrameBegin = [notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGFloat heightValue = keyboardFrameBeginRect.origin.y;
    CGFloat heightCount = keyboardFrameBeginRect.size.height;
    
    NSDictionary * dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:animationDuration], @"animation",
                                 [NSNumber numberWithFloat:heightValue], @"height",
                                 [NSNumber numberWithFloat:heightCount], @"count", nil];
    return dictParams;
}

- (void) animationMethodWithDictParams: (NSDictionary*) dict{
    
    [UIView animateWithDuration:[[dict objectForKey:@"animation"] floatValue] animations:^{
        CGRect newRect = self.buttonPublish.frame;
        newRect.origin.y = [[dict objectForKey:@"height"] floatValue] - (CGRectGetHeight(newRect));
        NSLog(@"%f", [[dict objectForKey:@"height"] floatValue]);
        self.buttonPublish.frame = newRect;
        
    }];
}

- (void) setRateWithNumber: (NSInteger) number {
    self.countStars = number;
    for (int i = 0; i < self.buttonsRate.count; i++) {
        UIButton * button = [self.buttonsRate objectAtIndex:i];
        UIImage * image;
        if (number > i) {
            image = [UIImage imageNamed:@"bigStarImageOn"];
        } else {
            image = [UIImage imageNamed:@"bigStarImageOff"];
        }
        [button setImage:image forState:UIControlStateNormal];
    }
    
}

- (void) showErrorMessage: (NSString *) errorMsg{
    [self showAlertWithMessage:errorMsg];
}

@end
