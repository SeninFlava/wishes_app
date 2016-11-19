//
//  SNDatesViewController.h
//  Wishes
//
//  Created by Alexander Senin on 10.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNOneWish.h"
#import "SNWishes.h"


@interface SNDatesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property SNOneWish *oneWish;
@property NSMutableArray* sortedSchedule;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonAdd;
- (IBAction)addTimeAction:(id)sender;

- (IBAction)pushDeleteAction:(id)sender;

@end
