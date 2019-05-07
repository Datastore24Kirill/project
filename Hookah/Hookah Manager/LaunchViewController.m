//
//  LaunchViewController.m
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 26.12.16.
//  Copyright © 2016 Viktor Mishustin. All rights reserved.
//

#import "LaunchViewController.h"


@interface LaunchViewController ()


@end

@implementation LaunchViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
