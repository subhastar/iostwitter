//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *timestamp;
@property (nonatomic, strong, readonly) NSURL *profilePicUrl;
@property (nonatomic, strong, readonly) NSNumber *tweetId;
@property (nonatomic, strong, readonly) NSNumber *favoriteCount;
@property (nonatomic, strong, readonly) NSNumber *retweetCount;
@property (nonatomic, readonly) BOOL serverFavorite;
@property (nonatomic, readonly) BOOL serverRetweet;
@property (nonatomic) BOOL favorite;
@property (nonatomic) BOOL retweet;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
