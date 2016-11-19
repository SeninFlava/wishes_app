//
//  SNStoreManager.h
//  Wishes
//
//  Created by Alexander Senin on 19.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void(^SNBuyingCompleteBlock)(BOOL isSuccess);

@interface SNStoreManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    SNBuyingCompleteBlock _comleteBlock;
}

//делаем синглтон
+(SNStoreManager*) sharedManager;


-(BOOL) isPremiumFeaturesAvailable;

-(void) buyPremiumFeaturesWithCompletionBlock:(SNBuyingCompleteBlock)completionBlock;

//восстановить покупки
-(void) checkPurchasedItems:(SNBuyingCompleteBlock)completionBlock;


@end
