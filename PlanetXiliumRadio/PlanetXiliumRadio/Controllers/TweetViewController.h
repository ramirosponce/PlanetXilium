//
//  TweetViewController.h
//  PlanetXiliumRadio
//
//  Created by juan felippo on 15/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet UITableView* tweetsTable;
    __weak IBOutlet UIImageView* background_image;
    __weak IBOutlet UIButton* back_button;
    __weak IBOutlet UILabel* title_label;
    __weak IBOutlet UILabel* loading_label;
    __weak IBOutlet UIImageView* loading_image;
    __weak IBOutlet UIButton* compose_button;
}

- (IBAction) backAction:(id)sender;

@end
