//
//  SNPriceManager.m
//  SecurityNotes
//
//  Created by Alexander Senin on 11.10.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNPriceManager.h"

static SNPriceManager* __sharedManager;


@implementation SNPriceManager

+(SNPriceManager*) sharedManager {
    if (!__sharedManager) {
        __sharedManager=[SNPriceManager new];
    }
    return __sharedManager;

}


-(void) getPricePaymentId:(NSString*)paymentId withCompletionBlock:(SNGetPriceCompleteBlock)block {
    //NSLog(@"start buyPremiumFeaturesWithCompletionBlock");
    
    //проверяем может ли поьзователь совершать покупки
    if (![SKPaymentQueue canMakePayments]) {
        //NSLog(@"you can't Make Payments!");
        // Display a store to the user.
        block(NO,@"not found"); //вызываем наш блок и говорим ему, что покупка не удалась
        return;
    } else {
        //NSLog(@"you CAN Make Payments!");
    }
    
    //сохраняем блок, который нам передали в эту функцию, чтобы потом мы могли его вызвать
    _completeBlock = block;
    
    //создаем запрос к магазину чтобы получить объекты или объект продук для покупок в iTunesConnect
    NSString* idPaiment = paymentId;//@"SuperNotes.FullVersion";
    
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 [NSSet setWithObject: idPaiment]];
    request.delegate = self;
    [request start];
    
    //NSLog(@"end buyPremiumFeaturesWithCompletionBlock");

}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    //NSLog(@"productsRequest didReceiveResponse");
    NSArray *myProducts = response.products;
    // Populate your UI from the products list.
    // Save a reference to the products list.
    if (myProducts.count > 0)
    {
        //NSLog(@"Нашли покупку");
        //получаем объект продукт
        SKProduct *selectedProduct = response.products[0];
        
        //NSLog(@"selectedProduct=%@",selectedProduct);
        
        if (_completeBlock) {
            NSLocale* loc = selectedProduct.priceLocale;
            NSString* curSym=  [loc objectForKey:NSLocaleCurrencySymbol];
            //NSLog(@"selectedProduct.priceLocale =   %@", curSym);
            _completeBlock(YES,[NSString stringWithFormat:@"%@ %@",[selectedProduct.price stringValue],curSym]);
        }
        
    }
    else
    {
        NSLog(@"нет доступных покупок!");
    }
    
}

@end
