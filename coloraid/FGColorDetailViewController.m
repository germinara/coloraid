//
//  FGColorDetailViewController.m
//  coloraid
//
//  Created by francesco on 8/11/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//

#import "FGColorDetailViewController.h"


@interface FGColorDetailViewController ()

@end

@implementation FGColorDetailViewController

@synthesize controller,colorName,freqValue,codeImage,fgHSV;


-(IBAction)updateFrequency:(id)sender{
 UISlider * sld = (UISlider*) sender;
 freqValue.text=[NSString stringWithFormat:@"%.3f",sld.value];
}



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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
 [super viewDidLoad];
 
 //Aggiorno interfaccia utente con i dati del colore selezionato
 
 colorName.text = fgHSV.name;
 codeImage.image = fgHSV.image;
 freqValue.text = [NSString stringWithFormat:@"%.3f",fgHSV.frequency];


  
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


@end
