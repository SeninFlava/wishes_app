//
//  SNWishViewController.m
//  Wishes
//
//  Created by Alexander Senin on 09.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNWishViewController.h"
#import "SNSettingViewController.h"

@interface SNWishViewController () <UIActionSheetDelegate>

@end

@implementation SNWishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //подписываемся на клаву, добавляем кнопку готово
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
}

//метод вызывается, когда клава появилась
-(void) keyboardDidShow
{
    [self.navigationItem setRightBarButtonItem:self.buttonReady animated:YES];
}

//убираем клаву, скрываем кнопку
- (IBAction)pushReadyAction:(id)sender {
    [self.textView resignFirstResponder];
    //[self.navigationItem setRightBarButtonItem:nil animated:YES];
    [self.navigationItem setRightBarButtonItem:self.buttonSettings animated:NO];
}


//появляемся, выставляем текст вью и заголовок навигэшн итема
-(void) viewWillAppear:(BOOL)animated
{
    self.textView.text = self.currentWish.text;
    [self.navigationItem setTitle:self.currentWish.title];
    [self.navigationItem setRightBarButtonItem:self.buttonSettings animated:NO];
}


-(NSString*) trimTextToTitle
{
    //получить заголовок нужно
    //либо обрезаем до \n
    //если \n нету, - то обрезаем 25 символов, и это заголовок
    
    NSString* text = self.textView.text;
    NSString* textToEnter=text;
    
    NSRange range = [text rangeOfString:@"\n"];
    if (range.length>0)
    {
        textToEnter=[text substringToIndex:range.location];
    }

    if (textToEnter.length>25)
        textToEnter=[NSString stringWithFormat:@"%@...", [textToEnter substringToIndex:25]];
    
    return textToEnter;
}


//исчезаем, сохраняем
-(void) viewWillDisappear:(BOOL)animated
{
    self.currentWish.title = [self trimTextToTitle];
    self.currentWish.text = self.textView.text;
    [[SNWishes sharedWishes] saveWishesToFile];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//нажали удалить
- (IBAction)pushDeleteAction:(id)sender {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Удалить пожелание?" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Удалить", nil];
    [action showInView:self.view];
}

//нажали удалить
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [[SNWishes sharedWishes] deleteWish:self.currentWish];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//вызываем метод перехода в настройки
- (IBAction)pushSettingsAction:(id)sender {
    [self performSegueWithIdentifier:@"goToSettingOneWish" sender:self];
}

//отправляем текущее пожелание в настройки
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToSettingOneWish"])
    {
        [segue.destinationViewController setOneWish:self.currentWish];
    }
}


@end
