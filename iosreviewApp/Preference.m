//
//  Perference.m
//  freecket
//
//  Created by suju on 12/03/15.
//  Copyright (c) 2015 wuguang. All rights reserved.
//

#import "Preference.h"

static Preference *mInstance;
static BOOL login;

@implementation Preference

+(Preference*) getInstance {
    if (nil == mInstance) {
        mInstance = [[Preference alloc] init];
    }
    return mInstance;
}

-(void) putSharedPreference:(id) context :(NSString*) key  :(NSString*) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
}

-(void) putSharedPreference:(id) context :(NSString*) key  WithArray:(NSArray*) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}

-(void) putSharedPreference:(id) context :(NSString*) key  WithBOOL:(BOOL) value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(YES == value) {
        [defaults setObject:@"YES" forKey:key];
    }
    else {
        [defaults setObject:@"NO" forKey:key];
    }
    
}

-(void) putSharedPreference:(id) context :(NSString*) key  WithINT:(int) value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", value] forKey:key];
}

-(NSString*) getSharedPreference:(id) context  :(NSString*) key  :(NSString*) defaultValue {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:key];
    
    if(nil  == str) {
        return defaultValue;
    }
    
    return str;
}

-(int) getSharedPreference:(id) context  :(NSString*) key  WithINT:(int) defaultValue  {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:key];
    
    if(nil  == str) {
        return defaultValue;
    }
    
    return [str intValue];
}

-(BOOL) getSharedPreference:(id) context  :(NSString*) key  WithBOOL:(BOOL) defaultValue  {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:key];
    
    if(nil  == str) {
        return defaultValue;
    }
    
    if([str isEqualToString:@"YES"] == YES) {
        return YES;
    }
    
    return NO;
}
-(NSMutableArray*)getSharedPreference:(id) context :(NSString*) key  WithArray:(NSMutableArray*) defaultValue{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    NSMutableArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    if(nil  == myArray) {
        return defaultValue;
    }
    return myArray;
}
-(void)removeSharedPreference
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
-(void) settedLogin:(BOOL) bLogin
{
    login = bLogin;
}
-(BOOL) getLogin
{
    return login;
}
@end
