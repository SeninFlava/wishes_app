//
//  SNStoreManager.m
//  SecurityNotez
//
//  Created by Alexander Senin on 14.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNStoreManager.h"

static SNStoreManager* __sharedManager;

@implementation SNStoreManager

//setBadge

//делаем синглтон
+(SNStoreManager*) sharedManager {
    if (!__sharedManager) {
        __sharedManager=[SNStoreManager new];
    }
    return __sharedManager;
}


-(BOOL) isPremiumFeaturesAvailable {
    //возвращаем значение из настроек
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"com.Sstudio.Wishes.FullVersion"];
}

-(void) buyPremiumFeaturesWithCompletionBlock:(SNBuyingCompleteBlock)completionBlock {
     //NSLog(@"start buyPremiumFeaturesWithCompletionBlock");
    
    //проверяем может ли поьзователь совершать покупки
    if (![SKPaymentQueue canMakePayments]) {
        //NSLog(@"you can't Make Payments!");
        // Display a store to the user.
        completionBlock(NO); //вызываем наш блок и говорим ему, что покупка не удалась
        return;
    } else {
        //NSLog(@"you CAN Make Payments!");
    }
    
    //сохраняем блок, который нам передали в эту функцию, чтобы потом мы могли его вызвать
    _comleteBlock = completionBlock;
    
    //создаем запрос к магазину чтобы получить объекты или объект продук для покупок в iTunesConnect
    
    NSString* idPaiment = @"com.Sstudio.Wishes.FullVersion";
    //NSString* idPaiment = @"1";
    
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 [NSSet setWithObject: idPaiment]];
    request.delegate = self;
    [request start];

    //NSLog(@"end buyPremiumFeaturesWithCompletionBlock");

}

//будет вызвана, когда получили ответ от магазина со списком покупок
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //NSLog(@"Пришел ответ от магаза");
    
    NSArray *myProducts = response.products;
    // Populate your UI from the products list.
    // Save a reference to the products list.
    if (myProducts.count > 0)
    {
        //NSLog(@"Нашли покупку");
        //получаем текущй объект как наблюдатель за очередью покупок
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        //получаем объект продукт
        SKProduct *selectedProducts = response.products[0];
        
        //создаем платеж и добавляем его к очериде покупок
        SKPayment *payment = [SKPayment paymentWithProduct:selectedProducts];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        NSLog(@"нет доступных покупок!");
    }
    
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"updatedTransactions");
    NSLog(@"count transaction = %i",transactions.count);
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"SKPaymentTransactionStatePurchased");
                //сохраняем покупки в настройках
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.Sstudio.Wishes.FullVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (_comleteBlock) {
                    _comleteBlock(YES);
                }
                break;
            case SKPaymentTransactionStateFailed:
                //NSLog(@"SKPaymentTransactionStateFailed");
                //NSLog(@"transaction.error.code=%i",transaction.error.code);
                if (transaction.error.code!=-1) {
                    
                NSString* errorText = @"";
                if (transaction.error.code==SKErrorUnknown)
                    errorText = @"Unknown error";
                if (transaction.error.code==SKErrorClientInvalid)
                    errorText = @"client is not allowed to issue the request, etc.";
                if (transaction.error.code==SKErrorPaymentCancelled)
                    errorText = @"user cancelled the request, etc.";
                if (transaction.error.code==SKErrorPaymentInvalid)
                    errorText = @"purchase identifier was invalid, etc.";
                if (transaction.error.code==SKErrorPaymentNotAllowed)
                    errorText = @"this device is not allowed to make the payment";
                if (transaction.error.code==SKErrorStoreProductNotAvailable)
                    errorText = @"Product is not available in the current storefront";
                
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[NSString stringWithFormat:@"Code=%i. Text=%@",transaction.error.code,errorText] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //[alert show];
                NSLog(@"SKPaymentTransactionStateFailed Code=%i. Text=%@",transaction.error.code,errorText);
                    
                if (_comleteBlock) _comleteBlock(NO);
                }
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"SKPaymentTransactionStateRestored");
                //сохраняем покупки в настройках
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.Sstudio.Wishes.FullVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (_comleteBlock) _comleteBlock(YES);
            default:
                if (_comleteBlock) _comleteBlock(NO);
                break;
        }
        if (transaction.transactionState==SKPaymentTransactionStateFailed) {
            [queue finishTransaction:transaction];
        }
        
    }
}


- (void) checkPurchasedItems:(SNBuyingCompleteBlock)completionBlock;
{
    NSLog(@"checkPurchasedItems");
    _comleteBlock = completionBlock;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}// Call This Function


//Then this delegate Funtion Will be fired
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
//    self.purchasedItemIDs = [[NSMutableArray alloc] init];
    
    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    if (queue.transactions.count==0) {
        if (_comleteBlock) {
            _comleteBlock(NO);
        }
    }
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        
        NSString *productID = transaction.payment.productIdentifier;

//        [self.purchasedItemIDs addObject:productID];
        
        NSLog(@"productID=%@",productID);
        NSLog(@"transactionState=%i", transaction.transactionState);
        
        if ([productID isEqualToString:@"com.Sstudio.Wishes.FullVersion"]) {
        
        if ((transaction.transactionState==1)||(transaction.transactionState==3)) {
            if (_comleteBlock) {
                    _comleteBlock(YES);
            }
        }
            
        }

        
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"restoreCompletedTransactionsFailedWithError erro=%@",error.description);
    if (_comleteBlock) {
        _comleteBlock(NO);
    }
}



@end
