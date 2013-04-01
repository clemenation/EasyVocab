//
//  EVWalkthroughManager.h
//  EasyVocab
//
//  Created by Dung Nguyen on 4/1/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVWalkthroughManager : NSObject

+ (BOOL)hasReadWalkthroughForController:(NSString *)controllerName;
+ (void)setHasReadWalkthrough:(BOOL)hasReadWalkthrough
                forController:(NSString *)controllerName;
+ (void)resetWalkthrough;

@end
