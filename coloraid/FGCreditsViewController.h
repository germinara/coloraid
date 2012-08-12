//
//  FGCreditsViewController.h
//  coloraid
//
//  Created by francesco on 8/12/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//  Visualizza info sui crediti, testo con scorrimento verticale

#import <UIKit/UIKit.h>

@interface FGCreditsViewController : UIViewController{

 NSTimer * scrollTimer; //Timer
 NSDate* startTime; //Timestamp partenza
 CGPoint destinationOffset; //Destinazione termine scorrimento offset scrollview
 CGPoint startOffset; //Valore inziale offset scrollview
 }

@property(strong,nonatomic) IBOutlet UIScrollView* scrollView;
@property(strong,nonatomic)  NSDate* startTime;
@property(strong,nonatomic)  NSTimer* scrollTimer;


@end
