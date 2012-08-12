//
//  FGTableViewColorCell.h
//  coloraid
//
//  Created by francesco on 8/11/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//  Prototipo della cella della tabella elenco colori

#import <UIKit/UIKit.h>

@interface FGTableViewColorCell : UITableViewCell{


}

//Proprietà gestite
@property (nonatomic) IBOutlet UIImageView *imageCode;
@property (nonatomic) IBOutlet UIView *hsvViewFound;
@property (nonatomic) IBOutlet UILabel *colorName;
@property (nonatomic) IBOutlet UILabel *frequencyValue;


@end
