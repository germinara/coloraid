//
//  FGTableColorsDelegate.m
//  coloraid
//
//  Created by francesco on 8/11/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//


#import "FGTableColorsDelegate.h"
#import "FGHSV.h"
#import "FGTableViewColorCell.h"
#import "FGColorDetailViewController.h"


@implementation FGTableColorsDelegate
@synthesize tableViewColors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
  // Custom initialization
 }
 return self;
}

- (void)didReceiveMemoryWarning
{
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (void)viewDidLoad {
  [super viewDidLoad];
  theAppDelegate =[[UIApplication sharedApplication] delegate];
}


- (void)viewDidUnload
{
 [super viewDidUnload];
 // Release any retained subviews of the main view.
 // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Table View Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 FGTableViewColorCell *cell = (FGTableViewColorCell *) [tableView
                          dequeueReusableCellWithIdentifier:@"colorCellInfo"];
 

 
 FGHSV *fgHSV = [theAppDelegate.colorLookUpTable objectAtIndex:indexPath.row];
 
 cell.colorName.text =fgHSV.name;
 cell.frequencyValue.text =[NSString stringWithFormat:@"Hz. %.3f",fgHSV.frequency];
 cell.imageCode.image =fgHSV.image;
 UIColor *tmpColor =[UIColor colorWithHue:fgHSV.h saturation:fgHSV.s brightness:fgHSV.v alpha:1.0];
 cell.hsvViewFound.backgroundColor =tmpColor;
                                    
 return cell;
}


//Visualizzo dettaglio colore selezionato
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 FGColorDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"colorDetail"];

 FGHSV *fgHSV = [theAppDelegate.colorLookUpTable objectAtIndex:indexPath.row];
 detail.title=fgHSV.name;
 
 self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"TITLEDETAIL", nil)  style:UIBarButtonItemStylePlain target:nil action:nil];
 
 detail.controller=self;
 detail.fgHSV=fgHSV;
 [self.navigationController pushViewController:detail animated:YES];
 
}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
	}

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
 // Disabilito DELETE swipe se non sono in modo editing
 if (self.editing) {
  return UITableViewCellEditingStyleDelete;
 }
 return UITableViewCellEditingStyleNone;
}



//Table View Datasource

//Delegati e Datasource della tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 int nRecords=0;
 nRecords = [theAppDelegate.colorLookUpTable count];
 return nRecords;
}


-(void) reloadData{
 [tableViewColors reloadData];
}



@end
