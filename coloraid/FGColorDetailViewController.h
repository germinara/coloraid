//
//  FGColorDetailViewController.h
//  coloraid
//
//  Created by francesco on 8/11/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//  Dettaglio info colore selezionato

#import <UIKit/UIKit.h>
#import "FGTableColorsDelegate.h"
#import "FGHSV.h"

@interface FGColorDetailViewController : UIViewController{

 FGTableColorsDelegate *controller; //Parent
 FGHSV* fgHSV; //Colore selezionato
}

@property (strong, nonatomic) IBOutlet FGTableColorsDelegate *controller;

//Proprietà gestite
@property (strong,nonatomic) IBOutlet UITextField *colorName;
@property (strong,nonatomic) IBOutlet UITextField *freqValue;
@property (strong,nonatomic) IBOutlet UIImageView *codeImage;
@property (nonatomic) FGHSV* fgHSV;

//Modifica della frequenza (predisposizione)
-(IBAction)updateFrequency:(id)sender;


@end
