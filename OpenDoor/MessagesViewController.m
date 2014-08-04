//
//  MessagesViewController.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/1/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "MessagesViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"
#import "ChatDetailCell.h"
#import "User.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController

UIView *footerLoadingView;
User *user;
NSDateFormatter *dateFormat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        chatObjects = [[NSMutableArray alloc] init];
        chatDetailObjects = [[NSMutableArray alloc] init];
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEEE, d MMMM yyyy h:mm a"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadChatDetailView];
    [self loadChatListView];
    [self initFooterView];

    [self.detailTableView reloadData];
    
    [self queryChatObjects];
}

- (void) loadChatListView {
    self.chatListView.hidden = false;
    [self.mainBodyView addSubview:self.chatListView];
    self.chatDetailView.hidden = true;
}

- (void) loadChatDetailView {
    self.chatDetailView.hidden = false;
    [self.mainBodyView addSubview:self.chatDetailView];
    self.chatListView.hidden = true;
    [chatDetailObjects removeAllObjects];
    [self.detailTableView reloadData];
}

- (void) queryChatObjects {
    [self startLoading: self.tableView];
    PFQuery *query = [PFQuery queryWithClassName:CLASS_CHAT];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self stopLoading: self.tableView];
        if (!error) {
            chatObjects = [[NSMutableArray alloc]initWithArray:objects];
            [self.tableView reloadData];
        }
    }];
}

- (void) queryChatDetailObjects:(NSString*) chatId {
    [self startLoading: self.detailTableView];
    PFQuery *query = [PFQuery queryWithClassName:CLASS_CHAT_DETAIL];
    [query whereKey:KEY_CHAT_ID equalTo:chatId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self stopLoading: self.detailTableView];
        if (!error) {
            chatDetailObjects = [[NSMutableArray alloc]initWithArray:objects];
            [self.detailTableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.chatListView.hidden == false) {
        return [chatObjects count];
    } else {
        return [chatDetailObjects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.chatListView.hidden == false) {
        return [self tableViewForChatList:tableView cellForRowAtIndexPath:indexPath];
    }
    else {
        return [self tableViewForChatDetail:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableViewForChatList:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *chat = [chatObjects objectAtIndex:indexPath.section];
    
    [[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil];
    ChatCell *chatCell = self.chatCell;
    self.chatCell = nil;
    
    chatCell.topic.text = [chat objectForKey:KEY_TOPIC];
    chatCell.createdOn.text = [dateFormat stringFromDate:chat.createdAt];
    return chatCell;
}

- (UITableViewCell *)tableViewForChatDetail:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *chatDetail = [chatDetailObjects objectAtIndex:indexPath.section];
    
    [[NSBundle mainBundle] loadNibNamed:@"ChatDetailCell" owner:self options:nil];
    ChatDetailCell *chatDetailCell = self.chatDetailCell;
    self.chatDetailCell = nil;
    
    chatDetailCell.lblText.text = [chatDetail objectForKey:KEY_TEXT];
    chatDetailCell.lblPostedBy.text = [chatDetail objectForKey:KEY_POSTED_BY];
    chatDetailCell.lblDate.text = [dateFormat stringFromDate:chatDetail.createdAt];
    return chatDetailCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.chatListView.hidden == false) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PFObject *chat = [chatObjects objectAtIndex:indexPath.section];
        [self showChatDetails:chat];
    }
}

- (void) showChatDetails: (PFObject *)chat{

    self.topic.text = [chat objectForKey:KEY_TOPIC];
    self.createdBy.text = [chat objectForKey:KEY_CREATED_BY];
    self.createdOn.text = [dateFormat stringFromDate:chat.createdAt];
    if([[chat objectForKey:KEY_IS_USER_REPLY_ALLOWER] isEqual: @NO]) {
        self.btnReply.hidden = YES;
    } else {
        self.btnReply.hidden = NO;
    }

    [self loadChatDetailView];
    [self queryChatDetailObjects:chat.objectId];
}

- (void) startLoading: (UITableView *)tableView {
    tableView.tableFooterView = footerLoadingView;
    [(UIActivityIndicatorView *)[footerLoadingView viewWithTag:10] startAnimating];
}

- (void) stopLoading: (UITableView *)tableView {
    tableView.tableFooterView = nil;
    [(UIActivityIndicatorView *)[footerLoadingView viewWithTag:10] stopAnimating];
}

- (void)initFooterView {
    footerLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actInd.tag = 10;
    actInd.frame = CGRectMake(150.0, 5.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [footerLoadingView addSubview:actInd];
    actInd = nil;
}

- (IBAction)onClickReply:(id)sender {
    [Util popupAlert:@"Reply pending."];
}

- (IBAction)onClickBack:(id)sender {
    [self loadChatListView];
}

@end
