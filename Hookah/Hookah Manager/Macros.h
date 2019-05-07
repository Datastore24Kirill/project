//
//  Macros.h
//  ITDolgopa
//
//  Created by Viktor on 05.02.16.
//  Copyright © 2016 datastore24. All rights reserved.
//


#ifndef Macros_h
#define Macros_h




//Макросы для приложения ---------------------------------------------------

//Шрифты-------

#define HM_FONT_SF_DISPLAY_REGULAR @"SFUIDisplay-Regular"
#define HM_FONT_SF_DISPLAY_MEDIUM @"SFUIDisplay-Medium"
#define HM_FONT_NEUCGA_REGULAR @"Neucha"

//Цвета-------

#define HM_COLOR_BUTTON_PHONE_NEXT @"757575"

//Элементы под разные устройства----------------------------------------------
#define isiPhone7Plus  ([[UIScreen mainScreen] bounds].size.height == 736)?TRUE:FALSE
#define isiPhone7  ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define isiPhoneSE  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE








#endif /* Macros_h */
