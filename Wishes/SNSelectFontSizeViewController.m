//
//  SNSelectFontSizeViewController.m
//  Wishes
//
//  Created by Alexander Senin on 16.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNSelectFontSizeViewController.h"

@interface SNSelectFontSizeViewController ()

@end

@implementation SNSelectFontSizeViewController

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
    self.dataArray = [NSArray arrayWithObjects:@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",nil];
}

-(void) viewWillAppear:(BOOL)animated {
    
    int selIndex = (int)[[SNFontManager sharedManager] getFontSize]-10;
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:selIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //[self.tableView set];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//сконфигурировали ячейку
-(void) configureCell:(UITableViewCell*) cell {
    CGFloat fontSize = [cell.textLabel.text floatValue];
    NSString *fontName = [[SNFontManager sharedManager] getFontName];;
    cell.textLabel.font = [UIFont fontWithName:fontName size:fontSize];
    cell.textLabel.textColor = [[SNFontManager sharedManager] getFontColor];
    
    if ([cell.textLabel.text floatValue]==[[SNFontManager sharedManager] getFontSize])
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
}

//выбрали размер
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* fontSize = [self.dataArray objectAtIndex:indexPath.row];
    
    [[SNFontManager sharedManager] setFontSize:[fontSize floatValue]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
