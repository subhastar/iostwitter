//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;
@property NSNumber *maxId;

- (void)onSignOutButton;
- (void)onComposeButton;
- (void)reload;
- (void)reloadWithMaxId:(long long)maxId;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Twitter";
        
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    
    self.tweets = [[NSMutableArray alloc] init];
    
    // sign out button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    // compose
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    
    // set up custom tweet cell
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TweetCell" ];
    
    // pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(reload)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    [cell populateWithTweet:self.tweets[indexPath.row]];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float TEXT_VIEW_WIDTH = 256.0f;
    float CELL_CONTENT_MARGIN_BOTTOM = 8.0f;
    float CELL_CONTENT_MARGIN_TOP = 20.0f;
    float CELL_CONTENT_MARGIN = CELL_CONTENT_MARGIN_BOTTOM + CELL_CONTENT_MARGIN_TOP;
    float FONT_SIZE = 12.0f;
    
    Tweet *tweet = self.tweets[indexPath.row];
    NSString *text = tweet.text;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]};
    
    CGSize boundingSize = CGSizeMake(TEXT_VIEW_WIDTH, 20000.0f);
    
    CGRect boundingRect = [text boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil];
    
    float neededHeight = boundingRect.size.height + CELL_CONTENT_MARGIN * 2 + 10;
    
    float height = MAX(neededHeight, 44.0f);
    
    return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetViewController *tweetVC = [[TweetViewController alloc] init];
    tweetVC.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:tweetVC animated:YES];
}
          
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    NSArray *visibleRows = [self.tableView visibleCells];
    UITableViewCell *lastVisibleCell = [visibleRows lastObject];
    NSIndexPath *path = [self.tableView indexPathForCell:lastVisibleCell];
    if(path.row == self.tweets.count - 1)
    {
        long long loadId = [self.maxId longLongValue] - 1;
        NSLog(@"RELOADING THINGS with load id %lld", loadId);
        [self reloadWithMaxId:([self.maxId longLongValue] - 1)];
    }
}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)onComposeButton {
    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
    // set any metadata here.
    
    [self.navigationController pushViewController:composeVC animated:YES];
}

- (void) reload {
    [self reloadWithMaxId:0];
}

- (void)reloadWithMaxId:(long long)maxId {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:maxId success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        NSArray * newTweets = [Tweet tweetsWithArray:response];
        [self.tweets addObjectsFromArray:newTweets];
        self.maxId = [self.tweets[self.tweets.count - 1] tweetId];
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error. %@", error);
        // Do nothing
    }];
}

@end
