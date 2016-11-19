//
//  SNSelectFontNameViewController.m
//  Wishes
//
//  Created by Alexander Senin on 16.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNSelectFontNameViewController.h"

@interface SNSelectFontNameViewController ()

@end

@implementation SNSelectFontNameViewController

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
	self.dataArray = [SNFontManager sharedManager].fonts;
    
    //[NSArray arrayWithObjects:@"Baskerville-SemiBoldItalic",@"BanglaSangamMN-Bold",nil];
}

-(void) viewWillAppear:(BOOL)animated {
    
    //[self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    int curIndex=0;
    int selIndex=0;
    for (NSString* item in [SNFontManager sharedManager].fonts) {
        if ([item isEqualToString:[[SNFontManager sharedManager] getFontName]])
            selIndex = curIndex;
        curIndex++;
    }
    
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
    CGFloat fontSize = [[SNFontManager sharedManager] getFontSize];// 17.0;//[cell.textLabel.text floatValue];
    NSString *fontName = cell.textLabel.text;
    cell.textLabel.font = [UIFont fontWithName:fontName size:fontSize];
    cell.textLabel.textColor = [[SNFontManager sharedManager] getFontColor];

    
    if ([cell.textLabel.text isEqualToString:[[SNFontManager sharedManager] getFontName]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

//выбрали шрифт
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* fontName = [self.dataArray objectAtIndex:indexPath.row];
    [[SNFontManager sharedManager] setFontName:fontName];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
