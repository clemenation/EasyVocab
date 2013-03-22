//
//  FlashCardCollectionVC.m
//  EasyVocab
//
//  Created by V.Anh Tran on 3/21/13.
//  Copyright (c) 2013 ICT54. All rights reserved.
//

#import "FlashCardCollectionVC.h"
#import "ShowFlashCardLearnModeVC.h"
#import "ChoosePracticeModeVC.h"

@interface FlashCardCollectionVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation FlashCardCollectionVC{
	
	NSString * choosenFlashCard;
	NSArray * iconPath;
	int shellPerPage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	iconPath = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:self.currentCategory];
//	NSLog(@"iconPath=%@",iconPath);
	shellPerPage = 9;
	self.pageControl.numberOfPages = [iconPath count]/shellPerPage;
	self.pageControl.currentPage = 0;
	[self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];

	self.categoryLabel.text = [self.currentCategory capitalizedString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CollectionView datesource and delegate

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return iconPath.count;
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
		imageView.image = [UIImage imageWithContentsOfFile:[iconPath objectAtIndex:indexPath.row]];
	}
	
	if (indexPath.row%shellPerPage==0) {
		self.pageControl.currentPage = indexPath.row/shellPerPage;
	}

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"FlashCard collection selected %@",indexPath);
	choosenFlashCard = [iconPath objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"showFlashCardLearnMode" sender:self];
}


-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
	//this happend when user touch one of the cell but not yet released
	
}

#pragma mark - page control

-(void)pageChanged:(UIPageControl*)sender{
	int row = sender.currentPage * 30;
	[self.iconCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:true];
}

#pragma mark - segue

-(IBAction)returnToFlashCardCollection:(UIStoryboardSegue *)segue {
	NSLog(@"Returned from segue %@ at %@",segue.identifier,segue.sourceViewController);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSLog(@"Perform a segue:%@",segue.identifier);
	//NSLog(@"dest=%@",segue.destinationViewController);
	
	//geting view from container bind to property without create a new view controller
	if ([segue.identifier isEqualToString:@"goToPracticeMode"]) {
		NSLog(@"category=%@",self.currentCategory);
		((ChoosePracticeModeVC*)segue.destinationViewController).currentCategory = self.currentCategory;
	}
	
	if ([segue.identifier isEqualToString:@"showFlashCardLearnMode"]) {
		NSLog(@"Show flashcard:%@",choosenFlashCard);
		ShowFlashCardLearnModeVC * vc= segue.destinationViewController;
		vc.currentCategory=self.currentCategory;
		vc.currentFlashCard=choosenFlashCard;
	}
}

@end
