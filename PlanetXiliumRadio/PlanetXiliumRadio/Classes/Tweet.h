//
//  Tweet.h
//  PlanetXiliumRadio
//
//  Created by juan felippo on 23/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* screen_name;
@property (nonatomic,strong) NSString* text;
@property (nonatomic, strong) NSDate* created_at;
@property (nonatomic,strong) NSURL* profile_image_url;
@property (nonatomic,strong) NSURL* media_image_url;
@property (nonatomic,strong) NSURL* link_url;

- (id)initWithData:(NSDictionary *)data;

@end
