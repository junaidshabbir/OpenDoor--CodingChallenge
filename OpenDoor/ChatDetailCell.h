//
//  ChatDetailCell.h
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/4/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ChatDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblPostedBy;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblText;

@end
