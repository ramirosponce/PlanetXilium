//
//  MainViewController.h
//  PlanetXiliumRadio
//
//  Created by Ramiro Ponce on 02/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSAudioController;

@interface MainViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    // UI
    __weak IBOutlet UIImageView* background_image;
    __weak IBOutlet UILabel* title_label;
    __weak IBOutlet UILabel* dial_label;
    __weak IBOutlet UILabel* radio_state;
    __weak IBOutlet UIButton* play_pause_button;
    __weak IBOutlet UIButton* share_button;
    __weak IBOutlet UICollectionView* tweetView;
    __weak IBOutlet UICollectionViewCell* tweetCell;
    __weak IBOutlet UIPageControl* tweetPage;
    __weak IBOutlet UISlider* radio_slider;
    // State
    BOOL _shouldStartPlaying;
    
    // Class Vars
    FSAudioController *_audioController;
    
}

- (IBAction)playAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)volumeValueChangeAction:(id)sender;

@end
