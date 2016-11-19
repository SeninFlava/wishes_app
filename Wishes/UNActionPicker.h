//
//  SNOneWish.h
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//  спасибо Eugene Romanishin

#import <UIKit/UIKit.h>

@interface UNActionPicker : UIActionSheet

@property (strong, nonatomic) UIDatePicker *picker;


- (id) initWithDate:(NSDate*)date AndTitle:(NSString*)title;

- (void)setDoneButtonTitle:(NSString*)title color:(UIColor*)color;
- (void)setCancelButtonTitle:(NSString*)title color:(UIColor*)color;


@end
