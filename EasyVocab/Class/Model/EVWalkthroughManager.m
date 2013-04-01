//
//  EVWalkthroughManager.m
//  EasyVocab
//
//  Created by Dung Nguyen on 4/1/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "EVWalkthroughManager.h"

@implementation EVWalkthroughManager

+ (BOOL)hasReadWalkthroughForController:(NSString *)controllerName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *hasReadWalkthroughDict = [userDefaults dictionaryForKey:@"hasReadWalkthrough"];
    return [[hasReadWalkthroughDict valueForKey:controllerName] boolValue];
}

+ (void)setHasReadWalkthrough:(BOOL)hasReadWalkthrough
forController:(NSString *)controllerName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *hasReadWalkthroughDict = [[userDefaults dictionaryForKey:@"hasReadWalkthrough"] mutableCopy];
    if (!hasReadWalkthroughDict)
    {
        hasReadWalkthroughDict = [[NSMutableDictionary alloc] init];
    }
    [hasReadWalkthroughDict setValue:[NSNumber numberWithBool:hasReadWalkthrough] forKey:controllerName];
    [userDefaults setValue:hasReadWalkthroughDict forKey:@"hasReadWalkthrough"];
    [userDefaults synchronize];
}

+ (void)resetWalkthrough
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:@"hasReadWalkthrough"];
}

@end
