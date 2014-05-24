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
    
    [self setupInterface];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (self.link) {
        NSURLRequest *request= [[NSURLRequest alloc]initWithURL:self.link];
        [tweetWeb loadRequest: request];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Ocurrio un problema. Compruebe su conexion a internet", @"Ocurrio un problema. Compruebe su conexion a internet") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok") otherButtonTitles:nil]show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark private methods

- (void) setupInterface
{
    title_label.text = NSLocalizedString(@"Web", @"Web");
    [title_label setFont:[UIFont fontWithName:FONT_TYPENOKSIDI size:19.0]];
    [loading_label setFont:[UIFont fontWithName:FONT_LOBSTER size:15.0]];
    
    [tweetWeb setHidden:YES];
    [xiliumImage setHidden:NO];
    [loading_label setHidden:NO];
    
    [tweetWeb.scrollView setContentInset:UIEdgeInsetsMake(0,0,45,0)];
}

#pragma mark - Alert Delegates

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action Delegates

- (IBAction) backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WebView Delegates

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [tweetWeb setHidden:NO];
    [xiliumImage setHidden:YES];
    [loading_label setHidden:YES];
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
