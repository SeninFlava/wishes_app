//
//  SNWishes.m
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

#import "SNWishes.h"
#import "SNOneWish.h"

static SNWishes* __shared;

@implementation SNWishes

+(SNWishes*) sharedWishes
{
    if (!__shared)
    {
        __shared=[SNWishes new];
        
        [__shared loadWishFromFile];
    }
    
    return __shared;
}

-(NSDictionary*) createDictionaryFromWish:(SNOneWish*)wish
{

    if (!wish.idWish) wish.idWish=@0;
    if (!wish.title) wish.title=@"";
    if (!wish.text) wish.text=@"";
    if (!wish.dateCreate) wish.dateCreate=[NSDate new];
    if (!wish.dateUpdate) wish.dateUpdate = [NSDate new];
//    if (!wish.repeatMode) wish.repeatMode=@"";
    if (!wish.schedule) wish.schedule=[NSArray array];
    if (!wish.soundName) wish.soundName=@"";
    if (!wish.status) wish.status=@"";
    
    
    NSArray* objects = [NSArray arrayWithObjects:wish.idWish,wish.title,wish.text,wish.dateCreate,wish.dateUpdate,/*wish.repeatMode,*/wish.schedule, wish.soundName,wish.status, nil];
    NSArray* keys = [NSArray arrayWithObjects:@"idWish",@"title",@"text",@"dateCreate",@"dateUpdate",/*@"repeatMode",*/@"schedule",@"soundName",@"status", nil];
    NSDictionary* returnDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    return returnDict;
}

-(SNOneWish*) createOneWishFromDictionary:(NSDictionary*)dictionary
{
    SNOneWish* returnWish = [SNOneWish new];
    
    returnWish.idWish = [dictionary objectForKey:@"idWish"];
    returnWish.title = [dictionary objectForKey:@"title"];
    returnWish.text = [dictionary objectForKey:@"text"];
    returnWish.dateCreate = [dictionary objectForKey:@"dateCreate"];
    returnWish.dateUpdate = [dictionary objectForKey:@"dateUpdate"];
    //returnWish.repeatMode = [dictionary objectForKey:@"repeatMode"];
    returnWish.schedule = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"schedule"]];
    returnWish.soundName = [dictionary objectForKey:@"soundName"];
    returnWish.status = [dictionary objectForKey:@"status"];
    
    return returnWish;
}

-(void) saveWishesToFile
{
    NSMutableArray* arrayForSave = [NSMutableArray array];
    for (SNOneWish* item in self.allWishes)
    {
        NSDictionary* dict = [self createDictionaryFromWish:item];
        [arrayForSave addObject:dict];
    }
    
    NSString* pathtoFileInLibrary = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.xml"];
    
    [arrayForSave writeToFile:pathtoFileInLibrary atomically:YES];
}

-(void) loadWishFromFile
{
    self.allWishes = [NSMutableArray array];
    
    NSString* pathtoFileInLibrary = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.xml"];

    //проверяем наличие фала
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathtoFileInLibrary])
    {
        //файла нет
        //ну нет и нет
    }
    else
    {
        //файл есть!
        NSArray* loadingArray = [NSArray arrayWithContentsOfFile:pathtoFileInLibrary];
    
        for (NSDictionary* item in loadingArray)
        {
            [self.allWishes addObject:[self createOneWishFromDictionary:item]];
        }
    }
}

//получить новый айди
-(NSNumber*) getNewId
{
    NSUInteger maxId=0;
    for (SNOneWish* item in self.allWishes)
    {
        //NSLog(@"item.idWish.integerValue=%i",item.idWish.integerValue);
        if (item.idWish.integerValue>maxId) maxId=item.idWish.integerValue;
    }
    
    //NSLog(@"maxId=%i",maxId);
    
    return [NSNumber numberWithInteger:maxId+1];
}

//добавить пожелание
-(SNOneWish *) addWish
{
    SNOneWish* wish = [SNOneWish new];
    
    wish.idWish = [self getNewId];
    wish.status = @"NO";
    wish.dateCreate = [NSDate new];
    wish.dateUpdate = [NSDate new];
    wish.soundName = nil;
    wish.schedule = [NSMutableArray new];
    
    NSArray* arr = @[wish];
    self.allWishes =[NSMutableArray arrayWithArray:[arr arrayByAddingObjectsFromArray:self.allWishes]];
    
//    [self.allWishes addObject:wish];
    [self saveWishesToFile];
    
    return wish;
}




//удалить пожелание
-(void) deleteWish:(SNOneWish *)wish
{
    NSUInteger indexOfDel=-1;
    for (SNOneWish* item in self.allWishes)
    {
        if (item.idWish.integerValue==wish.idWish.integerValue)
        {
            indexOfDel=[self.allWishes indexOfObject:item];
            [item deleteLocalNotification];
        }
    }
    
    if (indexOfDel!=-1)
    {
        [self.allWishes removeObjectAtIndex:indexOfDel];
    }
    
    [self saveWishesToFile];
}



@end
