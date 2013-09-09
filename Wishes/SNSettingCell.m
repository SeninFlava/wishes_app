//
//  SNSettingCell.m
//  Wishes
//
//  Created by Alexander Senin on 09.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNSettingCell.h"
#import "SNWishes.h"

@implementation SNSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchAction:(id)sender {
    if (self.switchInSettingsCell.on) {
        self.oneWish.status=@"YES";
        [self.oneWish createLocalNotification];
    } else {
        self.oneWish.status=@"NO";
        [self.oneWish deleteLocalNotification];
    }
    [[SNWishes sharedWishes] saveWishesToFile];

}
@end
