//
//  EVGoogleTranslateTTS.h
//  EasyVocab
//
//  Created by Dung Nguyen on 3/31/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVGoogleTranslateTTS : NSObject

- (id)initWithLanguage:(NSString *)language;
- (id)initWithLanguage:(NSString *)language andContent:(NSString *)content;
- (void)startSynchronous;
- (void)startAsynchronous;

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *language;

@end
