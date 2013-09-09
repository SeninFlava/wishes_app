//
//  SNScheduleViewController.m
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNScheduleViewController.h"
#import "SNOneWish.h"
#import "SNWishes.h"
#import "UNActionPicker.h"

@interface SNScheduleViewController () <UIActionSheetDelegate>
{
    NSInteger _indexSelectedDate;
}
@end

@implementation SNScheduleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//сортировка расписания
-(void) sortSchedule
{
    NSArray *sortedArray;
    sortedArray = [self.sortedSchedule sortedArrayUsingComparator: \
                   ^NSComparisonResult(id a, id b) {
                       NSDate *first = a;
                       NSDate *second = b;
                       return [first compare:second];
                   }];
    //array = sortedArray;
    self.sortedSchedule = [NSMutableArray arrayWithArray:sortedArray];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.sortedSchedule = self.oneWish.schedule;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortedSchedule count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    NSDate* dateInCell = [self.sortedSchedule objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [formatter stringFromDate:dateInCell];
    
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        [self.sortedSchedule removeObjectAtIndex:indexPath.row];
        
        self.oneWish.schedule = self.sortedSchedule;
        [[SNWishes sharedWishes] saveWishesToFile];
        [self.oneWish updateLocalNotification];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

//когда кликнули по ячейке - вызываем пикер и меняем выбранное время
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _indexSelectedDate = indexPath.row;
    UNActionPicker *actionPicker = [[UNActionPicker alloc] initWithDate:[self.sortedSchedule objectAtIndex:_indexSelectedDate] AndTitle:@"Измените время"];
    [actionPicker setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionPicker setDoneButtonTitle:@"Выбрать" color:[UIColor blackColor]];
    [actionPicker setCancelButtonTitle:@"Отменить" color:[UIColor blackColor]];
    actionPicker.delegate = self;
    [actionPicker showInView:self.view];
    
}



//нажали добавить новую дату
- (IBAction)addTimeAction:(id)sender {
    _indexSelectedDate = -1;
    UNActionPicker *actionPicker = [[UNActionPicker alloc] initWithDate:[NSDate new] AndTitle:@"Выберите время"];
    [actionPicker setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionPicker setDoneButtonTitle:@"Выбрать" color:[UIColor blackColor]];
    [actionPicker setCancelButtonTitle:@"Отменить" color:[UIColor blackColor]];
    actionPicker.delegate = self;
    [actionPicker showInView:self.view];
}

//что-то выбрали из пикера
- (void)didSelectItem:(id)item {
    
    if (_indexSelectedDate==-1)
    {
        //создвем новую дату в расписании
        [self.sortedSchedule addObject:item];
    }
    else
    {
        //меняем выбранную
        [self.sortedSchedule replaceObjectAtIndex:_indexSelectedDate withObject:item];
    }
    
    [self sortSchedule];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    
    self.oneWish.schedule = self.sortedSchedule;
    [[SNWishes sharedWishes] saveWishesToFile];
    [self.oneWish updateLocalNotification];
}

@end
