//
//  AnswerFlashCardChallengeMode.h
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerFlashCardChallengeMode : UIViewController<UITextFieldDelegate>

@property(weak,nonatomic) NSString * currentFlashCard;
@property(strong,nonatomic) NSString * correctAnswer;

@end
