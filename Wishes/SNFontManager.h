//
//  SNFontManager.h
//  Wishes
//
//  Created by Alexander Senin on 16.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNFontManager : NSObject

@property (strong) NSArray* fonts;
//@property NSArray* colors;

+(SNFontManager*) sharedManager;


-(void) setFontSize:(CGFloat)size;
-(void) setFontName:(NSString*)name;
-(void) setFontColor:(UIColor*)color;
-(void) setBackGroungColor:(UIColor*)color;
-(void) setTitleColor:(UIColor*)color;
-(void) setTitleFontColor:(UIColor*)color;


-(CGFloat)   getFontSize;
-(NSString*) getFontName;
-(UIColor*)  getFontColor;
-(UIColor*)  getBackGroundColor;
-(UIColor*)  getTitleColor;
-(UIColor*)  getTitleFontColor;




-(UIFont*) getFont;

@end
