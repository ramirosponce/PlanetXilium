//
//  TwitterManager.h
//  PlanetXiliumRadio
//
//  Created by juan felippo on 20/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TweetListCompletionHandler)(BOOL success, NSError *error);

@interface TwitterManager : NSObject

@property (nonatomic, strong) NSMutableArray* tweetList;

+ (TwitterManager *) sharedManager;

-(void)getTweetList: (NSString *)screenName
              count:(NSUInteger)count
       successBlock:(void(^)(NSArray *statuses))successBlock
         errorBlock:(void(^)(NSError *error))errorBlock;

@end
