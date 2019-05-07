//
//  HookahDetailController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface HookahDetailController : MainViewController

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) NSString * fullName;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * information;
@property (strong, nonatomic) NSString * image_url;

@end
