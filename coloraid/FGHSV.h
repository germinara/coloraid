//
//  FGHSV.h
//  coloraid
//
//  Created by francesco on 8/1/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//  Base Object to manage Color components (HSV) and Sound Frequency and Image equivalents

#import <Foundation/Foundation.h>

@interface FGHSV : NSObject{
 float h;   //Hue component
 float s;   //Saturation Component
 float v;   //Valure Component
 float alpha; //Alpha Component -> Always 1.0
 
 double frequency; //Corresponding frequency
 UIImage *image;   //Corresponding image
 
 NSString *name; //Color name
 
}

//Properties
@property float h;
@property float s;
@property float v;
@property double frequency;
@property UIImage *image;
@property NSString *name;

//Initializers
-(id)initWithColor:(UIColor*) aColor frequencyEq:(double) freq imageEq:(UIImage*) imageEQ withName:(NSString*) colorName;
-(id)initWithStringColor:(NSString*) hexColor frequencyEq:(double) freq imageEq:(UIImage*) imageEQ withName:(NSString*) colorName;

//internal methods
-(double) colorDistanceforHSVColorHue:(float) h saturation:(float)s value:(float)v;

//Set new color,frequency and image values
-(void)setWithColor:(UIColor*) aColor frequencyEq:(double) freq imageEq:(UIImage*) imageEQ withName:(NSString*) colorName;

@end
