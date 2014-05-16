//
//  TweetTableViewCell.h
//  PlanetXiliumRadio
//
//  Created by juan felippo on 15/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView* tweet_image;
    __weak IBOutlet UILabel* tweet_screen_name;
    __weak IBOutlet UILabel* tweet_name;
    __weak IBOutlet UILabel* tweet_text;
}
-(void) populate: (NSDictionary*)data;
@end
