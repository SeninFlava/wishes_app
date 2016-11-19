//
//  SNTableViewController.m
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNTableViewController.h"
#import "SNWishes.h"
#import "SNOneWish.h"
#import "SNCell.h"
//#import "SNOneWishViewController.h"
#import "SNWishViewController.h"
#import "SNPriceManager.h"

@interface SNTableViewController () <UIAlertViewDelegate>

@end

@implementation SNTableViewController

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
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentWish"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

    
    
    [[SNWishes sharedWishes] sortWishesByDateUpadate];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SNWishes sharedWishes].allWishes count];
}

- (SNCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    
    SNCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    SNOneWish* wish = [[SNWishes sharedWishes].allWishes objectAtIndex:indexPath.row];
    
    cell.wishInCell = wish;
    [cell initCellWithCurrentWish];
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        SNOneWish* wish = [[SNWishes sharedWishes].allWishes objectAtIndex:indexPath.row];
        [[SNWishes sharedWishes] deleteWish:wish];
        [[SNWishes sharedWishes] saveWishesToFile];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another <#DetailViewController#>view controller.
    /*
     <#DetailViewController#> *detailViewController = [[ alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//нажали добавить пожелание
- (IBAction)addWishAction:(id)sender {
//gросто совершаем переход
}


- (IBAction)pushFontSelectAction:(id)sender {
//проверяем какой аккаунт у нас преобретен
    //[self performSegueWithIdentifier:@"goToFonts" sender:self];
    [self performSegueWithIdentifier:@"goToFonts" sender:self];

}




- (IBAction)showAll:(id)sender {
    UIApplication *app                = [UIApplication sharedApplication];
    NSArray *oldNotifications         = [app scheduledLocalNotifications];
    NSLog(@"AllNotifications=%@",oldNotifications);
}




-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToOneWish"]) {
        SNOneWish *wish = [[SNWishes sharedWishes].allWishes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        [segue.destinationViewController setCurrentWish:wish];
    }
    if ([segue.identifier isEqualToString:@"goToNewWish"]) {
        SNOneWish *wish = [[SNWishes sharedWishes] addWish];
        [segue.destinationViewController setCurrentWish:wish];
    }
    
}

@end
