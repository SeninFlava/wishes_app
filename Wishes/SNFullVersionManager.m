//
//  SNFullVersionManager.m
//  tableEditEdit
//
//  Created by Alexander Senin on 23.10.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNFullVersionManager.h"
#import "SNStoreManager.h"
#import "SNPriceManager.h"

@implementation SNFullVersionManager 

-(void) showMessage {
    [[SNPriceManager sharedManager] getPricePaymentId:@"com.Sstudio.Wishes.FullVersion" withCompletionBlock:^(BOOL isSuccess, NSString *price) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:loc_str(@"Message") message:loc_str(@"Settings fonts, sizes and colors available in the full version.") delegate:self cancelButtonTitle:loc_str(@"Cancel") otherButtonTitles:loc_str(@"Restore"),[NSString stringWithFormat:loc_str(@"Buy for %@"),price],nil];
        [alert show];
    }];
}



#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     NSLog(@"buttonIndex=%i",buttonIndex);
    
    //восстанавливаем
    if (buttonIndex==1) {
        [[SNStoreManager sharedManager] checkPurchasedItems:^(BOOL isSuccess) {
            if (isSuccess) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.Sstudio.Wishes.FullVersion"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:loc_str(@"Complete") message:loc_str(@"Congratulation!") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                //покупка не восставлена, предлагаем купить
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:loc_str(@"Error") message:loc_str(@"You did't buy full version.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            [self.delegate performSelector:@selector(didFinishBuying) withObject:nil];
            
        }];
    }
    
    //покупаем
    if (buttonIndex==2) {
        //NSLog(@"Start Buying!");
        [[SNStoreManager sharedManager] buyPremiumFeaturesWithCompletionBlock:^(BOOL isSuccess) {
            if (!isSuccess) {
                //NSLog(@"Error buying");
                //UIAlertView* selectAlert =[[UIAlertView alloc] initWithTitle:@"Покупка не удалась" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //[selectAlert show];
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.Sstudio.Wishes.FullVersion"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:loc_str(@"Complete") message:loc_str(@"Congratulation!") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                //NSLog(@"Buying Complete");
            }
            [self.delegate performSelector:@selector(didFinishBuying) withObject:nil];
        }];
        
        //NSLog(@"end Buying!");
    }
    
    //нажали отмена
    if (buttonIndex==0) {
        [self.delegate performSelector:@selector(didFinishBuying) withObject:nil];
    }
}



@end
