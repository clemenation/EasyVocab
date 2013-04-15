//
//  AnswerFlashCardEasyModeVC.h
//  EasyVocab
//
//  Created by V.Anh Tran on 3/22/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerFlashCardEasyModeVC : UIViewController

@property(weak,nonatomic) NSString * currentFlashCard;
@property(strong,nonatomic) NSString * correctAnswer;
@property(strong,nonatomic) NSArray * fakeAnswer;

@end
