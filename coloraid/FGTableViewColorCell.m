//
//  FGTableViewColorCell.m
//  coloraid
//
//  Created by francesco on 8/11/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//

#import "FGTableViewColorCell.h"

@implementation FGTableViewColorCell


@synthesize imageCode,hsvViewFound,colorName,frequencyValue;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];




}

@end
