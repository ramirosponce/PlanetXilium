//
//  TweetCollectionViewCell.h
//  PlanetXiliumRadio
//
//  Created by juan felippo on 13/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCollectionViewCell : UICollectionViewCell
{
    __weak IBOutlet UIImageView* tweetImage;
    __weak IBOutlet UILabel* tweetText;
    __weak IBOutlet UILabel* tweetScreenName;
    __weak IBOutlet UILabel* tweetName;
}
-(void) populate: (Tweet*)tweet;
@end
