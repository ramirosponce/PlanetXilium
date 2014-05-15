//
//  ViewController.h
//  PlanetXiliumRadio
//
//  Created by Ramiro Ponce on 02/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSAudioController;

@interface ViewController : UIViewController
{
    __weak IBOutlet UILabel* radio_state;
  
    FSAudioController *_audioController;
    
    // State
    BOOL _paused;
    BOOL _shouldStartPlaying;
    
}
@end
