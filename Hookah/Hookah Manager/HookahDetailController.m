//
//  HookahDetailController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "HookahDetailController.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения

@interface HookahDetailController ()

@end

@implementation HookahDetailController

- (void) loadView {
    [super loadView];
    
    [self setCustomTitle:self.name];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.textView.layer.cornerRadius = 5.f;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefault];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) actionBackButton: (UIBarButtonItem*) button {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadDefault{
    [self createActivitiIndicatorAlertWithView];
    NSURL *imgURL = [NSURL URLWithString:self.image_url];
    //SingleTone с ресайз изображения
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imgURL
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if(image){
                                [self.mainImageView setClipsToBounds:YES];
                                
                                //self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
                                
                                self.mainImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |
                                                                       UIViewAutoresizingFlexibleLeftMargin |
                                                                       UIViewAutoresizingFlexibleRightMargin |
                                                                       UIViewAutoresizingFlexibleHeight
                                                                       );
                                self.mainImageView.image = image;
                                // Create a gradient layer
                                CAGradientLayer *layerTop = [CAGradientLayer layer];
                                // gradient from transparent to black
                                layerTop.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor clearColor].CGColor];
                                // set frame to whatever values you like (not hard coded like here of course)
                                layerTop.frame = CGRectMake(0.0f, -60.0f, self.mainImageView.frame.size.width, 184.0);
                                // add the gradient layer as a sublayer of you image view
                                [self.mainImageView.layer addSublayer:layerTop];
                                
                                // Create a gradient layer
                                CAGradientLayer *layerBottom = [CAGradientLayer layer];
                                // gradient from transparent to black
                                layerBottom.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
                                // set frame to whatever values you like (not hard coded like here of course)
                                layerBottom.frame = CGRectMake(0.0f, 114.0f, self.mainImageView.frame.size.width, 140.0);
                                // add the gradient layer as a sublayer of you image view
                                [self.mainImageView.layer addSublayer:layerBottom];
                                
                                if(![self.information isEqual:[NSNull null]]){
                                        self.textLabel.text = self.information;
                                }else{
                                    self.textLabel.text = @"";
                                }
                                
                                [self.textLabel setNumberOfLines:0];
                                [self.textLabel sizeToFit];
                               
                                if(![self.fullName isEqual:[NSNull null]]){
                                    self.titleLabel.text = self.fullName;
                                }else{
    
                                    self.titleLabel.text = @"";
                                }
                                
                                [self deleteActivitiIndicator];
                                
                                
                            }else{
                                //Тут обработка ошибки загрузки изображения
                            }
                        }];
}

@end
