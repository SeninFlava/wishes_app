//
//  SNOneWish.h
//  Wishes
//
//  Created by Alexander Senin on 06.09.13.
//  Copyright (c) 2013 Alexander Senin. All rights reserved.
//

//-Идентификатор(уникальный номер пожелания)
//-Заголовок
//-Текст
//-Время старта
//-Повторение
//-Звук
//-Статус(активно-не активно) по нему соответственно создаем локальные уведомления, методами в этом классе
//
//Методы:
//-создать локальное уведомление(по идентификатору текущему)
//-удалить локальное уведомление(по идентификатору текущему)


#import <Foundation/Foundation.h>

@interface SNOneWish : NSObject

@property NSNumber* idWish;
@property NSString* title;
@property NSString* text;

@property NSDate* dateStart;
@property NSString* repeatMode;
@property NSMutableArray* schedule; //массив NSDate - даты запусков

@property NSString* soundName;
@property NSString* status;

-(void) createLocalNotification;
-(void) deleteLocalNotification;

-(void) updateLocalNotification;

@end
