//
//  ComposeViewController.h
//  twitter
//
//  Created by subha on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetPostDelegate.h"

@interface ComposeViewController : UIViewController
@property (nonatomic, strong) NSString *replyText;
@property (nonatomic, strong) NSNumber *replyId;
@property id<TweetPostDelegate> delegate;
@end
