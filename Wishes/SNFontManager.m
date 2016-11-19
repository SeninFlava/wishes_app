//
//  SNFontManager.m
//  Wishes
//
//  Created by Alexander Senin on 16.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNFontManager.h"

static SNFontManager* __sharedFontManager;

@implementation SNFontManager

+(SNFontManager*) sharedManager{
    if (!__sharedFontManager) {
        __sharedFontManager = [SNFontManager new];
        [__sharedFontManager loadFontsToArray];
        [__sharedFontManager loadColorsToArray];
    }
    return __sharedFontManager;
}

//заполняем массив шрифтов
-(void) loadFontsToArray{
    NSArray *allFont = [NSArray array];
    for (NSString* item in [UIFont familyNames]) {
        allFont = [allFont arrayByAddingObjectsFromArray:[UIFont fontNamesForFamilyName:item]];
    }
    self.fonts = allFont;
}

-(void) loadColorsToArray{
    NSArray* allColors = [NSArray array];
    allColors = [allColors arrayByAddingObject:[UIColor redColor]];
    allColors = [allColors arrayByAddingObject:[UIColor greenColor]];
    allColors = [allColors arrayByAddingObject:[UIColor yellowColor]];
    allColors = [allColors arrayByAddingObject:[UIColor whiteColor]];
    allColors = [allColors arrayByAddingObject:[UIColor blackColor]];
    allColors = [allColors arrayByAddingObject:[UIColor blueColor]];
}

-(void) setFontSize:(CGFloat)size{
    NSString* fontSize = [NSString stringWithFormat:@"%f",size];
    [[NSUserDefaults standardUserDefaults] setObject:fontSize forKey:@"UDFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void) setFontName:(NSString*)name{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"UDFontName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void) setFontColor:(UIColor*)color{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    [[NSUserDefaults standardUserDefaults] setFloat:red forKey:@"UDFontColorRED"];
    [[NSUserDefaults standardUserDefaults] setFloat:green forKey:@"UDFontColorGREEN"];
    [[NSUserDefaults standardUserDefaults] setFloat:blue forKey:@"UDFontColorBLUE"];
    [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"UDFontColorALPHA"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void) setBackGroungColor:(UIColor*)color{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    [[NSUserDefaults standardUserDefaults] setFloat:red forKey:@"UDBackGroundColorRED"];
    [[NSUserDefaults standardUserDefaults] setFloat:green forKey:@"UDBackGroundColorGREEN"];
    [[NSUserDefaults standardUserDefaults] setFloat:blue forKey:@"UDBackGroundColorBLUE"];
    [[NSUserDefaults standardUserDefaults] setFloat:alpha forKey:@"UDBackGroundColorALPHA"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setTitleColor:(UIColor*)color {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    [[NSUserDefaults standardUserDefaults] setFloat:red forKey:@"UDTitleColorRED"];
    [[NSUserDefaults standardUserDefaults] setFloat:green forKey:@"UDTitleColorGREEN"];
    [[NSUserDefaults standardUserDefaults] setFloat:blue forKey:@"UDTitleColorBLUE"];
    [[NSUserDefaults standardUserDefaults] setFloat:alpha forKey:@"UDTitleColorALPHA"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) setTitleFontColor:(UIColor*)color {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    [[NSUserDefaults standardUserDefaults] setFloat:red forKey:@"UDTitleFontColorRED"];
    [[NSUserDefaults standardUserDefaults] setFloat:green forKey:@"UDTitleFontColorGREEN"];
    [[NSUserDefaults standardUserDefaults] setFloat:blue forKey:@"UDTitleFontColorBLUE"];
    [[NSUserDefaults standardUserDefaults] setFloat:alpha forKey:@"UDTitleFontColorALPHA"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


-(CGFloat) getFontSize{
    NSString* fontSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"UDFontSize"];
    if (fontSize==nil) {
        fontSize = @"19";
    }
    CGFloat retValSize = [fontSize floatValue];
    return retValSize;
}
-(NSString*) getFontName{
    NSString* fontName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UDFontName"];
//    if (fontName==nil) {
//        fontName = @"Baskerville-SemiBoldItalic";
//    }
    return fontName;
}
-(UIColor*) getFontColor{
    CGFloat red = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDFontColorRED"];
    CGFloat green = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDFontColorGREEN"];
    CGFloat blue = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDFontColorBLUE"];
    CGFloat alpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDFontColorALPHA"];

//    NSLog(@"red=%f",red);
//    NSLog(@"green=%f",green);
//    NSLog(@"blue=%f",blue);
//    NSLog(@"alpha=%f",alpha);
    
    UIColor* returnColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

    if (red==0 && green==0 && blue==0 && alpha==0)
        return [UIColor blackColor];
    
    return returnColor;
}
-(UIColor*) getBackGroundColor{
    CGFloat red = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDBackGroundColorRED"];
    CGFloat green = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDBackGroundColorGREEN"];
    CGFloat blue = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDBackGroundColorBLUE"];
    CGFloat alpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDBackGroundColorALPHA"];
    
    UIColor* returnColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    if (red==0 && green==0 && blue==0 && alpha==0)
        return [UIColor whiteColor];
    
    return returnColor;
}

-(UIColor*) getTitleColor{
    CGFloat red = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDTitleColorRED"];
    CGFloat green = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDTitleColorGREEN"];
    CGFloat blue = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDTitleColorBLUE"];
    CGFloat alpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDTitleColorALPHA"];
    
    UIColor* returnColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    if (red==0 && green==0 && blue==0 && alpha==0)
        return [UIColor colorWithRed:247.f/255 green:247.f/255 blue:247.f/255 alpha:1];

    return returnColor;
}

-(UIColor*) getTitleFontColor{
    CGFloat red = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDTitleFontColorRED"];
    CGFloat green = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDTitleFontColorGREEN"];
    CGFloat blue = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDTitleFontColorBLUE"];
    CGFloat alpha = [[NSUserDefaults standardUserDefaults] floatForKey:@"UDTitleFontColorALPHA"];
    
    UIColor* returnColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    if (red==0 && green==0 && blue==0 && alpha==0)
        returnColor = [UIColor colorWithRed:240.f/255.f green:163.f/255.f blue:0 alpha:1];
    
    return returnColor;
}



-(UIFont*) getFont {
    UIFont* returnFont = [UIFont fontWithName:[self getFontName] size:[self getFontSize]];
    return returnFont;
}

@end
