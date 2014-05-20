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
}

- (void) setupInterface
{
    title_label.text = NSLocalizedString(@"Twitter Xilium", @"Twitter Xilium");
    [title_label setFont:[UIFont fontWithName:FONT_TYPENOKSIDI size:19.0]];
    
    [tweetsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSString* image_name = @"";
    if (IS_IPHONE_5)
        image_name = @"home_background_640_1136.png";
    else
        image_name = @"home_background_640_960.png";
    [background_image setImage:[UIImage imageNamed:image_name]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.blackberry-techcenter.com/twitterapi/index.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        data=  (NSArray *)responseObject;
        [tweetsTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction) backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)reloadTweetData
{
    [tweetsTable stopRefreshAnimation];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://www.blackberry-techcenter.com/twitterapi/index.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        data=  (NSArray *)responseObject;
        [tweetsTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"entre populate");
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tempHeight=[self getCommentCellHeight2:[data objectAtIndex:indexPath.row]];
    if (indexPath.row==0) {
        NSLog(@"5 COMMENT LINE %.f",tempHeight);
    }
    if (tempHeight<72.0f) {
        return 72.0f;
    }
    else return tempHeight;
}

- (CGFloat)getCommentCellHeight2:(NSDictionary *)userData
{
    CGRect titleFrame = CGRectMake(55.0, 8.0, 245.0, 21.0);
    CGRect commentFrame = CGRectMake(55.0, 27.0, 245.0, 21.0);
    UIFont* titleFont = [UIFont boldSystemFontOfSize:16.0];
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
    UIFont* commentFont = [UIFont systemFontOfSize:14];
    stringAttributes = [NSDictionary dictionaryWithObject:commentFont forKey: NSFontAttributeName];
    
    CGSize commentExpectedLabelSize;
    CGFloat commentNewHeight;
    CGSize commentConstraintSize = CGSizeMake(245.0f, 999.0);
    commentExpectedLabelSize = [[userData objectForKey:@"text"] boundingRectWithSize:commentConstraintSize
                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:stringAttributes context:nil].size;
    commentNewHeight = commentExpectedLabelSize.height;
    commentNewHeight += 18;
    
    CGRect commentFrame_aux = commentFrame;
    commentFrame_aux.origin.y = titleFrame.origin.y + titleFrame.size.height;
    commentFrame_aux.size.height = commentNewHeight;
    commentFrame = commentFrame_aux;
    return commentFrame.origin.y + commentFrame.size.height;
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
