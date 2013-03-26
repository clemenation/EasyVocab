//
//  FlashCardCollectionVC.h
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashCardCollectionVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(weak,nonatomic) NSString * currentCategory;

-(IBAction)returnToFlashCardCollection:(UIStoryboardSegue *)segue ;

@end
