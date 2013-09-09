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

+(SNWishes*) sharedWishes;

-(void) loadWishFromFile;
-(void) saveWishesToFile;


-(void) addWish:(SNOneWish*) wish;
-(void) updateWish:(SNOneWish*)oldWish withWish:(SNOneWish*)newWish;
-(void) changeStatus:(SNOneWish*)wish newStatus:(NSString*)newStatus;
-(void) deleteWish:(SNOneWish*) wish;


@end
