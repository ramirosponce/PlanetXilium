//
//  TweetCollectionViewCell.m
//  PlanetXiliumRadio
//
//  Created by juan felippo on 13/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import "TweetCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation TweetCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) populate:(Tweet *)tweet
{
    [self setBackgroundColor:[UIColor clearColor]];
    tweetText.text = tweet.text;
    tweetName.text = tweet.name;
    tweetScreenName.text =  tweet.screen_name;
    [tweetImage setImageWithURL:tweet.profile_image_url placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    [tweetImage setClipsToBounds:YES];
    [tweetImage.layer setCornerRadius:tweetImage.frame.size.width/2];
    [tweetImage.layer setBorderColor:[UIColorFromRGB(0xDD7248) CGColor]];
    [tweetImage.layer setBorderWidth: 2.0f];
    
    [self makeDynamic];
}


- (void) makeDynamic
{
    UIFont* titleFont = tweetName.font;
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:titleFont forKey: NSFontAttributeName];
    
    /* title */
    CGSize titleExpectedLabelSize;
    CGFloat titleNewWidth;
    CGSize titleConstraintSize = CGSizeMake(999.0f, 21.0f);
    titleExpectedLabelSize = [tweetName.text boundingRectWithSize:titleConstraintSize
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:stringAttributes context:nil].size;
    titleNewWidth = titleExpectedLabelSize.width;
    titleNewWidth += 5;
    
    CGRect  titleFrame = tweetName.frame;
    titleFrame.size.width = titleNewWidth;
    tweetName.frame = titleFrame;
    
    CGRect  screenNameFrame = tweetScreenName.frame;
    screenNameFrame.origin.x = tweetName.frame.origin.x + tweetName.frame.size.width;
    tweetScreenName.frame = screenNameFrame;
}

@end
