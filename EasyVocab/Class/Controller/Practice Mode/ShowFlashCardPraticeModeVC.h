//
//  ShowFlashCardPraticeModeVC.h
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowFlashCardPraticeModeVC : UIViewController

@property(weak,nonatomic) NSString * currentCategory;
@property(nonatomic) int currentFlashCardID;
@property(strong,nonatomic) NSString * currentFlashCard;

@property(nonatomic) int currentPraticeMode;

-(IBAction)returnToShowFlashCardPraticeMode:(UIStoryboardSegue *)segue;

@end