//
//  SNBuyFullViewController.h
//  Wishes
//
//  Created by Alexander Senin on 12.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface SNBuyFullViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
- (IBAction)pushBuyAction:(id)sender;

@end
