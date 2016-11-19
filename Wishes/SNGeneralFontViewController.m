//
//  SNGeneralFontViewController.m
//  Wishes
//
//  Created by Alexander Senin on 16.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNGeneralFontViewController.h"
#import "SNColorCell.h"
#import "SNFullVersionManager.h"
#import "SNStoreManager.h"
#import "SNAskForFull.h"

@interface SNGeneralFontViewController () <InfColorPickerControllerDelegate> {
    NSString* _fontFlagColorSelect;
    SNAskForFull* _ask;
}

@end

@implementation SNGeneralFontViewController

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
}

-(void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 6;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = loc_str(@"Full version");
        return cell;
    }
    
    SNColorCell* cellOur;
    UITableViewCell* cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        cell.textLabel.text = loc_str(@"Font");
        
        //получаем из UserDefaults
        cell.detailTextLabel.text = [[SNFontManager sharedManager] getFontName];
        cell.detailTextLabel.font = [[SNFontManager sharedManager] getFont];
        cell.detailTextLabel.textColor = [[SNFontManager sharedManager] getFontColor];
        //cell.detailTextLabel.backgroundColor = color;
    }

    if (indexPath.row==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        cell.textLabel.text = loc_str(@"Size");
        
        //получаем из UserDefaults
        NSString *fontSize = [NSString stringWithFormat:@"%i", (int)[[SNFontManager sharedManager] getFontSize]];
        cell.detailTextLabel.text = fontSize;
        cell.detailTextLabel.font = [[SNFontManager sharedManager] getFont];
        cell.detailTextLabel.textColor = [[SNFontManager sharedManager] getFontColor];
    }
    
    if (indexPath.row==2){
        cellOur = [tableView dequeueReusableCellWithIdentifier:@"CellColor" forIndexPath:indexPath];
        [cellOur setAccessoryType:UITableViewCellAccessoryNone];
        cellOur.labelTextOur.text = loc_str(@"Font color");
        cellOur.imageViewOur.backgroundColor = [[SNFontManager sharedManager] getFontColor];
        return cellOur;
    }
    
    if (indexPath.row==3){
        cellOur = [tableView dequeueReusableCellWithIdentifier:@"CellColor" forIndexPath:indexPath];
        [cellOur setAccessoryType:UITableViewCellAccessoryNone];
        cellOur.labelTextOur.text = loc_str(@"Background color");
        cellOur.imageViewOur.backgroundColor = [[SNFontManager sharedManager] getBackGroundColor];
        return cellOur;
    }

    if (indexPath.row==4){
        cellOur = [tableView dequeueReusableCellWithIdentifier:@"CellColor" forIndexPath:indexPath];
        [cellOur setAccessoryType:UITableViewCellAccessoryNone];
        cellOur.labelTextOur.text = loc_str(@"Title color");
        cellOur.imageViewOur.backgroundColor = [[SNFontManager sharedManager] getTitleColor];
        return cellOur;
    }

    if (indexPath.row==5){
        cellOur = [tableView dequeueReusableCellWithIdentifier:@"CellColor" forIndexPath:indexPath];
        [cellOur setAccessoryType:UITableViewCellAccessoryNone];
        cellOur.labelTextOur.text = loc_str(@"Title font color");
        cellOur.imageViewOur.backgroundColor = [[SNFontManager sharedManager] getTitleFontColor];
        return cellOur;
    }


    return cell;
}

#pragma mark -TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![[SNStoreManager sharedManager] isPremiumFeaturesAvailable]) {
//        self.navigationItem.leftBarButtonItem.enabled = NO;
//        [UIView animateWithDuration:1 animations:^{self.tableView.alpha = 0.3;}];
//        self.tableView.userInteractionEnabled = NO;
//        self.navigationItem.title = loc_str(@"Loading...");
//        self.navigationItem.leftBarButtonItem.enabled=NO;
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
//        SNFullVersionManager* full = [[SNFullVersionManager alloc] init];
//        full.delegate=self;
//        [full showMessage];
//        return;
        _ask = [[SNAskForFull alloc] init];
        _ask.delegate = self;
        [_ask askForFull];
        return;
    }
    
    if (indexPath.row==0){
        //переходим на выбор шрифта
        [self performSegueWithIdentifier:@"goToFontName" sender:self];
    }
    
    if (indexPath.row==1)
    {
        //переходим на выбор размера шрифта
        [self performSegueWithIdentifier:@"goToFontSize" sender:self];        
    }
    
    if (indexPath.row==2)
    {
        //переходим на выбор размера шрифта
        //[self performSegueWithIdentifier:@"goToFontColor" sender:self];
        
        //вызываем InfColorPicker для выбора цвета
        _fontFlagColorSelect = @"Text";
        InfColorPickerController* cp = [InfColorPickerController colorPickerViewController];
        cp.title = loc_str(@"Font color");
        cp.resultColor = [[SNFontManager sharedManager] getFontColor];
        [cp presentModallyOverViewController:self];
        cp.delegate=self;
        
    }

    if (indexPath.row==3)
    {
        //переходим на выбор размера шрифта
        //[self performSegueWithIdentifier:@"goToBackColor" sender:self];
        //вызываем InfColorPicker для выбора цвета
        _fontFlagColorSelect = @"Back";
        InfColorPickerController* cp = [InfColorPickerController colorPickerViewController];
        cp.title = loc_str(@"Background color");
        cp.resultColor = [[SNFontManager sharedManager] getBackGroundColor];
        [cp presentModallyOverViewController:self];
        cp.delegate=self;
    }

    if (indexPath.row==4)
    {
        //переходим на выбор размера шрифта
        //[self performSegueWithIdentifier:@"goToBackColor" sender:self];
        //вызываем InfColorPicker для выбора цвета
        _fontFlagColorSelect = @"Title";
        InfColorPickerController* cp = [InfColorPickerController colorPickerViewController];
        cp.title = loc_str(@"Title color");
        cp.resultColor = [[SNFontManager sharedManager] getTitleColor];
        [cp presentModallyOverViewController:self];
        cp.delegate=self;
    }

    if (indexPath.row==5)
    {
        //переходим на выбор размера шрифта
        //[self performSegueWithIdentifier:@"goToBackColor" sender:self];
        //вызываем InfColorPicker для выбора цвета
        _fontFlagColorSelect = @"TitleFont";
        InfColorPickerController* cp = [InfColorPickerController colorPickerViewController];
        cp.title = loc_str(@"Title font");
        cp.resultColor = [[SNFontManager sharedManager] getTitleFontColor];
        [cp presentModallyOverViewController:self];
        cp.delegate=self;
    }
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

#pragma mark -InfColorPickerController delegate
- (void) colorPickerControllerDidFinish: (InfColorPickerController*) controller{
    //NSLog(@"colorPickerControllerDidFinish");
    if ([_fontFlagColorSelect isEqualToString:@"Text"]) {
        [[SNFontManager sharedManager] setFontColor:controller.resultColor];
    }
    
    if ([_fontFlagColorSelect isEqualToString:@"Back"]) {
        [[SNFontManager sharedManager] setBackGroungColor:controller.resultColor];
    }
    
    if ([_fontFlagColorSelect isEqualToString:@"Title"]) {
        [[SNFontManager sharedManager] setTitleColor:controller.resultColor];
        [self.navigationController.navigationBar setBarTintColor:[[SNFontManager sharedManager] getTitleColor]];
    }

    if ([_fontFlagColorSelect isEqualToString:@"TitleFont"]) {
        [[SNFontManager sharedManager] setTitleFontColor:controller.resultColor];
        [self.navigationController.navigationBar setTintColor:[[SNFontManager sharedManager] getTitleFontColor]];
    }
    
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}
// This is only called when the color picker is presented modally.

- (void) colorPickerControllerDidChangeColor: (InfColorPickerController*) controller{
   // NSLog(@"colorPickerControllerDidChangeColor");
    
}

- (IBAction)pushReadyAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - snfullversionmanager
-(void) didFinishBuying {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [UIView animateWithDuration:1 animations:^{self.tableView.alpha = 1;}];
    self.tableView.userInteractionEnabled = YES;
    self.navigationItem.title = loc_str(@"Font settings");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - snaskforfull
-(void) endAsk {
//    self.navigationItem.leftBarButtonItem.enabled = YES;
//    [UIView animateWithDuration:0.3 animations:^{self.tableView.alpha = 1;}];
//    self.tableView.userInteractionEnabled = YES;
//    self.navigationItem.title = loc_str(@"Font settings");
//    self.navigationItem.leftBarButtonItem.enabled=YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
