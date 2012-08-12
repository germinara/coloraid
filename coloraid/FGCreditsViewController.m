//
//  FGCreditsViewController.m
//  coloraid
//
//  Created by francesco on 8/12/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//

#import "FGCreditsViewController.h"

@interface FGCreditsViewController ()

@end

@implementation FGCreditsViewController

@synthesize scrollView,startTime,scrollTimer;

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

    //Imposto dimensione della scrollview che contiene i dati da visualizzare
    self.scrollView.contentSize=CGSizeMake(320.0, 900.0);
    [self doAnimatedScrollTo:CGPointMake(0.0,624)]; //Inizio scorrimento
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
 
    [scrollTimer invalidate];
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Effettua lo scroll
- (void) animateScroll:(NSTimer *)timerParam
{
 const NSTimeInterval duration = 10; //Determina la velocità di scorrimento
 
 NSTimeInterval timeRunning = -[startTime timeIntervalSinceNow];
 
 if (timeRunning >= duration) //Fine scorrimento
 {
  [self.scrollView setContentOffset:destinationOffset animated:YES];
  [scrollTimer invalidate];
  scrollTimer = nil;
  return;
 }
 
	CGPoint offset = [scrollView contentOffset];
	offset.y = startOffset.y + (destinationOffset.y - startOffset.y) * timeRunning / duration; //Nuova posizione offset
	[scrollView setContentOffset:offset animated:YES];
}


//Inizio lo scorrimento
- (void) doAnimatedScrollTo:(CGPoint)offset
{
 self.startTime = [NSDate date]; //Timestamp partenza
 startOffset = scrollView.contentOffset; //Valore iniziale offset scrollview
 destinationOffset = offset; //Destinazione finale offset scrollview
 
 if (!scrollTimer) //Se tiimer non è attivo, lo crea
 {
  self.scrollTimer =
		[NSTimer scheduledTimerWithTimeInterval:0.01
                                   target:self
                                 selector:@selector(animateScroll:)
                                 userInfo:nil
                                  repeats:YES];
 }
}

@end
