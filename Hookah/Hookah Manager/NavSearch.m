//
//  NavSearch.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 26.01.17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "NavSearch.h"
#import "Macros.h"
#import "HexColors.h"

@implementation NavSearch

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIFont *font = [UIFont fontWithName:HM_FONT_SF_DISPLAY_REGULAR size:14.0];
        UIColor * color = [UIColor hx_colorWithHexRGBAString:@"bababa"];
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        self.textFildSearch = [[UITextField alloc] initWithFrame:CGRectMake(30.f, self.bounds.origin.y, CGRectGetWidth(self.bounds) - 30, self.bounds.size.height)];
        self.textFildSearch.spellCheckingType = UITextSpellCheckingTypeNo;
        self.textFildSearch.autocorrectionType= UITextAutocorrectionTypeNo;
        self.textFildSearch.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textFildSearch.font = font;
        self.textFildSearch.textColor = color;
        
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Поиск" attributes:attrsDictionary];
        self.textFildSearch.attributedPlaceholder = attrString;
        [self addSubview:self.textFildSearch];
        
        UIImageView * imageMagnifier = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 6.f, 12.f, 12.f)];
        imageMagnifier.image = [UIImage imageNamed:@"magnifierImage"];
        [self addSubview:imageMagnifier];
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
        
        
    }
    return self;
}

- (void) handleSingleTap: (UITapGestureRecognizer*) gester {
    if (![self.textFildSearch isFirstResponder]) {
        [self.textFildSearch becomeFirstResponder];
    }
}

@end
