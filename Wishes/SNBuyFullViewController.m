//
//  SNBuyFullViewController.m
//  Wishes
//
//  Created by Alexander Senin on 12.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNBuyFullViewController.h"

@interface SNBuyFullViewController ()
{
    SKProduct *_product;
}

@end

@implementation SNBuyFullViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //заблокировали кнопку пока не получили список покупок
    self.buyButton.enabled = NO;
    [self.buyButton setTitle:@"Запрос..." forState:UIControlStateDisabled];

    
    if ([SKPaymentQueue canMakePayments]) {
        //NSLog(@"Все хорошо, можем покупать.");
        //делаем запрос
        SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.Sstudio.Wishes.FullVersion"]];
        productRequest.delegate = self;
        [productRequest start];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Вы не можете делать покупки" message:@"Разрешите делать покупки в настройках" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//запрос на продукт
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    int count = [response.products count];
    
    if (count>0) {
        //если получили продукт, то присвоили его внутренней переменной, и разблокировали кнопку
        self.buyButton.enabled = YES;
        [self.buyButton setTitle:@"Приобрести за 99 центов." forState:UIControlStateNormal];
        
        _product = [response.products objectAtIndex:0];
        //можем вывести данные о продукте
        //_product.localizedTitle
        //_product.localizedDescription
        
    } else {
        //если не получили продукт, то заблокировали кнопку и вывели ошибку
        self.buyButton.enabled = NO;
        [self.buyButton setTitle:@"Покупка недоступна" forState:UIControlStateDisabled];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Нет доступных покупок" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


//нажали купить
- (IBAction)pushBuyAction:(id)sender {
    
    //SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.Sstudio.Wishes.FullVersion"];
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];

    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStatePurchased:
                [userDef setObject:@"YES" forKey:@"FullVersion"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [userDef setObject:@"YES" forKey:@"FullVersion"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                if (transaction.error.code!=SKErrorPaymentCancelled) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[NSString stringWithFormat:@"Code=%i",transaction.error.code] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;

            default:
                break;
        }
    }
}

@end
