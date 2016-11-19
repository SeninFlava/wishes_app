//
//  SNSoundViewController.m
//  Wishes
//
//  Created by Alexander Senin on 09.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNSoundViewController.h"

@interface SNSoundViewController ()

@end

@implementation SNSoundViewController {
    AVAudioPlayer *_player;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.soundsNames = @[@"-",
                         @"Acord",
                         @"Bamboo",
                         @"Enter",
                         @"End",
                         @"Note",
                         @"Key",
                         @"Popcorn",
                         @"Hi",
                         @"Puls",
                         @"Sint",
                         @"Cicle",
                         
                         @"Alarmclock",
                         @"Laugh",
                         @"Laugh2",
                         @"Kash",
                         @"Shelk",
                         @"Reload",
                         @"Time"];
    
    self.sounds = [NSArray array];
    for (NSString *soundName in self.soundsNames)
    {
            NSBundle* mainBundle = [NSBundle mainBundle];
            NSError *error;
            NSURL* soundUrl = [NSURL fileURLWithPath:[mainBundle pathForResource:soundName ofType:nil]];
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
            if (_player)
            {
                //все ок
                [_player prepareToPlay];
                self.sounds = [self.sounds arrayByAddingObject:_player];
            }
            else
            {
                //ошибка
                NSLog(@"Error in file(%@): %@", soundName, [error localizedDescription]);
            }
    }

    
}



-(void)viewWillAppear:(BOOL)animated{
    //выставляем цвет фона
    UIColor* color = [[SNFontManager sharedManager] getBackGroundColor];
    UIView* view = [UIView new];
    [view setBackgroundColor:color];
    [self.tableView setBackgroundView:view];
    
    //выставляем цвет заголовка
    [self.navigationController.navigationBar setBarTintColor:[[SNFontManager sharedManager] getTitleColor]];
    //цвет переключателя
    [[UISwitch appearance] setOnTintColor:[[SNFontManager sharedManager] getTitleFontColor]];
    //цвет букв в заголовке
    [self.navigationController.navigationBar setTintColor:[[SNFontManager sharedManager] getTitleFontColor]];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text=[self.soundsNames objectAtIndex:indexPath.row];
    
    //выставили текущий звук
    if ([self.currentWish.soundName isEqualToString:[self.soundsNames objectAtIndex:indexPath.row]])
    {
       [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [self setFontCell:cell];
    return cell;
}



#pragma mark - Table view delegate


//выбрали ячейку
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //отменили выбор
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //поставили галки
    for (NSInteger i=0; i<self.soundsNames.count; i++)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i==indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    //воспроизвести звук
    [_player stop];
    _player = [self.sounds objectAtIndex:indexPath.row];
    [_player play];


    //переприсвоить файл
    self.currentWish.soundName = [self.soundsNames objectAtIndex:indexPath.row];
    
    //обновить уведомления
    [self.currentWish updateLocalNotification];
    
    //сохранить
    [[SNWishes sharedWishes] saveWishesToFile];
    
}

-(void) setFontCell:(UITableViewCell*) cell {
    //выставляем цвет фона
    UIColor* colorBack = [[SNFontManager sharedManager] getBackGroundColor];
    UIView* view = [UIView new];
    [view setBackgroundColor:colorBack];
    
    cell.textLabel.backgroundColor = [[SNFontManager sharedManager] getBackGroundColor];
    cell.detailTextLabel.backgroundColor = [[SNFontManager sharedManager] getBackGroundColor];
    
    [cell setBackgroundView:view];
}

@end
