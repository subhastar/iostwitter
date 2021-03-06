//
//  TwitterClient.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TwitterClient.h"
#import "AFNetworking.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]

// default keys:
// #define TWITTER_CONSUMER_KEY @"biYAqubJD0rK2cRatIQTZw"
// #define TWITTER_CONSUMER_SECRET @"2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg"

// Subha's demo client keys
#define TWITTER_CONSUMER_KEY @"gNXEwEGdoLVHcCVHvN39nQ"
#define TWITTER_CONSUMER_SECRET @"ApEnUIZhSxnyzKoWpgeGuWn9Gh6UaWtJk06y7nHYo"

// Demo client 2 keys
// #define TWITTER_CONSUMER_KEY @"eAC7hCmtEVhM7g5J5MJU2w"
// #define TWITTER_CONSUMER_SECRET @"hpBWJyC2IDZ3koMRz3F5tt2H7um3wJf8F1cFNgjBWc"

static NSString * const kAccessTokenKey = @"kAccessTokenKey";

@implementation TwitterClient

+ (TwitterClient *)instance {
    static dispatch_once_t once;
    static TwitterClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret {
    self = [super initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kAccessTokenKey];
        if (data) {
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
}

#pragma mark - Users API

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure {
    self.accessToken = nil;
    [super authorizeUsingOAuthWithRequestTokenPath:@"oauth/request_token" userAuthorizationPath:@"oauth/authorize" callbackURL:callbackUrl accessTokenPath:@"oauth/access_token" accessMethod:@"POST" scope:nil success:success failure:failure];
}

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getPath:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

#pragma mark - Statuses API

- (void)homeTimelineWithCount:(int)count sinceId:(int)sinceId maxId:(long long)maxId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"count": @(count)}];
    if (sinceId > 0) {
        [params setObject:@(sinceId) forKey:@"since_id"];
    }
    if (maxId > 0) {
        [params setObject:@(maxId) forKey:@"max_id"];
    }
    [self getPath:@"1.1/statuses/home_timeline.json" parameters:params success:success failure:failure];
}

- (void) postTweet:(NSString *)tweet replyId:(NSNumber *)replyId success:(void(^)(id responseObject))successHandler
{
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionary];
    [params setObject:tweet forKey:@"status"];
    if (replyId){
        [params setObject:replyId forKey:@"in_reply_to_status_id"];
    }
    
    [self postPath:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successHandler(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"tweet failure.");
    }];
}

- (void) retweet:(NSNumber *)tweetId success:(void(^)(NSNumber * retweetId))successHandler
{
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionary];
    [params setObject:tweetId forKey:@"id"];
    
    NSString *postPath = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    
    [self postPath:postPath parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successHandler([responseObject objectForKey:@"id"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"retweet failure %@", error);
    }];
}

- (void) deleteTweet:(NSNumber *)tweetId
{
    NSString *postPath = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweetId];
    
    [self postPath:postPath parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSLog(@"delete success.");
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"delete failure %@", error);
           }];
}

- (void) createFavorite:(NSNumber *)tweetId
{
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionary];
    [params setObject:tweetId forKey:@"id"];
    
    [self postPath:@"1.1/favorites/create.json" parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSLog(@"favorite success.");
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"favorite failure %@", error);
           }];
}

- (void) destroyFavorite:(NSNumber *)tweetId
{
    NSMutableDictionary *params = [NSMutableDictionary
                                   dictionary];
    [params setObject:tweetId forKey:@"id"];
    
    [self postPath:@"1.1/favorites/destroy.json" parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSLog(@"unfavorite success.");
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"unfavorite failure %@", error);
           }];
}

#pragma mark - Private methods

- (void)setAccessToken:(AFOAuth1Token *)accessToken {
    [super setAccessToken:accessToken];

    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAccessTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
