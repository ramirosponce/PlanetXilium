//
//  Main.h
//  PlanetXiliumRadio
//
//  Created by Ramiro Ponce on 02/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#ifndef PlanetXiliumRadio_Main_h
#define PlanetXiliumRadio_Main_h

#endif

// FONTS
#define FONT_DOSIS_BOLD         @"Dosis-Bold"
#define FONT_DOSIS_EXTRABOLD    @"Dosis-ExtraBold"
#define FONT_DOSIS_EXTRALIGHT   @"Dosis-ExtraLight"
#define FONT_DOSIS_LIGHT        @"Dosis-Light"
#define FONT_MEDIUM             @"Dosis-Medium"
#define FONT_REGULAR            @"Dosis-Regular"
#define FONT_SEMIBOLD           @"Dosis-SemiBold"
#define FONT_TYPENOKSIDI        @"Typenoksidi"
#define FONT_LOBSTER            @"Lobster"
#define TWITTER_CONSUMER_KEY    @"hkc9nWvAAOVeOQwoIdUcOAdb1"
#define TWITTER_CONSUMER_SECRET @"SrCvXMyzgymCamtics966xj2AAUurGZs4YuIqhzQJ0G1YYpaMm"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_PHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

// MACRO COLOR
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RADIO_URL @"http://108.166.161.199:8430/listen.pls"

#define TWEER_USER @"planetaxilium"

