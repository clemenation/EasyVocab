//
//  EVShowFlashcardViewController.h
//  EasyVocab
//
//  Created by Dung Nguyen on 5/2/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVFlashcardView.h"
#import "EVFlashcardCollection.h"
#import "EVViewFlipper.h"

@interface EVFlashcardViewController : UIViewController <EVFlashcardViewDelegate>

@property (weak,nonatomic) NSString                 *currentCategory;
@property (assign, nonatomic) NSUInteger            currentFlashCardID;
@property (assign, nonatomic) EVFlashcardViewType   flashcardViewType;
@property (assign, nonatomic) BOOL flipOnce;
@property (readonly, nonatomic) EVFlashcardCollection *flashcardCollection;
@property (readonly, nonatomic) NSMutableArray      *flashcardViews;
@property (readonly, nonatomic) EVViewFlipper       *viewFlipper;

- (void)loadFlashcardsContent;
- (IBAction)flashcardSelected:(UITapGestureRecognizer *)sender;
- (void)goToNextCard:(id)sender
  animationsAddition:(void (^)(void))animations
  completionAddition:(void (^)(BOOL finished))completion;
- (IBAction)nextButtonSelected:(UIButton *)sender;
- (IBAction)prevButtonSelected:(UIButton *)sender;

@end
