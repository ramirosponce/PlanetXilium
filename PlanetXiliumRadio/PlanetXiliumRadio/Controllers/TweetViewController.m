//
//  TweetViewController.m
//  PlanetXiliumRadio
//
//  Created by juan felippo on 15/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "TweetViewController.h"
#import "AFNetworking.h"
#import "TweetTableViewCell.h"
#import "TwitterManager.h"
#import "TweetWebViewController.h"
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>

@interface TweetViewController ()
{
  NSMutableArray* data;
}
@property (nonatomic,strong) UzysRadialProgressActivityIndicator *radialIndicator;
@property (assign, nonatomic) CATransform3D initialTransformation;
@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInterface];
    //Set the Intial angle
    CGFloat rotationAngleDegrees = 60;
    // Caculate the radian from the intial
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    //Set the Intial (x,y) position to start the animation from
    CGPoint offsetPositioning = CGPointMake(20, 20);
    //Define the Identity Matrix
    CATransform3D transform = CATransform3DIdentity;
    //Rotate the cell in the anti-clockwise directon to see the animation along the x- axis
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 1.0, 0.0);
    //Add the translation effect to give shifting cell animation
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformation = transform;
    // Do any additional setup after loading the view.
    
    loading_label.text = NSLocalizedString(@"Cargando", @"Cargando");
    [self reloadTweetData];
}

-(void)viewWillAppear:(BOOL)animated
{
    __weak typeof(self) weakSelf =self;
    [tweetsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TweetCell"];
    [tweetsTable addPullToRefreshActionHandler:^{
          [self reloadTweetData];
    }];
 
    [tweetsTable.pullToRefreshView setBorderWidth:0.5];
    [tweetsTable.pullToRefreshView setImageIcon:[UIImage imageNamed:@"xilium_head"]];
    [tweetsTable.pullToRefreshView setSize:CGSizeMake(40, 40)];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Private Methods

- (void) setupInterface
{
    data = [[NSMutableArray alloc] initWithCapacity:0];
    [compose_button addTarget:self action:@selector(pushComposer) forControlEvents:UIControlEventTouchUpInside];
    title_label.text = NSLocalizedString(@"Twitter Xilium", @"Twitter Xilium");
    [title_label setFont:[UIFont fontWithName:FONT_TYPENOKSIDI size:19.0]];
    [loading_label setFont:[UIFont fontWithName:FONT_LOBSTER size:15.0]];
    
    [tweetsTable setBackgroundColor:[UIColor clearColor]];
    [tweetsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSString* image_name = @"";
    if (IS_IPHONE_5)
        image_name = @"twitter_background_640_1136.png";
    else
        image_name = @"twitter_background_640_960.png";
    [background_image setImage:[UIImage imageNamed:image_name]];
    
    [tweetsTable setHidden:YES];
    [loading_image setHidden:NO];
    [loading_label setHidden:NO];
}

- (IBAction) backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)pushComposer
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString* username = [NSString stringWithFormat:@"@%@ ",TWEER_USER];
        [tweetSheet setInitialText:username];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"No Hay servicio de Twitter disponible", @"No Hay servicio de Twitter disponible") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok") otherButtonTitles:nil] show];
    }

}

-(void)reloadTweetData
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [tweetsTable stopRefreshAnimation];
    [[TwitterManager sharedManager]getTweetList:TWEER_USER count:30 successBlock:^(NSArray *statuses) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        data= nil;
        data = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *itemData in statuses) {
            Tweet *dataTweet = [[Tweet alloc]initWithData:itemData];
            [data addObject:dataTweet];
        }
        [tweetsTable reloadData];
        [loading_image setHidden:YES];
        [loading_label setHidden:YES];
        [tweetsTable setHidden:NO];
    } errorBlock:^(NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Ocurrio un problema. Compruebe su conexion a internet", @"Ocurrio un problema. Compruebe su conexion a internet") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok") otherButtonTitles:nil]show];
    } ];
    
}

#pragma mark -
#pragma mark Table delegates

//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    UIView *card = (UITableViewCell * )cell ;
    card.layer.transform = self.initialTransformation;
    //Set the cell to light Transparent
    card.layer.opacity = 0.8;
    
    [UIView animateWithDuration:0.5 animations:^{
        card.layer.transform = CATransform3DIdentity;
        //Make it to original color
        card.layer.opacity = 1;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cell_Identifier = @"TweetCells";
    
    TweetTableViewCell* cell = (TweetTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cell_Identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = (TweetTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_Identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell populate:[data objectAtIndex:indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tempHeight = [self getCommentCellHeight:(Tweet*)[data objectAtIndex:indexPath.row]];
    if (tempHeight < 72.0f) {
        return 72.0f;
    }
    else
        return tempHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    Tweet *selectedTweet=[data objectAtIndex:indexPath.row];
    if(selectedTweet.link_url)
    {
        [self performSegueWithIdentifier:@"tweetWebSegue" sender:selectedTweet.link_url];
    }
   
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"tweetWebSegue"]){
        TweetWebViewController *vc= (TweetWebViewController*)[segue destinationViewController];
        vc.link = (NSURL*)sender;
    }
}
- (CGFloat)getCommentCellHeight:(Tweet *)userData
{
    //CGRect titleFrame = CGRectMake(55.0, 8.0, 245.0, 21.0);
    //CGRect commentFrame = CGRectMake(55.0, 27.0, 245.0, 21.0);
    CGRect titleFrame = CGRectMake(67.0, 9.0, 62.0, 21.0);
    CGRect commentFrame = CGRectMake(66.0, 25.0, 246.0, 47.0);
    
    //CGRect imageFrame = CGRectMake(55.0, 27.0, 245.0, 21.0);
    CGRect imageFrame = CGRectMake(20.0, 82.0, 280.0, 180.0);
    
    UIFont* titleFont = [UIFont boldSystemFontOfSize:15.0];
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:titleFont forKey: NSFontAttributeName];
    
    /* title */
    CGSize titleExpectedLabelSize;
    CGFloat titleNewHeight;
    CGSize titleConstraintSize = CGSizeMake(999.0f, 21.0f);
    
    NSString* cell_title = userData.name;
    
    titleExpectedLabelSize = [cell_title boundingRectWithSize:titleConstraintSize
                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:stringAttributes context:nil].size;
    titleNewHeight = titleExpectedLabelSize.height;

    
    CGRect  titleFrame_aux = titleFrame;
    titleFrame_aux.size.height = titleNewHeight;
    titleFrame = titleFrame_aux;
    
    /* comment*/
    UIFont* commentFont = [UIFont systemFontOfSize:15];
    stringAttributes = [NSDictionary dictionaryWithObject:commentFont forKey: NSFontAttributeName];
    
    CGSize commentExpectedLabelSize;
    CGFloat commentNewHeight;
    CGSize commentConstraintSize = CGSizeMake(245.0f, 999.0);
    commentExpectedLabelSize = [userData.text boundingRectWithSize:commentConstraintSize
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:stringAttributes context:nil].size;
    commentNewHeight = commentExpectedLabelSize.height;
    commentNewHeight += 10;
    
    CGRect commentFrame_aux = commentFrame;
    commentFrame_aux.origin.y = titleFrame.origin.y + titleFrame.size.height;
    commentFrame_aux.size.height = commentNewHeight;
    commentFrame = commentFrame_aux;
    
    if (userData.media_image_url) {
        CGRect imageFrame_aux = imageFrame;
        imageFrame_aux.origin.y = commentFrame.origin.y + commentFrame.size.height + 10;
        imageFrame = imageFrame_aux;
        return imageFrame.origin.y + imageFrame.size.height + 20;
    }else
        return commentFrame.origin.y + commentFrame.size.height + 10;
    
}
#pragma mark-back button action
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
