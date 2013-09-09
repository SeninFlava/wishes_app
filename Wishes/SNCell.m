//
//  SNCell.m
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNCell.h"
#import "SNOneWish.h"
#import "SNWishes.h"

@implementation SNCell

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
    
    if (self.switchProperty.on)
    {
        self.wishInCell.status=@"YES";
        [self.wishInCell createLocalNotification];
        [[SNWishes sharedWishes] saveWishesToFile];
    }
    else
    {
        self.wishInCell.status=@"NO";
        [self.wishInCell deleteLocalNotification];
        [[SNWishes sharedWishes] saveWishesToFile];
    }
}


-(void) initCellWithCurrentWish {
    //NSLog(@"initCellWithCurrentWish");
    
    if ([self.wishInCell.status isEqualToString:@"YES"])
    {
        self.switchProperty.on = YES;
    }
    else
    {
        self.switchProperty.on = NO;
    }
    
    if ([self.wishInCell.repeatMode isEqualToString:@"HOUR"])
    {
        self.labelDataTime.text = @"Каждый час";
    }
    else
    {
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"hh:mm"];
        [formatter stringFromDate:self.wishInCell.dateStart];
        NSString* str = [NSString stringWithFormat:@"Каждый день в %@",[formatter stringFromDate:self.wishInCell.dateStart]];
        self.labelDataTime.text = str;
    }
    
    self.labelTextWish.text = self.wishInCell.title;
}

@end
