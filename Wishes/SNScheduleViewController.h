//
//  SNScheduleViewController.h
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNOneWish.h"

@interface SNScheduleViewController : UITableViewController 

@property SNOneWish *oneWish;
@property NSMutableArray* schedule;

- (IBAction)addTimeAction:(id)sender;

@end
