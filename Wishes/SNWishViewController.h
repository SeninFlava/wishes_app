//
//  SNWishViewController.h
//  Wishes
//
//  Created by Alexander Senin on 09.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNOneWish.h"
#import "SNWishes.h"

@interface SNWishViewController : UIViewController <UITextViewDelegate>

@property SNOneWish* currentWish;

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)pushDeleteAction:(id)sender;

//кнопка которая убирает клаву
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonReady;
//убираем клаву
- (IBAction)pushReadyAction:(id)sender;


//кнопка, по которой переходим в настройки
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonSettings;
- (IBAction)pushSettingsAction:(id)sender;


@end
