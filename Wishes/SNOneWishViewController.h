//
//  SNOneWishViewController.h
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNOneWish;

@interface SNOneWishViewController : UIViewController

@property SNOneWish* currentWish;
//заполнить данные текущим пожеланием
-(void) prepareViewControllerWithCurrentWish;

//для того чтобы убрать клаву
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barReady;
- (IBAction)barReadyAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *labelTextWish;

//выбираем звук
- (IBAction)pushSoundAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *pushSoundButton;
//@property NSString *soundFileName;


- (IBAction)pushDeleteAction:(id)sender;


@end
