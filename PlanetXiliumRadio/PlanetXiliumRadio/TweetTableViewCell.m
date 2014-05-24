//
//  TweetTableViewCell.m
//  PlanetXiliumRadio
//
//  Created by juan felippo on 15/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation TweetTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) populate:(Tweet *)tweet
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    tweet_text.text = tweet.text;
    tweet_name.text = tweet.name;
    tweet_screen_name.text = tweet.screen_name;
    [tweet_image setImageWithURL:tweet.profile_image_url placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    [tweet_image setClipsToBounds:YES];
    //[tweet_image.layer setCornerRadius:10.0f];
    [tweet_image.layer setCornerRadius:tweet_image.frame.size.width/2];
    [tweet_image.layer setBorderColor:[UIColorFromRGB(000000) CGColor]];
    
    [tweet_media setClipsToBounds:YES];
    [tweet_media.layer setCornerRadius:5.0f];
    [tweet_media.layer setBorderColor:[UIColorFromRGB(000000) CGColor]];
    
    [background_tweet setClipsToBounds:YES];
    [background_tweet.layer setCornerRadius:3.0f];
    [background_tweet.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [background_tweet.layer setBorderWidth:.7];
    
    if (tweet.media_image_url) {
        [tweet_media setImageWithURL:tweet.media_image_url placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    }else
        tweet_media.image = nil;
    
    if (tweet.created_at) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];;
        
        // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
        [dateFormatter setDateFormat: @"dd MMM"];
        tweet_date.text = [dateFormatter stringFromDate:tweet.created_at];
    }else{
        tweet_date.text = @"";
    }
    
    
    
    [self makeDynamic];
}

- (void) makeDynamic
{
    UIFont* titleFont = tweet_name.font;
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:titleFont forKey: NSFontAttributeName];
    
    /* title */
    CGSize titleExpectedLabelSize;
    CGFloat titleNewWidth;
    CGFloat titleNewHeight;
    CGSize titleConstraintSize = CGSizeMake(999.0f, 21.0f);
    titleExpectedLabelSize = [tweet_name.text boundingRectWithSize:titleConstraintSize
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:stringAttributes context:nil].size;
    titleNewWidth = titleExpectedLabelSize.width;
    titleNewHeight = titleExpectedLabelSize.height;
    titleNewWidth += 2;
    
    CGRect  titleFrame = tweet_name.frame;
    titleFrame.size.width = titleNewWidth;
    titleFrame.size.height = titleNewHeight;
    tweet_name.frame = titleFrame;
    
    CGRect  screenNameFrame = tweet_screen_name.frame;
    screenNameFrame.origin.x = tweet_name.frame.origin.x + tweet_name.frame.size.width;
    tweet_screen_name.frame = screenNameFrame;
    
    /* comment*/
    UIFont* commentFont = tweet_text.font;
    stringAttributes = [NSDictionary dictionaryWithObject:commentFont forKey: NSFontAttributeName];
    
    CGSize commentExpectedLabelSize;
    CGFloat commentNewHeight;
    CGSize commentConstraintSize = CGSizeMake(245.0f, 999.0);
    commentExpectedLabelSize = [tweet_text.text boundingRectWithSize:commentConstraintSize
                                                               options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:stringAttributes context:nil].size;
    commentNewHeight = commentExpectedLabelSize.height;
    commentNewHeight += 10;
    
    CGRect commentFrame = tweet_text.frame;
    commentFrame.origin.y = tweet_name.frame.origin.y + tweet_name.frame.size.height ;
    commentFrame.size.height = commentNewHeight;
    tweet_text.frame = commentFrame;
    
    CGRect imageFrame = tweet_media.frame;
    imageFrame.origin.y = tweet_text.frame.origin.y + tweet_text.frame.size.height + 10;
    tweet_media.frame = imageFrame;

}

@end
