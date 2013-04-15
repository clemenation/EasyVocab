//
//  ChoosePracticeModeVC.h
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePracticeModeVC : UIViewController

@property(weak,nonatomic) NSString * currentCategory;

-(IBAction)returnToChoosePraticeMode:(UIStoryboardSegue *)segue;

@end
