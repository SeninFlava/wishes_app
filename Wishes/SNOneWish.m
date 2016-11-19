//
//  SNOneWish.m
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNOneWish.h"

@implementation SNOneWish


-(void) createLocalNotification
{
    //NSLog(@"createLocalNotification");
    //NSLog(@"repeatMode=%@", self.repeatMode);
    self.status = @"YES";
    
    
    for (NSDate* curDate in self.schedule)
    {
    
        UIApplication *app                = [UIApplication sharedApplication];
    
        UILocalNotification *notification = [UILocalNotification new];
        notification.timeZone  = [NSTimeZone systemTimeZone];
    
        //notification.fireDate  = self.dateStart;
        

        //обнулить секунды
        NSDateFormatter * df = [NSDateFormatter new];
        [df setDateFormat:@"dd.MM.yyyy HH:mm"];
        NSString* str = [df stringFromDate:curDate];
        
        notification.fireDate  = [df dateFromString:str];
        
        
        
        
        notification.alertAction = @"Wishes";
        notification.alertBody = self.title;
        
        if ([self.soundName isEqualToString:@"нет"])
            notification.soundName = nil;
        else
            notification.soundName = self.soundName;//UILocalNotificationDefaultSoundName;
        
        notification.repeatInterval = NSDayCalendarUnit;

//    if ([self.repeatMode isEqualToString:@"DAY"])
//    {
//        notification.repeatInterval = NSDayCalendarUnit;
//    }
//    else
//    {
//        notification.repeatInterval = NSHourCalendarUnit;
//    }
    
        //выставили ID
        NSDictionary *infoDict =@{@"ID": self.idWish, @"Title": self.title};
        notification.userInfo = infoDict;
    
        [app scheduleLocalNotification:notification];
    }
}

-(void) deleteLocalNotification
{
    //NSLog(@"deleteLocalNotification");
    self.status = @"NO";
    
    UIApplication *app                = [UIApplication sharedApplication];
    NSArray *oldNotifications         = [app scheduledLocalNotifications];
        
    for (UILocalNotification *aNotif in oldNotifications) {
        if([[NSString stringWithFormat:@"%@",[aNotif.userInfo objectForKey:@"ID"]] isEqualToString:[self.idWish stringValue]]) {
            [app cancelLocalNotification:aNotif];
        }
    }

}

-(void) updateLocalNotification
{
    if ([self.status isEqualToString:@"YES"])
    {
        [self deleteLocalNotification];
        [self createLocalNotification];
    }
}


@end
