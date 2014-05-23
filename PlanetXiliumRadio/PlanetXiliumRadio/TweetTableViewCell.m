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

-(void) populate:(NSDictionary *)data
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    tweet_text.text = [data objectForKey:@"text"];
    tweet_name.text = [[data objectForKey:@"user"]objectForKey:@"name"];
    tweet_screen_name.text =  [NSString stringWithFormat:@"@%@",[[data objectForKey:@"user"]objectForKey:@"screen_name"]];
    NSURL *imageURL =  [NSURL URLWithString: [[data objectForKey:@"user"]objectForKey:@"profile_image_url"]];
    [tweet_image setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"empty_avatar"] options:SDWebImageCacheMemoryOnly];
    [tweet_image setClipsToBounds:YES];
    //[tweet_image.layer setCornerRadius:10.0f];
    [tweet_image.layer setCornerRadius:tweet_image.frame.size.width/2];
    [tweet_image.layer setBorderColor:[UIColorFromRGB(000000) CGColor]];
    
    [tweet_media setClipsToBounds:YES];
    [tweet_media.layer setCornerRadius:5.0f];
    [tweet_media.layer setBorderColor:[UIColorFromRGB(000000) CGColor]];
    
    [background_tweet setClipsToBounds:YES];
    [background_tweet.layer setCornerRadius:3.0f];
    //[background_tweet.layer setBorderColor:[UIColorFromRGB(000000) CGColor]];
    
    NSArray *mediaData=[[data objectForKey:@"entities"]objectForKey:@"media"];
    if (mediaData) {
        NSDictionary *dataDic= [mediaData objectAtIndex:0];
        NSURL *mediaURL =  [NSURL URLWithString: [dataDic objectForKey:@"media_url"]];
        //NSDictionary *mediaSize = [[dataDic objectForKey:@"sizes"] objectForKey:@"small"];
        //CGFloat mediaHeight= [[mediaSize objectForKey:@"h"]floatValue];
        //CGFloat mediaWidht= [[mediaSize objectForKey:@"w"]floatValue];
        [tweet_media setImageWithURL:mediaURL placeholderImage:nil options:SDWebImageCacheMemoryOnly];
        
        //CGRect imageSize = CGRectMake(tweet_media.frame.origin.x , tweet_media.frame.origin.y, mediaWidht, mediaHeight/2);
        //NSLog(@"tengoDATAAAAA %f",mediaHeight);
        //NSLog(@"tengoDATAAAAAmediaWidht %f",mediaWidht);
        //tweet_media.frame = imageSize;
    }else
        tweet_media.image = nil;
    
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
    titleNewWidth += 5;
    
    CGRect  titleFrame = tweet_name.frame;
    titleFrame.size.width = titleNewWidth;
    titleFrame.size.height = titleNewHeight;
    tweet_name.frame = titleFrame;
    
    CGRect  screenNameFrame = tweet_screen_name.frame;
    screenNameFrame.origin.x = tweet_name.frame.origin.x + tweet_name.frame.size.width;
    tweet_screen_name.frame = screenNameFrame;
    
    /* comment and date*/
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
    commentFrame.origin.y = tweet_name.frame.origin.y + tweet_name.frame.size.height - 8;
    commentFrame.size.height = commentNewHeight;
    tweet_text.frame = commentFrame;
    
    CGRect imageFrame = tweet_media.frame;
    imageFrame.origin.y = tweet_text.frame.origin.y + tweet_text.frame.size.height + 10;
    tweet_media.frame = imageFrame;

}

@end
