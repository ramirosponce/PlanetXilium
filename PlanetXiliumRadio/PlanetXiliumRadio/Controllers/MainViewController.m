//
//  MainViewController.m
//  PlanetXiliumRadio
//
//  Created by Ramiro Ponce on 02/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "FSAudioStream.h"
#import "FSAudioController.h"
#import "TweetCollectionViewCell.h"
#import "TwitterManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Tweet.h"

@interface MainViewController ()
{
    NSMutableArray* data;
    int selected_index;
    NSTimer* tweetTimer;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInterface];
    [self loadXiliumTweets];
}

- (void) viewWillAppear:(BOOL)animated{
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [self setupRemoteControl];
    [self setupNotifications];
    
    //[self performSelector:@selector(radioStart) withObject:nil afterDelay:3.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[_audioController stop];
    //[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //[self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark private methods

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if (_audioController != nil) {
        [_audioController stop];
        [self radioStateMoveDown];
        _audioController = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [play_pause_button setImage:[UIImage imageNamed:@"radio_play_button"] forState:UIControlStateNormal];
        [play_pause_button setUserInteractionEnabled:YES];
    }
}
- (void) setupInterface
{
    
    data = [[NSMutableArray alloc] initWithCapacity:0];
    title_label.text = NSLocalizedString(@"Planeta Xilium", @"Planeta Xilium");
    dial_label.text = @"90.9";
    radio_state.text = @"";
    
    [cancelLoadingButton.layer setCornerRadius:cancelLoadingButton.frame.size.width/2];
    [cancelLoadingButton.layer setBorderColor:[loadingLabel.textColor CGColor]];
    [cancelLoadingButton.layer setBorderWidth: 2.0f];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [cancelLoadingButton addGestureRecognizer:singleFingerTap];
    
    [title_label setFont:[UIFont fontWithName:FONT_TYPENOKSIDI size:19.0]];
    [dial_label setFont:[UIFont fontWithName:FONT_TYPENOKSIDI size:25.0]];
    [radio_state setFont:[UIFont fontWithName:FONT_DOSIS_LIGHT size:19.0]];
    [loadingLabel setFont:[UIFont fontWithName:FONT_LOBSTER size:15.0]];
    
    NSString* image_name = @"";
    if (IS_IPHONE_5)
        image_name = @"main_menu_background-568h@2x.png";
    else
        image_name = @"main_menu_background.png";
    [background_image setImage:[UIImage imageNamed:image_name]];
    
    //_paused = NO;
    [tweetView setBackgroundColor:[UIColor clearColor]];
    
    // set min and max value for volume slider
    [radio_slider setMinimumValue:0.0];
    [radio_slider setMaximumValue:1.0];
    
    CGRect loadingViewFrame = loadingView.frame;
    loadingViewFrame.origin.y = playerContainerView.frame.origin.y + 10;
    loadingView.frame = loadingViewFrame;

}
-(void) loadXiliumTweets
{
     selected_index=0;
    [[TwitterManager sharedManager]getTweetList:TWEER_USER count:10 successBlock:^(NSArray *statuses) {
        data= nil;
        data = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *itemData in statuses) {
            Tweet *dataTweet = [[Tweet alloc]initWithData:itemData];
            [data addObject:dataTweet];
        }
        [tweetView reloadData];
        [tweetPage setNumberOfPages:data.count];
        tweetTimer =[NSTimer scheduledTimerWithTimeInterval:10.0
                                                     target:self
                                                   selector:@selector(playCarrousel)
                                                   userInfo:nil
                                                    repeats:YES];
        [self performSelector:@selector(updateData) withObject: nil afterDelay:300.0];
        
    } errorBlock:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Ocurrio un problema. Compruebe su conexion a internet", @"Ocurrio un problema. Compruebe su conexion a internet") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok") otherButtonTitles:nil]show];
    }];
}

-(void) updateData
{
    [tweetTimer invalidate];
    tweetTimer = nil;
    selected_index=0;
    
    [[TwitterManager sharedManager]getTweetList:TWEER_USER count:10 successBlock:^(NSArray *statuses) {
        data= nil;
        data = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *itemData in statuses) {
            Tweet *dataTweet = [[Tweet alloc]initWithData:itemData];
            [data addObject:dataTweet];
        }
        [tweetView reloadData];
        [tweetPage setNumberOfPages:data.count];
        
        NSIndexPath *item_idx;
        selected_index=0;
        item_idx = [NSIndexPath indexPathForItem:selected_index++ inSection:0];
        [tweetView scrollToItemAtIndexPath:item_idx atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        tweetTimer =[NSTimer scheduledTimerWithTimeInterval:10.0
                                                     target:self
                                                   selector:@selector(playCarrousel)
                                                   userInfo:nil
                                                    repeats:YES];
        [self performSelector:@selector(updateData) withObject: nil afterDelay:300.0];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    } ];
}
-(void) playCarrousel
{
         NSIndexPath *item_idx;
        if(selected_index<(data.count-1)){
            selected_index++;
            item_idx = [NSIndexPath indexPathForItem:selected_index inSection:0];
            [tweetView scrollToItemAtIndexPath:item_idx atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        else {
            selected_index=0;
            item_idx = [NSIndexPath indexPathForItem:selected_index inSection:0];
            [tweetView scrollToItemAtIndexPath:item_idx atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
}
- (void) setupRemoteControl
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void) setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioStreamStateDidChange:) name:FSAudioStreamStateChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioStreamErrorOccurred:) name:FSAudioStreamErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioStreamMetaDataAvailable:) name:FSAudioStreamMetaDataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

#pragma mark -
#pragma mark Actions methods

- (IBAction)playAction:(id)sender
{
    if (_audioController != nil && _audioController.isPlaying) {
        [_audioController stop];
        [play_pause_button setImage:[UIImage imageNamed:@"radio_play_button"] forState:UIControlStateNormal];
    }else{
        if (_audioController == nil) {
            _audioController = [[FSAudioController alloc] init];
            _audioController.url = [NSURL URLWithString:RADIO_URL];
            
        }
        [_audioController play];
        [play_pause_button setImage:[UIImage imageNamed:@"radio_pause_button.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)shareAction:(id)sender
{
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:nil
                                                         cancelButtonTitle:NSLocalizedString(@"Cancelar", @"Cancelar")
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:NSLocalizedString(@"Compartir en Facebook", @"Compartir en Facebook"), NSLocalizedString(@"Compartir en Twitter", @"Compartir en Twitter") , nil];
    [shareActionSheet showInView:self.view];
}

#pragma mark -
#pragma mark Animations methods

- (void) radioStateMoveUp
{
    CGRect loadingViewFrame = loadingView.frame;
    loadingViewFrame.origin.y = playerContainerView.frame.origin.y - (loadingViewFrame.size.height - 10);
    [UIView animateWithDuration:0.2 animations:^{
        loadingView.frame = loadingViewFrame;
    }];
}

- (void) radioStateMoveDown
{
    CGRect loadingViewFrame = loadingView.frame;
    loadingViewFrame.origin.y = playerContainerView.frame.origin.y + 10;
    [UIView animateWithDuration:0.4 animations:^{
        loadingView.frame = loadingViewFrame;
    }];
}

#pragma mark -
#pragma mark Observers methods

- (void)audioStreamStateDidChange:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    int state = [[dict valueForKey:FSAudioStreamNotificationKey_State] intValue];
    
    switch (state) {
        case kFsAudioStreamRetrievingURL:
            [self radioStateMoveUp];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            loadingLabel.text = NSLocalizedString(@"Obteniendo URL...", @"Obteniendo URL...");
            [play_pause_button setUserInteractionEnabled:NO];
            //_paused = NO;
            break;
        case kFsAudioStreamStopped:
            [self radioStateMoveDown];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            loadingLabel.text = NSLocalizedString(@"Detenido", @"Detenido");
            //_paused = NO;
            break;
        case kFsAudioStreamBuffering:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            loadingLabel.text = NSLocalizedString(@"Buffering...", @"Buffering...");
            //_paused = NO;
            break;
        case kFsAudioStreamSeeking:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            loadingLabel.text = NSLocalizedString(@"Buscando...", @"Buscando...");
            //_paused = NO;
            break;
        case kFsAudioStreamPlaying:
            [self radioStateMoveDown];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            loadingLabel.text = @""; //@"Playing...";
            //_paused = NO;
            [radio_slider setValue:0.5 animated:YES];
            [play_pause_button setUserInteractionEnabled:YES];
            [_audioController setVolume:0.5];
            
            break;
        case kFsAudioStreamFailed:
            [self performSelector:@selector(radioStateMoveDown) withObject:nil afterDelay:0.5];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            loadingLabel.text = NSLocalizedString(@"Error!", @"Error!");
            [play_pause_button setUserInteractionEnabled:YES];
            //_paused = NO;
            break;
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlPlay:  
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (_audioController != nil && _audioController.isPlaying) {
                    //[self play:self];
              //      [_audioController pause];
                    [play_pause_button setImage:[UIImage imageNamed:@"radio_play_button"] forState:UIControlStateNormal];
                    [_audioController stop];
                    _audioController = nil;
                } else {
                    //[self pause:self];
                    [_audioController play];
                    [play_pause_button setImage:[UIImage imageNamed:@"radio_pause_button"] forState:UIControlStateNormal];
                }
                break;
            default:
                break;
        }
    }
}

/*- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (_paused) {
                    //[self play:self];
                } else {
                    //[self pause:self];
                }
                break;
            default:
                break;
        }
    }
}*/

- (void)audioStreamErrorOccurred:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    int errorCode = [[dict valueForKey:FSAudioStreamNotificationKey_Error] intValue];
    
    NSString *errorDescription;
    
    switch (errorCode) {
        case kFsAudioStreamErrorOpen:
            errorDescription = @"Cannot open the audio stream";
            break;
        case kFsAudioStreamErrorStreamParse:
            errorDescription = @"Cannot read the audio stream";
            break;
        case kFsAudioStreamErrorNetwork:
            errorDescription = @"Network failed: cannot play the audio stream";
            break;
        case kFsAudioStreamErrorUnsupportedFormat:
            errorDescription = @"Unsupported format";
            break;
        case kFsAudioStreamErrorStreamBouncing:
            errorDescription = @"Network failed: cannot get enough data to play";
            break;
        default:
            errorDescription = @"Unknown error occurred";
            break;
    }
    
    //[self showErrorStatus:errorDescription];
}

- (void)audioStreamMetaDataAvailable:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSDictionary *metaData = [dict valueForKey:FSAudioStreamNotificationKey_MetaData];
    
    NSMutableString *streamInfo = [[NSMutableString alloc] init];
    
    /*[self determineStationNameWithMetaData:metaData];
     
     if (metaData[@"MPMediaItemPropertyArtist"] &&
     metaData[@"MPMediaItemPropertyTitle"]) {
     [streamInfo appendString:metaData[@"MPMediaItemPropertyArtist"]];
     [streamInfo appendString:@" - "];
     [streamInfo appendString:metaData[@"MPMediaItemPropertyTitle"]];
     } else if (metaData[@"StreamTitle"]) {
     [streamInfo appendString:metaData[@"StreamTitle"]];
     }
     
     if (metaData[@"StreamUrl"] && [metaData[@"StreamUrl"] length] > 0) {
     _stationURL = [NSURL URLWithString:metaData[@"StreamUrl"]];
     
     self.navigationItem.rightBarButtonItem = _infoButton;
     }
     
     [_statusLabel setHidden:NO];
     self.statusLabel.text = streamInfo;*/
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    // do something when the application enter in background
    [tweetTimer invalidate];
    tweetTimer = nil;
    NSLog(@"entree back");
    
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification
{
    // do something when the application appear from foreground
    NSLog(@"entre fo");
    if(tweetTimer!=nil)
    {[tweetTimer invalidate];
        tweetTimer = nil;
    }
    tweetTimer =[NSTimer scheduledTimerWithTimeInterval:10.0
                                                 target:self
                                               selector:@selector(playCarrousel)
                                               userInfo:nil
                                                repeats:YES];
}
#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark -
#pragma mark UICollectionViewDelegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [data count];

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    [self performSegueWithIdentifier:@"tweetSegue" sender:nil];

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"TweetCell";

    TweetCollectionViewCell* cell = (TweetCollectionViewCell*)[collectionView
                                                    dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                    forIndexPath:indexPath];
    if (cell == nil) {
        cell = (TweetCollectionViewCell*)[[UICollectionViewCell alloc] init];
    }
    [cell populate:(Tweet*)[data objectAtIndex:indexPath.row]];
    return cell;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [tweetTimer invalidate];
    tweetTimer = nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (data.count>0) {
        CGFloat pageWidth = tweetView.frame.size.width;
        selected_index=(tweetView.contentOffset.x + pageWidth / 2) / pageWidth;
        tweetPage.currentPage =selected_index;
        if(!tweetTimer){
            tweetTimer =[NSTimer scheduledTimerWithTimeInterval:10.0
                                                         target:self
                                                       selector:@selector(playCarrousel)
                                                       userInfo:nil
                                                        repeats:YES];
        }
    }
}
- (IBAction)volumeValueChangeAction:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    if (_audioController != nil && _audioController.isPlaying) {
        [_audioController setVolume:slider.value];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
