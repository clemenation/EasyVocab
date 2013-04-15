//
//  ReviewFlashCardLearnModeVC.h
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewFlashCardLearnModeVC : UIViewController

@property(weak,nonatomic) NSString * currentCategory;
@property(assign, nonatomic) int currentFlashcardID;

@property(weak,nonatomic) NSString * correctAnswer;

@end
