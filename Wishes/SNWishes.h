//
//  SNWishes.h
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNOneWish;

@interface SNWishes : NSObject

//массив всех напоминаний состоит из SNOneWish
@property NSMutableArray* allWishes;
-(void) sortWishesByDateUpadate;


+(SNWishes*) sharedWishes;

-(void) loadWishFromFile;
-(void) saveWishesToFile;


-(SNOneWish*) addWish;
-(void) deleteWish:(SNOneWish*) wish;
-(SNOneWish*)returnWishById:(NSNumber*)idW;


-(void) updateAllNotifications;

@end
