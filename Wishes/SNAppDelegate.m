//
//  SNAppDelegate.m
//  Wishes
//
//  Created by Alexander Senin on 05.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNAppDelegate.h"
#import "SNWishViewController.h"
#import "SNTableViewController.h"

@implementation SNAppDelegate {
    SNOneWish* _findedWish;
    
    //флаг, который показывает в программе ли мы на данный момент
    //когда заходим в программу, устанавливаем в YES, когда выходим в фон в NO
    BOOL _weAreInProgramm; 
}




-(void) clearNotificationCenter {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[SNWishes sharedWishes] updateAllNotifications];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //fullversion testing
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.Sstudio.Wishes.FullVersion"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    //выставляем цвета

    
    [self clearNotificationCenter];
    _weAreInProgramm=YES;
    
    
    
    //проверяем, попадаем ли мы в приложение
    //кликая по локальному уведомлению
    UILocalNotification* localNotificatons = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];

    if (localNotificatons!=nil) {
        NSNumber* idNote = [localNotificatons.userInfo objectForKey:@"ID"];
        _findedWish = [[SNWishes sharedWishes] returnWishById:idNote];
        if (_findedWish) {
            UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            SNWishViewController *pvc = [navVc.storyboard instantiateViewControllerWithIdentifier:@"WishViewController"];
            pvc.currentWish = _findedWish;
            [navVc pushViewController:pvc animated:YES];
        }
    }
    
    // None of the code should even be compiled unless the Base SDK is iOS 8.0 or later
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    // The following line must only run under iOS 8. This runtime check prevents
    // it from running if it doesn't exist (such as running under iOS 7 or earlier).
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    return YES;
}


//получили локальное уведомление, когда находимся в программе
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //NSLog(@"didReceiveLocalNotification");
    NSDictionary* dict = [notification userInfo];
    _findedWish = [[SNWishes sharedWishes] returnWishById:[dict objectForKey:@"ID"]];

    
    if (_weAreInProgramm) {
        //мы в программе показываем уведомление, и переходим по нему если пользователь нажал показать
        if (_findedWish) {
            NSNumber *idOpenWish = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWish"];
            if (idOpenWish==nil) idOpenWish=@-1;
            
            //если мы в этом пожелании
            if ([_findedWish.idWish isEqualToNumber:idOpenWish])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:loc_str(@"Wish") message:[_findedWish title] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:loc_str(@"Wish") message:[_findedWish title] delegate:self cancelButtonTitle:loc_str(@"Cancel") otherButtonTitles:loc_str(@"Show"),nil];
                [alert show];
                
            }
        }
    } else {
        //если программа в фоне, то 
        //просто открываем пожелание, очищая уведомления
        //если сейчас открыто не это пожелание
        NSNumber *idOpenWish = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWish"];
        if (idOpenWish==nil) idOpenWish=@-1;

        if (![_findedWish.idWish isEqualToNumber:idOpenWish ]) {
            [self clearNotificationCenter];
            UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            SNWishViewController *pvc = [navVc.storyboard instantiateViewControllerWithIdentifier:@"WishViewController"];
            pvc.currentWish = _findedWish;
            [navVc pushViewController:pvc animated:YES];
        }
    }
}

//делегат для алерт вью, вызывается когда кликнули на кнопку
//тут делаем переход на пожелание
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        //переходим на пожелание
        //определить заметку, очищая центр уведомлений
        [self clearNotificationCenter];
        UINavigationController *navVc=(UINavigationController *) self.window.rootViewController;
            SNWishViewController *pvc = [navVc.storyboard instantiateViewControllerWithIdentifier:@"WishViewController"];
            pvc.currentWish = _findedWish;
            [navVc pushViewController:pvc animated:YES];
    }
}

//регистрация успешная
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //на этот девайс токен будут отправляться уведомления
    //его надо отдать на сервер, и там сохранить, потом юзать, при отправке сообщений
    //NSLog(@"deviceToken=%@",deviceToken);
    
    //[PFPush storeDeviceToken:deviceToken];
    //[PFPush subscribeToChannelInBackground:@""];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}


//регистрация не успешная
-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration. Error: %@",error);
}


//метод вызывается когда уведомление полученно в приложении
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NSLog(@"didReceiveRemoteNotification");
    [PFPush handlePush:userInfo];
    
/*    NSMutableDictionary* test = [userInfo objectForKey:@"aps"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"message" message:[test objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
*/
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    //NSLog(@"applicationWillResignActive");


    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //NSLog(@"applicationDidEnterBackground");

    _weAreInProgramm=NO;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //NSLog(@"applicationWillEnterForeground");

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //NSLog(@"applicationWillEnterForeground");
    
    //бэйджи обнулили
    [self clearNotificationCenter];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    _weAreInProgramm=YES;
    //NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
