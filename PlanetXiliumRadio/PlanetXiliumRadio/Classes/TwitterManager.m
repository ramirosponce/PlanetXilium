//
//  TwitterManager.m
//  PlanetXiliumRadio
//
//  Created by juan felippo on 20/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import "TwitterManager.h"
#import "STTwitter.h"

@implementation TwitterManager
{
    STTwitterAPI *twitter;
}
static TwitterManager * sharedInstance = nil;

#pragma mark -
#pragma mark Singleton methods

-(id)init
{
    if(self = [super init])
    {
        /* Init Singleton */
        twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY
        consumerSecret:TWITTER_CONSUMER_SECRET];
    }
    return self;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

+(TwitterManager *)sharedManager
{
    @synchronized (self)
    {
		if (sharedInstance == nil)
			[[self alloc] init];
	}
	return sharedInstance;
}

-(void)getTweetList:(NSString *)screenName
              count:(NSUInteger)count
       successBlock:(void(^)(NSArray *statuses))successBlock
         errorBlock:(void(^)(NSError *error))errorBlock{
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [twitter getUserTimelineWithScreenName:screenName count:count successBlock:successBlock errorBlock:errorBlock];
        
    } errorBlock:errorBlock];
}
@end
