//
//  NSBundle+Language.h
//  ios_language_manager
//
//  Created by Maxim Bilan on 1/10/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"
#ifdef USE_ON_FLY_LOCALIZATION

@interface NSBundle (Language)

+ (void)setLanguages:(NSString *)language;

@end

#endif
