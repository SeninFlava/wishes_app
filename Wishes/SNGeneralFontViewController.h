//
//  SNGeneralFontViewController.h
//  Wishes
//
//  Created by Alexander Senin on 16.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNGeneralFontViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)pushReadyAction:(id)sender;

@end
