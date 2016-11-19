//
//  SNCell.h
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNOneWish;

@interface SNCell : UITableViewCell

@property SNOneWish* wishInCell;

@property (weak, nonatomic) IBOutlet UISwitch *switchProperty;
- (IBAction)switchAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelDataTime;
@property (weak, nonatomic) IBOutlet UILabel *labelTextWish;

-(void) initCellWithCurrentWish;

@end
