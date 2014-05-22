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
-(void) populate:(NSDictionary *)data
{
    [self setBackgroundColor:[UIColor clearColor]];
    tweetText.text = [data objectForKey:@"text"];
    tweetName.text = [[data objectForKey:@"user"]objectForKey:@"name"];
    tweetScreenName.text =  [NSString stringWithFormat:@"@%@",[[data objectForKey:@"user"]objectForKey:@"screen_name"]];
    NSURL *imageURL =  [NSURL URLWithString: [[data objectForKey:@"user"]objectForKey:@"profile_image_url"]];
    [tweetImage setImageWithURL:imageURL placeholderImage:nil options:SDWebImageCacheMemoryOnly];
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
