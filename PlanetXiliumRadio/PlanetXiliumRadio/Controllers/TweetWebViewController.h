//
//  TweetWebViewController.h
//  PlanetXiliumRadio
//
//  Created by juan felippo on 23/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetWebViewController : UIViewController <UIAlertViewDelegate,UIWebViewDelegate>
{
    __weak IBOutlet UIWebView* tweetWeb;
    __weak IBOutlet UIButton* backButton;
    __weak IBOutlet UIImageView* xiliumImage;
    __weak IBOutlet UILabel* xiliumText;
    __weak IBOutlet UILabel* title_label;
}
@property (nonatomic,strong)NSURL* link;
@end
