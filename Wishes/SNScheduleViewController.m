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

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return [self.schedule count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mm"];
    NSDate* dateInCell = [self.schedule objectAtIndex:indexPath.row];
    
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
        [self.schedule removeObjectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}





- (IBAction)addTimeAction:(id)sender {
    UNActionPicker *actionPicker = [[UNActionPicker alloc] initWithTimeAndTitle:@"Выберите время"];
    [actionPicker setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionPicker setCloseButtonTitle:@"Done" color:[UIColor blackColor]];
    actionPicker.delegate = self;
    [actionPicker showInView:self.view];
    
    
}

//что-то выбрали из пикера
- (void)didSelectItem:(id)item {
    //NSLog(@"%@", item);
    [self.schedule addObject:item];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    [[SNWishes sharedWishes] saveWishesToFile];
    [self.oneWish updateLocalNotification];
}

@end
