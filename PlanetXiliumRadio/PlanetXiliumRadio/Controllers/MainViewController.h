//
//  MainViewController.h
//  PlanetXiliumRadio
//
//  Created by Ramiro Ponce on 02/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSAudioController;

@interface MainViewController : UIViewController
{
    // UI
    __weak IBOutlet UILabel* title_label;
    __weak IBOutlet UILabel* dial_label;
    __weak IBOutlet UILabel* radio_state;
    __weak IBOutlet UIButton* play_pause_button;
    __weak IBOutlet UIButton* share_button;
    
    
    // State
    BOOL _shouldStartPlaying;
    
    // Class Vars
    FSAudioController *_audioController;
    
}

- (IBAction)playAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end
