//
//  PasswordTableViewCell.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 06.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFild;

@end
