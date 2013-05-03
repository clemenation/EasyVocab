//
//  FlashCardCollectionVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "FlashCardCollectionVC.h"
#import "ShowFlashCardLearnModeVC.h"
#import "EVFlashcardCollection.h"
#import "EVWalkthroughManager.h"


@interface FlashCardCollectionVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;
@property (weak, nonatomic) IBOutlet UIButton *walkthroughButton;

@property (strong, nonatomic) EVFlashcardCollection *flashcardCollection;

@end

@implementation FlashCardCollectionVC{
	int shellPerPage;
	int chosenFlashCardID;
}

@synthesize flashcardCollection = _flashcardCollection;

- (void)setCurrentCategory:(NSString *)currentCategory
{
    if (_currentCategory != currentCategory)
    {
        _currentCategory = currentCategory;
        self.flashcardCollection.category = _currentCategory;
    }
}

- (EVFlashcardCollection *)flashcardCollection
{
    if (!_flashcardCollection)
    {
        _flashcardCollection = [[EVFlashcardCollection alloc] initWithCategory:self.currentCategory];
    }
    return _flashcardCollection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.categoryLabel.font = [UIFont fontWithName:@"UVNVan" size:30];
	
//	NSLog(@"iconPath=%@",iconPath);
	shellPerPage = 9;
    int flashcardCount = self.flashcardCollection.count;
	self.pageControl.numberOfPages = flashcardCount/shellPerPage;
	if (flashcardCount%shellPerPage!=0)self.pageControl.numberOfPages ++;
	
	self.pageControl.currentPage = 0;
	[self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];

	self.categoryLabel.text = [self.currentCategory capitalizedString];
	
	NSString * path =[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"category_icon_%@",self.currentCategory] ofType:@"png"];
    UIImage *catImg = [UIImage imageWithContentsOfFile:path];
    self.categoryIcon.frame = CGRectMake(self.categoryIcon.frame.origin.x, self.categoryIcon.frame.origin.y, catImg.size.width, catImg.size.height);
	self.categoryIcon.image = [UIImage imageWithContentsOfFile:path];
    
    self.iconCollectionView.backgroundColor = [UIColor clearColor];
    
    // Enable/disable walkthrough button
    self.walkthroughButton.hidden = [EVWalkthroughManager hasReadWalkthroughForController:NSStringFromClass(self.class)];

}


#pragma mark - CollectionView datesource and delegate

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.flashcardCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
	static NSString *FlashCardShellIdent = @"FlashCardSmallCell";
	
	NSString * CellIdentifier = FlashCardShellIdent;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if ([CellIdentifier isEqualToString:FlashCardShellIdent]) {
		UIImageView * imageView = (UIImageView*)[cell viewWithTag:1];
		//imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wifi" ofType:@"png" inDirectory:@"iconbeast"]];
		imageView.image = [self.flashcardCollection flashcardAtIndex:indexPath.row].image;
	}
	
	if (indexPath.row%shellPerPage==0) {
		self.pageControl.currentPage = indexPath.row/shellPerPage;
	}

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"FlashCard collection selected %@",indexPath);
	chosenFlashCardID = indexPath.row;
	[self performSegueWithIdentifier:@"showFlashCardLearnMode" sender:self];
}


-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
	//this happend when user touch one of the cell but not yet released
	
}

#pragma mark - page control

-(void)pageChanged:(UIPageControl*)sender{
	int row = sender.currentPage * shellPerPage;
	[self.iconCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
}

#pragma mark - Buttons fake Tabbar

- (IBAction)switchToPratice:(id)sender {
	[self.tabBarController setSelectedIndex:1];
}

#pragma mark - segue

-(IBAction)returnToFlashCardCollection:(UIStoryboardSegue *)segue {
	NSLog(@"Returned from segue %@ at %@",segue.identifier,segue.sourceViewController);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	if ([segue.identifier isEqualToString:@"showFlashCardLearnMode"]) {
		ShowFlashCardLearnModeVC * vc= segue.destinationViewController;
		vc.currentCategory=self.currentCategory;
		vc.currentFlashCardID=chosenFlashCardID;
	}
}

#pragma mark - Target/action

- (IBAction)walkthroughSelected:(UIButton *)sender {
    sender.hidden = YES;
    [EVWalkthroughManager setHasReadWalkthrough:YES forController:NSStringFromClass(self.class)];
}


@end
