//
//  SNDatesViewController.m
//  Wishes
//
//  Created by Alexander Senin on 10.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNDatesViewController.h"
#import "UNActionPicker.h"
#import "ActionSheetDatePicker.h"


@interface SNDatesViewController ()<UIActionSheetDelegate>
{
    NSInteger _indexSelectedDate;
}


@end

@implementation SNDatesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//сортировка расписания по времени
-(void) sortSchedule
{
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HHmm"];
    
    NSArray *sortedArray = [NSArray new];
//    for (NSDate* curDate in self.oneWish.schedule) {
//
//        sortedArray = [sortedArray arrayByAddingObject:<#(id)#>]
//        
//    }
    //NSLog(@"start sort");
    sortedArray = [self.sortedSchedule sortedArrayUsingComparator:
                   ^NSComparisonResult(id a, id b) {
                       NSDate *first = a;
                       NSDate *second = b;
                       NSInteger iFirst = [[formatter stringFromDate:first] integerValue];
                       NSInteger iSecond = [[formatter stringFromDate:second] integerValue];
                       
                       //NSLog(@"first=%i second=%i",iFirst,iSecond);
                       
                       if (iFirst>iSecond)
                           return 1;
                       else
                           return 0;
                       //return [first compare:second];
                   }];
    //array = sortedArray;
    self.sortedSchedule = [NSMutableArray arrayWithArray:sortedArray];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.sortedSchedule = self.oneWish.schedule;
    [self sortSchedule];
}

-(void) viewWillAppear:(BOOL)animated
{
    //выставляем цвет фона
    UIColor* color = [[SNFontManager sharedManager] getBackGroundColor];
    UIView* view = [UIView new];
    [view setBackgroundColor:color];
    [self.tableView setBackgroundView:view];
    
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
    [self setFontCell:cell];
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


 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the item to be re-orderable.
     return NO;
 }


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - Table view delegate

//нажали удалить
- (IBAction)pushDeleteAction:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}



//когда кликнули по ячейке - вызываем пикер и меняем выбранное время
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* secectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    _indexSelectedDate = indexPath.row;
    
    ActionSheetDatePicker* datePicker;
    datePicker = [ActionSheetDatePicker showPickerWithTitle:loc_str(@"Change time") datePickerMode:UIDatePickerModeTime selectedDate:[self.sortedSchedule objectAtIndex:_indexSelectedDate] target:self action:@selector(didSelectItem:) origin:secectedCell.textLabel];
    
//    UNActionPicker *actionPicker = [[UNActionPicker alloc] initWithDate:[self.sortedSchedule objectAtIndex:_indexSelectedDate] AndTitle:loc_str(@"Change time")];
//    [actionPicker setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
//    [actionPicker setDoneButtonTitle:loc_str(@"Select") color:[UIColor blackColor]];
//    [actionPicker setCancelButtonTitle:loc_str(@"Cancel") color:[UIColor blackColor]];
//    actionPicker.delegate = self;
//    [actionPicker showInView:self.view];
    
}




//нажали добавить новую дату
- (IBAction)addTimeAction:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    
    _indexSelectedDate = -1;

    ActionSheetDatePicker* datePicker;
    datePicker = [ActionSheetDatePicker showPickerWithTitle:loc_str(@"Add time") datePickerMode:UIDatePickerModeTime selectedDate:[NSDate new] target:self action:@selector(didSelectItem:) origin:self.buttonAdd];
    
//    UNActionPicker *actionPicker = [[UNActionPicker alloc] initWithDate:[NSDate new] AndTitle:loc_str(@"Add time")];
//    [actionPicker setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
//    [actionPicker setDoneButtonTitle:loc_str(@"Select") color:[UIColor blackColor]];
//    [actionPicker setCancelButtonTitle:loc_str(@"Cancel") color:[UIColor blackColor]];
//    actionPicker.delegate = self;
//    [actionPicker showInView:self.view];
}


//что-то выбрали из пикера
- (void)didSelectItem:(NSDate*)item {
    
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
