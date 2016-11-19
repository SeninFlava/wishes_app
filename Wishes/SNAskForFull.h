//
//  SNAskForFull.h
//  Wishes
//
//  Created by Alexander Senin on 31.10.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNAskForFull : NSObject <UIAlertViewDelegate>

@property id delegate;

-(void) askForFull;

@end
