//
//  SNOneWish.h
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//  спасибо Eugene Romanishin

#import "UNActionPicker.h"

@implementation UNActionPicker



-(id) initWithDate:(NSDate*)date AndTitle:(NSString*)title
{
    self = [super initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        CGRect pickerFrame = CGRectMake(0.0f, 40.0f, 320.0f, 485.0f);
        
        self.picker = [[UIDatePicker alloc] initWithFrame:pickerFrame];

        [self.picker setMinuteInterval:1];
        [self.picker setDatePickerMode:UIDatePickerModeTime];
        [self.picker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru"]];
        [self.picker setDate:date animated:YES];
        
        [self addSubview:self.picker];
    }
    return self;
}


- (void)showInView:(UIView *)view {
    [super showInView:view];
    [self setBounds:CGRectMake(0.0f, 0.0f, 320.0f, 485.0f)];
}

- (void)setDoneButtonTitle:(NSString*)title color:(UIColor*)color {
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:title]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(230.0f, 7.0f, 70.0f, 30.0f);
    //closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = color;
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [self addSubview:closeButton];
}
- (void)setCancelButtonTitle:(NSString*)title color:(UIColor*)color{
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:title]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(17.0f, 7.0f, 70.0f, 30.0f);
    //closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = color;
    [closeButton addTarget:self action:@selector(cancelActionSheet) forControlEvents:UIControlEventValueChanged];
    [self addSubview:closeButton];
}

//ПРИНИМАЕМ этим методом отдаем значение делегату
- (void)dismissActionSheet {
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {

        //обрежем секунды
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        NSString* date = [formatter stringFromDate:self.picker.date];
        date = [date stringByAppendingString:@":00"];
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
        NSDate* returnedDate = [formatter dateFromString:date];
        
        
        [self.delegate performSelector:@selector(didSelectItem:) withObject:returnedDate];
    }
    else{
        NSLog(@"У делегата не назначен метод didSelectItem");
    }
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

//ОТМЕНЯЕМ этим методом отдаем значение делегату
- (void)cancelActionSheet {
    [self dismissWithClickedButtonIndex:0 animated:YES];
}


@end
