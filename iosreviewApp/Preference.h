//
//  Perference.h
//  freecket
//
//  Created by suju on 12/03/15.
//  Copyright (c) 2015 wuguang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Preference : NSObject

+(Preference*) getInstance;
-(void) putSharedPreference:(id) context :(NSString*) key  :(NSString*) value;
-(void) putSharedPreference:(id) context :(NSString*) key  WithBOOL:(BOOL) value;
-(void) putSharedPreference:(id) context :(NSString*) key  WithINT:(int) value;
-(void) putSharedPreference:(id) context :(NSString*) key  WithArray:(NSMutableArray*) value;
-(NSString*) getSharedPreference:(id) context  :(NSString*) key  :(NSString*) defaultValue;
-(int) getSharedPreference:(id) context  :(NSString*) key  WithINT:(int) defaultValue ;
-(BOOL) getSharedPreference:(id) context  :(NSString*) key  WithBOOL:(BOOL) defaultValue ;
-(NSMutableArray*)getSharedPreference:(id) context :(NSString*) key  WithArray:(NSArray*) defaultValue;

-(void) removeSharedPreference;
-(void) settedLogin:(BOOL) bLogin;
-(BOOL) getLogin;

@end
