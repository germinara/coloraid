//
//  FGTableColorsDelegate.h
//  coloraid
//
//  Created by francesco on 8/11/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//  Tabella elenco dei colori supportati nella codifica ColorADD

#import <Foundation/Foundation.h>
#import "FGAppDelegate.h"

@interface FGTableColorsDelegate : UIViewController <UITableViewDataSource,UITableViewDelegate>{
 
 FGAppDelegate* theAppDelegate; //Delegato Applicazione
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewColors;

@end
