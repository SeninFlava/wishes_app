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
{
    CGRect _textRect;
}

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
    
    //подписываемся на клаву, добавляем кнопку готово, изменияем размер текст вью
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //подписываемся на момент когда клава будет изчезать
    //показываем кнопку настройки, если есть текст
    //изменяем рвзмеры текствью
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//метод вызывается, когда клава появилась
-(void) keyboardDidShow:(NSNotification*)note
{
    //созраняем размеры текст вью
    //_textRect =
    
    //показываем кнопку готово
    [self.navigationItem setRightBarButtonItem:self.buttonReady animated:NO];
    
    //меняем размер текстВью чтобы клава не перекрывала его
    NSDictionary *userInfo = [note userInfo];
    NSValue *bValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardRectBegin = [bValue CGRectValue];

    CGRect textViewFrame = self.textView.frame;
    textViewFrame.size.height = textViewFrame.size.height - keyboardRectBegin.size.height+self.toolBar.frame.size.height;
    self.textView.frame = textViewFrame;
    
}

//метод вызывается когда клава начинает убираться с экрана
-(void) keyboardWillHide:(NSNotification*)note
{
    [self.navigationItem setRightBarButtonItem:nil];
    //если что-то написанно, то показываем настройки
    //if (self.textView.text.length>0)
    //[self.navigationItem setRightBarButtonItem:self.buttonSettings animated:NO];
    
    //меняем размер текствью на первоначальный
    _textRect = self.view.bounds;// self.textView.frame;
    _textRect.size.height = _textRect.size.height-44;
    self.textView.frame = _textRect;//self.view.bounds;
    
}


//убираем клаву
- (IBAction)pushReadyAction:(id)sender {
    [self.textView resignFirstResponder];
}


//появляемся, выставляем текст вью и заголовок навигэшн итема
-(void) viewWillAppear:(BOOL)animated
{
    //сохранили пожелание текущее дабы не открывать его дважды
    [[NSUserDefaults standardUserDefaults] setObject:self.currentWish.idWish forKey:@"currentWish"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.textView.font = [[SNFontManager sharedManager] getFont];
    self.textView.textColor = [[SNFontManager sharedManager] getFontColor];
    
    
    //self.textView.backgroundColor = [UIColor yellowColor];
    
    
    self.textView.text = self.currentWish.text;
    [self.navigationItem setTitle:self.currentWish.title];

    
    //выставляем цвета
    self.textView.backgroundColor = [[SNFontManager sharedManager] getBackGroundColor];
    //цвет тулбара
    [self.toolBar setBarTintColor:[[SNFontManager sharedManager] getBackGroundColor]];
    [self.toolBar setTintColor:[[SNFontManager sharedManager] getTitleFontColor]];

    //выставляем цвет заголовка
    [self.navigationController.navigationBar setBarTintColor:[[SNFontManager sharedManager] getTitleColor]];
    //цвет переключателя
    [[UISwitch appearance] setOnTintColor:[[SNFontManager sharedManager] getTitleFontColor]];
    //цвет букв в заголовке
    [self.navigationController.navigationBar setTintColor:[[SNFontManager sharedManager] getTitleFontColor]];

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
    if (![self.currentWish.text isEqualToString:self.textView.text]) {
        self.currentWish.title = [self trimTextToTitle];
        self.currentWish.text = self.textView.text;
        self.currentWish.dateUpdate = [NSDate new];
    }

    
    if (self.textView.text.length==0)
        [[SNWishes sharedWishes] deleteWish:self.currentWish];
    
    [[SNWishes sharedWishes] saveWishesToFile];
}


//вызывается каждый раз при редактировании
- (void)textViewDidChange:(UITextView *)textView
{
    [self.navigationItem setTitle:[self trimTextToTitle]];
//    NSLog(@"text=%@",textView.text);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//нажали удалить
- (IBAction)pushDeleteAction:(id)sender {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:loc_str(@"Detele wish?") delegate:self cancelButtonTitle:loc_str(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:loc_str(@"Delete"), nil];
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
    //показываем настройки если что-то введено
    if (self.textView.text.length!=0)
        [self performSegueWithIdentifier:@"goToSettingOneWish" sender:self];
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:loc_str(@"Enter text wish") message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
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
