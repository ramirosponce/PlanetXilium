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
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>

@interface TweetViewController ()
{
  NSArray* data;
}
@property (nonatomic,strong) UzysRadialProgressActivityIndicator *radialIndicator;
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
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    __weak typeof(self) weakSelf =self;
    [tweetsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TweetCell"];
    [tweetsTable addPullToRefreshActionHandler:^{
          [self reloadTweetData];
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [tweetsTable.pullToRefreshView setBorderWidth:0.5];
    [tweetsTable.pullToRefreshView setImageIcon:[UIImage imageNamed:@"xilium_head"]];
    [tweetsTable.pullToRefreshView setSize:CGSizeMake(40, 40)];
    [tweetsTable setHidden:YES];
    [loading_image setHidden:NO];
    [loading_label setHidden:NO];
    loading_label.text = @"Cargando";
    [self reloadTweetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods

- (void) setupInterface
{
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
}

- (IBAction) backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)pushComposer
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"@turco082 "];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"No Hay servicio de Twitter disponible" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }

}
-(void)reloadTweetData
{
    [tweetsTable stopRefreshAnimation];
    [[TwitterManager sharedManager]getTweetList:@"planetaxilium" count:20 successBlock:^(NSArray *statuses) {
        data= statuses;
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:statuses options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        NSLog(@"jsonData as string:\n%@", jsonString);
     //   NSLog(@"DATAAA =%@",data);
        [tweetsTable reloadData];
        [loading_image setHidden:YES];
        [loading_label setHidden:YES];
        [tweetsTable setHidden:NO];
    } errorBlock:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Algo salio mal...Prueba de nuevo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    } ];
    
}

#pragma mark -
#pragma mark Table delegates

//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
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
    CGFloat tempHeight = [self getCommentCellHeight2:[data objectAtIndex:indexPath.row]];
    if (tempHeight < 72.0f) {
        return 72.0f;
    }
    else
        return tempHeight;
}

- (CGFloat)getCommentCellHeight2:(NSDictionary *)userData
{
    CGRect titleFrame = CGRectMake(55.0, 8.0, 245.0, 21.0);
    CGRect commentFrame = CGRectMake(55.0, 27.0, 245.0, 21.0);
    
    //CGRect imageFrame = CGRectMake(55.0, 27.0, 245.0, 21.0);
    CGRect imageFrame = CGRectMake(20.0, 77.0, 291.0, 180.0);
    
    UIFont* titleFont = [UIFont boldSystemFontOfSize:14.0];
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:titleFont forKey: NSFontAttributeName];
    
    /* title */
    CGSize titleExpectedLabelSize;
    CGFloat titleNewHeight;
    CGSize titleConstraintSize = CGSizeMake(245.0f, 999.0f);
    
    NSString* cell_title = [NSString stringWithFormat:@"%@ %@:",[[userData objectForKey:@"user"]objectForKey:@"name"], NSLocalizedString(@"dijo", @"dijo")];
    
    titleExpectedLabelSize = [cell_title boundingRectWithSize:titleConstraintSize
                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:stringAttributes context:nil].size;
    titleNewHeight = titleExpectedLabelSize.height;
    //titleNewHeight += 5;
    
    CGRect  titleFrame_aux = titleFrame;
    titleFrame_aux.size.height = titleNewHeight;
    titleFrame = titleFrame_aux;
    
    /* comment and date*/
    UIFont* commentFont = [UIFont systemFontOfSize:15];
    stringAttributes = [NSDictionary dictionaryWithObject:commentFont forKey: NSFontAttributeName];
    
    CGSize commentExpectedLabelSize;
    CGFloat commentNewHeight;
    CGSize commentConstraintSize = CGSizeMake(245.0f, 999.0);
    commentExpectedLabelSize = [[userData objectForKey:@"text"] boundingRectWithSize:commentConstraintSize
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:stringAttributes context:nil].size;
    commentNewHeight = commentExpectedLabelSize.height;
    commentNewHeight += 10;
    
    CGRect commentFrame_aux = commentFrame;
    commentFrame_aux.origin.y = titleFrame.origin.y + titleFrame.size.height;
    commentFrame_aux.size.height = commentNewHeight;
    commentFrame = commentFrame_aux;
    
    NSArray *mediaData=[[userData objectForKey:@"entities"]objectForKey:@"media"];
    if (mediaData.count > 0) {
        CGRect imageFrame_aux = imageFrame;
        imageFrame_aux.origin.y = commentFrame.origin.y + commentFrame.size.height + 10;
        imageFrame = imageFrame_aux;
        return imageFrame.origin.y + imageFrame.size.height + 10;
    }else
        return commentFrame.origin.y + commentFrame.size.height;
    
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
