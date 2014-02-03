//
//  TweetViewController.m
//  twitter
//
//  Created by subha on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface NSString (Number)
+ (NSString *) increment:(NSString *) string;
+ (NSString *) decrement:(NSString *) string;

@end

@implementation NSString (Number)
+ (NSString *) increment:(NSString *) string {
    int value = [string intValue] + 1;
    return [NSString stringWithFormat:@"%d", value];
}
+ (NSString *) decrement:(NSString *) string {
    int value = [string intValue] - 1;
    return [NSString stringWithFormat:@"%d", value];
}
@end

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
- (void)updateFavoriteButton:(BOOL)favorite andLabel:(BOOL)updateLabel;

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
    
    [self updateFavoriteButton:self.tweet.serverFavorite andLabel:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapFavorite:(id)sender {
    [self updateFavoriteButton:!self.tweet.favorite andLabel:YES];
}

- (void)updateFavoriteButton:(BOOL)favorite andLabel:(BOOL)updateLabel {
    self.tweet.favorite = favorite;
    if (self.tweet.favorite) {
        UIImage *image =
        [UIImage imageNamed:@"filled_favorite.png"];
        [self.favoriteButton setBackgroundImage:image forState:UIControlStateNormal];
        if (updateLabel) {
            self.favoritesLabel.text =
            [NSString increment:self.favoritesLabel.text];
        }
    } else {
        UIImage *image =
        [UIImage imageNamed:@"favorite.png"];
        [self.favoriteButton setBackgroundImage:image forState:UIControlStateNormal];
        if (updateLabel) {
            self.favoritesLabel.text =
            [NSString decrement:self.favoritesLabel.text];
        }
    }
}
@end
