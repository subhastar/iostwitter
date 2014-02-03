//
//  ComposeViewController.m
//  twitter
//
//  Created by subha on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeViewController.h"
#import "TweetPostDelegate.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
- (IBAction)tweet:(id)sender;

@end

@implementation ComposeViewController

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
    // Do any additional setup after loading the view from its nib.
    
    if (self.replyText != nil) {
        self.tweetTextView.text = self.replyText;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tweet:(id)sender {
    __weak id<TweetPostDelegate> weakDelegate = self.delegate;
    [[TwitterClient instance] postTweet:self.tweetTextView.text success:^ (id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        [weakDelegate postedTweet:tweet];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
