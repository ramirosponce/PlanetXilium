//
//  Tweet.m
//  PlanetXiliumRadio
//
//  Created by juan felippo on 23/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        self.name = [[data objectForKey:@"user"]objectForKey:@"name"];
        self.screen_name = [NSString stringWithFormat:@"@%@",[[data objectForKey:@"user"]objectForKey:@"screen_name"]];
        self.text = [data objectForKey:@"text"];
        self.profile_image_url = [NSURL URLWithString: [[data objectForKey:@"user"]objectForKey:@"profile_image_url"]];
        NSArray *mediaData=[[data objectForKey:@"entities"]objectForKey:@"media"];
        if (mediaData) {
            NSDictionary *dataDic= [mediaData objectAtIndex:0];
            self.media_image_url =  [NSURL URLWithString: [dataDic objectForKey:@"media_url"]];
        }else
            self.media_image_url = nil;
        NSArray *linkData=[[data objectForKey:@"entities"]objectForKey:@"urls"];
        if (linkData.count>0) {
            NSDictionary *linkDic= [linkData objectAtIndex:0];
            self.link_url =  [NSURL URLWithString: [linkDic objectForKey:@"expanded_url"]];
        }
        else
            self.link_url =  nil;
        
    }
    return self;
}

@end
