//
//  ReviewModel.h
//  Hookah Manager
//
//  Created by Виктор Мишустин on 18.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReviewModelDelegate <NSObject>

@required
@property (strong, nonatomic) NSString * outletID;

@optional
- (void) showErrorMessage: (NSString *) errorMsg;

@end

@interface ReviewModel : NSObject
@property (assign, nonatomic) id <ReviewModelDelegate> delegate;
-(void) sendReview: (void (^) (void)) compilationBack mark: (NSString *) mark comment: (NSString *) comment;

@end
