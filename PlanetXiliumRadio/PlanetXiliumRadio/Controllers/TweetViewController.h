//
//  TweetViewController.h
//  PlanetXiliumRadio
//
//  Created by juan felippo on 15/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView* tweetsTable;
    __weak IBOutlet UIImageView* background_image;
}
@end
