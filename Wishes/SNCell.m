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
    
    
    //выставляем цвет фона
    UIColor* colorBack = [[SNFontManager sharedManager] getBackGroundColor];
    UIView* view = [UIView new];
    [view setBackgroundColor:colorBack];
    [self setBackgroundView:view];
    
    
    if ([self.wishInCell.status isEqualToString:@"YES"])
    {
        self.switchProperty.on = YES;
    }
    else
    {
        self.switchProperty.on = NO;
    }
    
    //выводим дату апдейта
//    NSDateFormatter* formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
//    NSString* str = [formatter stringFromDate:self.wishInCell.dateUpdate];
//    self.labelDataTime.text = str;
    
    NSString* datesStr = @"";
    //выводим времена запуска
    if (self.wishInCell.schedule.count!=0)
    {
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"HH:mm"];
        for (NSDate *dateS in self.wishInCell.schedule)
        {
            NSString* curDatesStr = [NSString stringWithFormat:@"%@; ",[formatter stringFromDate:dateS]];
            datesStr = [datesStr stringByAppendingString:curDatesStr];
        }
    }
    else
       datesStr  = loc_str(@"Not scheduled");
    
    self.labelDataTime.text = datesStr;
    
    //выставляем шрифт заголовка
    UIFont* font = [[SNFontManager sharedManager] getFont];
    [self.labelTextWish setFont:font];
    
    //выставляем цвет заголовка
    UIColor* color = [[SNFontManager sharedManager] getFontColor];
    //[self.labelTextWish setBackgroundColor:color];
    [self.labelTextWish setTextColor:color];
    
    //выставляем цвет фона
    //self.backgroundColor = [[SNFontManager sharedManager] getBackGroundColor];
    
    
    //выводим заголовок
    self.labelTextWish.text = self.wishInCell.title;
    
    //выведем шрифт заголовка
    //NSLog(@"fontName=%@",self.labelTextWish.font.fontName);
    //NSLog(@"fontSize=%@",self.labelTextWish.font fontName);
    
    NSLog(@"frameLabel=%@",NSStringFromCGRect(self.labelTextWish.frame));
    
}

@end
