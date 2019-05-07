//
//  OtherModel.h
//  Hookah Manager
//
//  Created by Кирилл Ковыршин on 31.03.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OtherModelDelegate <NSObject>

@required
@property (strong, nonatomic) NSString * starCount;
-(void) loadDefault:(NSDictionary *) dict;

@end

@interface OtherModel : NSObject

@property (assign, nonatomic) id <OtherModelDelegate> delegate;
-(void)loadProfile;

@end
