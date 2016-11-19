//
//  SNSelectBackViewController.m
//  Wishes
//
//  Created by Alexander Senin on 17.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNSelectBackViewController.h"

@interface SNSelectBackViewController ()

@end

@implementation SNSelectBackViewController

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
    self.dataArray = @[@"Черный",@"Красный",@"Синий",@"Желтый",@"Зеленый",@"Белый"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//сконфигурировали ячейку
-(void) configureCell:(UITableViewCell*) cell {
    CGFloat fontSize = [cell.textLabel.text floatValue];
    NSString *fontName = [[SNFontManager sharedManager] getFontName];
    cell.textLabel.font = [UIFont fontWithName:fontName size:fontSize];
    if ([cell.textLabel.text isEqualToString:@"Черный"]) {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if ([cell.textLabel.text isEqualToString:@"Красный"]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    if ([cell.textLabel.text isEqualToString:@"Синий"]) {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    if ([cell.textLabel.text isEqualToString:@"Желтый"]) {
        cell.textLabel.textColor = [UIColor yellowColor];
    }
    if ([cell.textLabel.text isEqualToString:@"Зеленый"]) {
        cell.textLabel.textColor = [UIColor greenColor];
    }
    if ([cell.textLabel.text isEqualToString:@"Белый"]) {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
}

//выбрали цвет
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIColor* fontColor = [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor;
    
    [[SNFontManager sharedManager] setBackGroungColor:fontColor];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
