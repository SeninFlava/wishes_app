//
//  SNAppDelegate.h
//  Wishes
//
//  Created by Alexander Senin on 05.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "SNWishViewController.h"


@interface SNAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SNWishViewController *wishViewController;

@end
