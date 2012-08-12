//
//  FGAppDelegate.h
//  coloraid
//
//  Created by francesco on 7/31/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//  Delegato Applicazione 

#import <UIKit/UIKit.h>

@interface FGAppDelegate : UIResponder <UIApplicationDelegate>{

 NSMutableArray *colorLookUpTable; //Tabella dei colori supportati

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSMutableArray *colorLookUpTable;

-(void) fillColorTable; //Riempie la tabella (staticamente da programma, in un futuro da DB)

@end
