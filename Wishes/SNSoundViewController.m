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

    //подготовили файлы для воспроизведения
    //self.soundsNames = @[@"Без звука",@"sms-received1.caf"];
    
    self.soundsNames = @[@"Nosound.mp3",@"Woman",@"2.mp3",@"sms-received1.caf"];
    
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

    
    
    //self.sounds = @[@"Без звука",@"sms-received1.caf"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    //сохранить
    [[SNWishes sharedWishes] saveWishesToFile];
    
}

@end
