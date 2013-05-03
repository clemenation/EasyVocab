//
//  EVShowFlashcardViewController.h
//  EasyVocab
//
//  Created by Dung Nguyen on 5/2/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVFlashcardView.h"

@interface EVFlashcardViewController : UIViewController

@property (weak,nonatomic) NSString                 *currentCategory;
@property (assign, nonatomic) NSUInteger            currentFlashCardID;
@property (assign, nonatomic) EVFlashcardViewType   flashcardViewType;

@end
