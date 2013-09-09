//
//  SNSettingViewController.m
//  Wishes
//
//  Created by Alexander Senin on 09.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNSettingViewController.h"
#import "SNSettingCell.h"
#import "SNSoundViewController.h"

@interface SNSettingViewController () <UITableViewDataSource>

@end

@implementation SNSettingViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//количество секций
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//заголовки секций
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return [NSString stringWithFormat:@"Настройка напоминаний для пожелания \"%@\"",self.oneWish.title];
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    //включить-выключить
    if (indexPath.row==0)
    {
        SNSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSwitch" forIndexPath:indexPath];
        cell.oneWish = self.oneWish;
        if ([cell.oneWish.status isEqualToString:@"YES"])
            cell.switchInSettingsCell.on = YES;
        else
            cell.switchInSettingsCell.on = NO;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone ];
        
        return cell;
    }
    //расписание
    if (indexPath.row==1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        cell.textLabel.text = @"Расписание:";
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%i",self.oneWish.schedule.count];
        
        return cell;
    }
    //звук
    if (indexPath.row==2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        cell.textLabel.text = @"Звук напоминания:";
        cell.detailTextLabel.text = self.oneWish.soundName;
        
        return cell;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==1)
    {
        [self performSegueWithIdentifier:@"goToDates" sender:self];
    }
    
    if (indexPath.row==2) {
        [self performSegueWithIdentifier:@"goToSounds" sender:self];
    }
}

//совершаем переход, устанавливаем данные
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"goToDates"])
    {
        [segue.destinationViewController setOneWish:self.oneWish];
    }
    if ([segue.identifier isEqualToString:@"goToSounds"])
    {
        [segue.destinationViewController setCurrentWish:self.oneWish];
    }
}

@end
