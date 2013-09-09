//
//  SNOneWishViewController.m
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNOneWishViewController.h"
#import "SNOneWish.h"
#import "SNWishes.h"
#import "SNScheduleViewController.h"
#import "SNSoundViewController.h"

@interface SNOneWishViewController ()

@end

@implementation SNOneWishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//заполнили данные из текущего пожелания, вызываем вначале
-(void) prepareViewControllerWithCurrentWish
{

    self.labelTextWish.text = self.currentWish.title;
    
    NSString *soundName =[NSString stringWithFormat:@"Звук: %@",self.currentWish.soundName];
    [self.pushSoundButton setTitle:soundName forState:UIControlStateNormal];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //подписаться на клаву
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWilShow) name:@"UIKeyboardWillShowNotification" object:nil];
    
    
    //подписаться на выбор звука
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundChange:) name:@"ChangeSound" object:nil];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //подготовили данные
    [self prepareViewControllerWithCurrentWish];
}

-(void) soundChange:(NSNotification*)note
{
    NSString* newSound = note.userInfo[@"newSound"];
    [self.pushSoundButton setTitle:[NSString stringWithFormat:@"Звук:%@",newSound] forState:UIControlStateNormal];
}

-(void) keyboardWilShow
{
    self.navigationItem.rightBarButtonItem=self.barReady;
}

- (IBAction)barReadyAction:(id)sender {
    [self.labelTextWish resignFirstResponder];

}




- (IBAction)pushSoundAction:(id)sender {
}


- (IBAction)pushSaveAction:(id)sender {
    if (self.currentWish)
    {
        //заменяем
        SNOneWish* wish = self.currentWish;
        
        wish.title = self.labelTextWish.text;
        wish.repeatMode = @"HOUR";

        
        wish.soundName = @"";
        //wish.status = @"YES";
        
        //[[SNWishes sharedWishes] updateWish:self.currentWish withWish:wish];
        
        [wish updateLocalNotification];
        [[SNWishes sharedWishes] saveWishesToFile];

    }
    else
    {
        //cоздаем
        //заменяем
        SNOneWish* wish = [SNOneWish new];
        
        wish.title = self.labelTextWish.text;
        
        wish.repeatMode = @"HOUR";
        
        wish.soundName = @"";
        wish.status = @"YES";
        
        [[SNWishes sharedWishes] addWish:wish];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)pushDeleteAction:(id)sender {
    [[SNWishes sharedWishes] deleteWish:self.currentWish];
    [self.navigationController popViewControllerAnimated:YES];
}

//переходим к расписанию
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToDates"]) {

        [segue.destinationViewController setSchedule:self.currentWish.schedule];
        [segue.destinationViewController setOneWish:self.currentWish];
    }
    
    if ([segue.identifier isEqualToString:@"goToSounds"]) {
        
        [segue.destinationViewController setCurrentWish:self.currentWish];
    }
}
@end
