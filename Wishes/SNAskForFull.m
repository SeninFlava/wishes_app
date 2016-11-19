//
//  SNAskForFull.m
//  Wishes
//
//  Created by Alexander Senin on 31.10.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNAskForFull.h"
#import "SNFullVersionManager.h"

@implementation SNAskForFull 

-(void) askForFull {
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:loc_str(@"Message") message:loc_str(@"Settings fonts, sizes and colors available in the full version.") delegate:self cancelButtonTitle:loc_str(@"Cancel") otherButtonTitles:loc_str(@"Full version"),nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex==0) {
        [self.delegate performSelector:@selector(endAsk) withObject:nil afterDelay:0];
    }
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        SNFullVersionManager* full = [[SNFullVersionManager alloc] init];
        full.delegate=self;
        [full showMessage];
    }
}

-(void) didFinishBuying {
    [self.delegate performSelector:@selector(endAsk) withObject:nil afterDelay:0];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
