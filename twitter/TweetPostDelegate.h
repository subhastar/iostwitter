//
//  TweetPostDelegate.h
//  twitter
//
//  Created by subha on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TweetPostDelegate

-(void) postedTweet:(Tweet *)tweet;

@end
