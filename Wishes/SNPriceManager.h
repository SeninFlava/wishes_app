//
//  SNPriceManager.h
//  SecurityNotes
//
//  Created by Alexander Senin on 11.10.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


typedef void(^SNGetPriceCompleteBlock)(BOOL isSuccess, NSString* price);


@interface SNPriceManager : NSObject <SKProductsRequestDelegate> {
    SNGetPriceCompleteBlock _completeBlock;
}

//делаем синглтон
+(SNPriceManager*) sharedManager;

-(void) getPricePaymentId:(NSString*)paymentId withCompletionBlock:(SNGetPriceCompleteBlock)block;


@end
