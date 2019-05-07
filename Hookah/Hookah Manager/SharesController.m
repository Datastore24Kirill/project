//
//  SharesController.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 20.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "SharesController.h"
#import "SharesModel.h"
#import "CellSharesView.h"
#import "HookahDetailController.h"
#import <SDWebImage/UIImageView+WebCache.h> //Загрузка изображения
#import "CustomButton.h"

@interface SharesController () <CellSharesViewDelegate,SharesModelDelegate>

@property (strong, nonatomic) NSArray * arrayData;

@end

@implementation SharesController

- (void) loadView {
    [super loadView];
    
    self.textView.layer.cornerRadius = 5.f;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    UIImage *myImage = [UIImage imageNamed:@"backButtonImage"];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:myImage style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
    


}

- (void)viewDidLoad {
    [super viewDidLoad];
    ((UIScrollView *)self.view).showsVerticalScrollIndicator = false;
    
    [self loadDefault:self.fullName name:self.name description:self.information image_url:self.image_url];
    SharesModel * sharesModel = [[SharesModel alloc] init];
    
    sharesModel.delegate = self;
    self.arrayData = [sharesModel setArray];
    
        for (int i = 0; i < self.arrayData.count; i++) {
            NSDictionary * sharesDict = [self.arrayData objectAtIndex:i];
            CellSharesView * viewDetail = [[CellSharesView alloc] initWithView:self.view andText:[sharesDict objectForKey:@"name"] andDictionary:sharesDict];
            CGRect rectView = viewDetail.frame;
            rectView.origin.y += CGRectGetHeight(viewDetail.bounds) * i;
            viewDetail.frame = rectView;
            viewDetail.delegate = self;
            [self.mainScrollView addSubview:viewDetail];
        }
    CGFloat count;
    NSLog(@"SIZZZ %f",[self getLabelHeight:self.textLabel]);
    if([self getLabelHeight:self.textLabel]>65){
        count = [self getLabelHeight:self.textLabel];
      
        
    }else{
        count = 0;
    }
    
    
    self.mainScrollView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.mainScrollView.frame) , (50 * self.arrayData.count));
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
 
    [self.textLabel sizeToFit];
    self.textView.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.mainImageView.frame),
                                     CGRectGetWidth(self.textView.frame),
                                     CGRectGetHeight(self.titleLabel.frame) + 11 + CGRectGetHeight(self.textLabel.frame) + 11);
    self.mainScrollView.frame = CGRectMake(0,
                                           CGRectGetMaxY(self.textView.frame),
                                           CGRectGetWidth(self.mainScrollView.frame),
                                           CGRectGetHeight(self.mainScrollView.frame));
    ((UIScrollView *)self.view).contentSize = CGSizeMake(CGRectGetWidth(self.view.frame),
                                                         CGRectGetMaxY(self.mainScrollView.frame));
    CGFloat backgroundImageViewHeight = ((UIScrollView *)self.view).contentSize.height > self.view.frame.size.height ? ((UIScrollView *)self.view).contentSize.height : self.view.frame.size.height;
    self.backgroundImageView.frame = CGRectMake(0,
                                                0,
                                                ((UIScrollView *)self.view).contentSize.width,
                                                backgroundImageViewHeight);
}

#pragma mark - Actions

- (void) actionBackButton: (UIBarButtonItem*) button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CellSharesViewDelegate

- (void) actionCellSharesViewDetail: (CellSharesView*) cellSharesView withButton: (CustomButton*) button {
    
    self.hidesBottomBarWhenPushed = YES;
   HookahDetailController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HookahDetailController"];
    NSLog(@"NULLED %@,%@,%@,%@",button.customFullName,button.customName,button.customDescription,button.customImageURL);
    
    detail.fullName = button.customFullName;
    detail.name = button.customName;
    detail.information = button.customDescription;
    detail.image_url = button.customImageURL;

    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark - SharesModelDelegate

-(void) loadDefault:(NSString *) full_name name:(NSString *) name description:(NSString *) description image_url: (NSString *) image_url{
    
    
    NSURL *imgURL = [NSURL URLWithString:image_url];
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
                                
                                [self setCustomTitle:name];
                                self.textLabel.text = description;
                                [self.textLabel setNumberOfLines:0];                                
                                self.titleLabel.text = full_name;
                            }else{
                                //Тут обработка ошибки загрузки изображения
                            }
                        }];
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

@end
