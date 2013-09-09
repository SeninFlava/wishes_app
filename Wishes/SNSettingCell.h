//
//  SNSettingCell.h
//  Wishes
//
//  Created by Alexander Senin on 09.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNOneWish.h"

@interface SNSettingCell : UITableViewCell

@property SNOneWish* oneWish;

@property (weak, nonatomic) IBOutlet UISwitch *switchInSettingsCell;
- (IBAction)switchAction:(id)sender;

@end
