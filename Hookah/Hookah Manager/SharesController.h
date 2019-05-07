//
//  SharesController.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "MainViewController.h"

@interface SharesController : MainViewController

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) NSString * fullName;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * information;
@property (strong, nonatomic) NSString * image_url;
@property (strong, nonatomic) NSArray * hookah_items;
@property (strong, nonatomic) NSArray * tobacco_items;

-(void) loadDefault:(NSString *) full_name name:(NSString *) name description:(NSString *) description image_url: (NSString *) image_url;

@end
