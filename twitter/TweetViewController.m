//
//  TweetViewController.m
//  twitter
//
//  Created by subha on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
- (IBAction)tapFavorite:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (void)updateFavoriteButton:(BOOL)favorite;

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
    // Do any additional setup after loading the view from its nib.
    
    // populate labels and stuff here.
    self.nameLabel.text = self.tweet.name;
    self.usernameLabel.text = self.tweet.username;
    self.timestampLabel.text = self.tweet.timestamp;
    self.tweetTextLabel.text = self.tweet.text;
    self.retweetsLabel.text = [NSString stringWithFormat:@"%@", self.tweet.retweetCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%@", self.tweet.favoriteCount];
    
    [self.profilePicView setImageWithURL:self.tweet.profilePicUrl];
    
    [self updateFavoriteButton:self.tweet.serverFavorite];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapFavorite:(id)sender {
    [self updateFavoriteButton:!self.tweet.favorite];
}

- (void)updateFavoriteButton:(BOOL) favorite {
    self.tweet.favorite = favorite;
    if (self.tweet.favorite) {
        UIImage *image =
        [UIImage imageNamed:@"filled_favorite.png"];
        [self.favoriteButton setBackgroundImage:image forState:UIControlStateNormal];
    } else {
        UIImage *image =
        [UIImage imageNamed:@"favorite.png"];
        [self.favoriteButton setBackgroundImage:image forState:UIControlStateNormal];
    }
}
@end
