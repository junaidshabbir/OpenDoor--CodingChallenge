//
//  MessagesViewController.h
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/1/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatCell;
@class ChatDetailCell;
@interface MessagesViewController : UIViewController {
    NSMutableArray *chatObjects;
    NSMutableArray *chatDetailObjects;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ChatCell *chatCell;
@property (strong, nonatomic) IBOutlet ChatDetailCell *chatDetailCell;

@property (strong, nonatomic) IBOutlet UIView *mainBodyView;
@property (strong, nonatomic) IBOutlet UIView *chatListView;
@property (strong, nonatomic) IBOutlet UIView *chatDetailView;

@property (weak, nonatomic) IBOutlet UILabel *topic;
@property (weak, nonatomic) IBOutlet UILabel *createdBy;
@property (weak, nonatomic) IBOutlet UILabel *createdOn;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnReply;

- (IBAction)onClickReply:(id)sender;
- (IBAction)onClickBack:(id)sender;




#define CLASS_CHAT                  @"Chat"
#define CLASS_CHAT_DETAIL           @"ChatDetail"

#define KEY_TOPIC                   @"topic"
#define KEY_CREATED_BY              @"createdBy"
#define KEY_POSTED_BY               @"postedBy"
#define KEY_IS_USER_REPLY_ALLOWER   @"isUserReplyAllowed"
#define KEY_CHAT_ID                 @"chatId"
#define KEY_TEXT                    @"text"


@end
