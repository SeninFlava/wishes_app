//
//  SNSoundViewController.h
//  Wishes
//
//  Created by Alexander Senin on 09.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>

#import "SNOneWish.h"
#import "SNWishes.h"

@interface SNSoundViewController : UITableViewController

@property NSArray* sounds;
@property NSArray* soundsNames;


@property SNOneWish* currentWish;

@end
