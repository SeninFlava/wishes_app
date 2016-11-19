//
//  SNTableViewController.h
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNCell.h"

@interface SNTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonAdd;
- (IBAction)addWishAction:(id)sender;

- (IBAction)showAll:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonFontSelect;
- (IBAction)pushFontSelectAction:(id)sender;

@end
