//
//  ReviewModel.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 18.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ReviewModel.h"
#import "APIManger.h"
#import "SingleTone.h"

@implementation ReviewModel
@synthesize delegate;

-(void) sendReview: (void (^) (void)) compilationBack mark: (NSString *) mark comment: (NSString *) comment{
    
    APIManger * apiManager = [[APIManger alloc] init];
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [self.delegate outletID],@"outlet_id",
                             mark,@"mark",
                             comment,@"comment",nil];
    [apiManager postDataFromSeverWithMethod:@"outlet.sendReview" andParams:params andToken:[[SingleTone sharedManager] token] complitionBlock:^(id response) {
        NSLog(@"RESP %@",response);
        if([response objectForKey:@"error_code"]){
            NSLog(@"Ошибка сервера код: %@, сообщение: %@",[response objectForKey:@"error_code"],
                  [response objectForKey:@"error_msg"]);
            NSInteger errorCode = [[response objectForKey:@"error_code"] integerValue];
            if(errorCode == 362){
                [self.delegate showErrorMessage:@"Вы уже оставляли отзыв\nна это заведение"];
            }
            if(errorCode == 363){
                [self.delegate showErrorMessage:@"Текст комментария содержит мат,\nэто не допустимо"];
            }
        }else{
            compilationBack();
        }
    }];
    
}

@end
