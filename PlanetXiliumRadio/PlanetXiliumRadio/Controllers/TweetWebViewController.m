//
//  TweetWebViewController.m
//  PlanetXiliumRadio
//
//  Created by juan felippo on 23/05/14.
//  Copyright (c) 2014 Ramiro Ponce. All rights reserved.
//

#import "TweetWebViewController.h"

@interface TweetWebViewController ()

@end

@implementation TweetWebViewController

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
    title_label.text = @"Web";
    [title_label setFont:[UIFont fontWithName:FONT_TYPENOKSIDI size:19.0]];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"URRLLL %@",[self.link absoluteString]);
    if (self.link) {
        NSURLRequest *request= [[NSURLRequest alloc]initWithURL:self.link];
        [tweetWeb loadRequest: request];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Ocurrio un problema...Prueba otra vez" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil]show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Alert Delegates
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Action Delegates
- (IBAction) backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - WebView Delegates

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [tweetWeb setHidden:YES];
    [xiliumImage setHidden:NO];
    [xiliumText setHidden:NO];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [tweetWeb setHidden:NO];
    [xiliumImage setHidden:YES];
    [xiliumText setHidden:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
