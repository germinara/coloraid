//
//  FGHSV.m
//  coloraid
//
//  Created by francesco on 8/1/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//

#import "FGHSV.h"
#include <math.h>


@implementation FGHSV

@synthesize h,s,v;
@synthesize frequency,image;
@synthesize name;

//Get Color component from HTML Color
extern void SKScanHexColor(NSString * hexString, float * red, float * green, float * blue, float * alpha);


//Default initializer
- (id)init
{
 self = [super init];
 if (self) {
  h=0.0;
  s=0.0;
  v=0.0;
  frequency=0.0;
  image=nil;
  name = @"";
 }
 return self;
}

//Initializer
-(id)initWithColor:(UIColor*) aColor frequencyEq:(double) freq imageEq:(UIImage*) imageEQ withName:(NSString*) colorName{
 self = [super init];
 if (self) {
  [aColor getHue:&h saturation:&s brightness:&v alpha:&alpha];
  frequency = freq;
  image = imageEQ;
  name = [NSString stringWithString:colorName];
 }
 return self;
} 

//Initializer
-(id)initWithStringColor:(NSString*) hexColor frequencyEq:(double) freq imageEq:(UIImage*) imageEQ withName:(NSString*) colorName{
 self = [super init];
 if (self) {
  float red=0.0;
  float green=0.0;
  float blue=0.0;
  float alpha_v=0.0;
  SKScanHexColor(hexColor, &red, &green, &blue, &alpha_v);
  UIColor *aColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha_v];
  [aColor getHue:&h saturation:&s brightness:&v alpha:&alpha];
  frequency = freq;
  image = imageEQ;
  name = [NSString stringWithString:colorName];
 }
 return self;
}


//Set color components, frequency and image
-(void)setWithColor:(UIColor*) aColor frequencyEq:(double) freq imageEq:(UIImage*) imageEQ withName:(NSString*) colorName{
  [aColor getHue:&h saturation:&s brightness:&v alpha:&alpha];
  frequency = freq;
  image = imageEQ;
  name = [NSString stringWithString:colorName];
}


//Return object description used by debugger
-(NSString*) description{
 return [NSString stringWithFormat:@"h: %.f s:%f s:%f frequency: %.3f",h,s,v,frequency];
} 

//Calculate distance from two colors
-(double) colorDistanceforHSVColorHue:(float) clr_h saturation:(float)clr_s value:(float)clr_v{
 double result =0.0;
 
 result = pow(v - clr_v, 2) + pow(s*cos(h) - clr_s*cos(clr_h), 2) + pow(s*sin(h) - clr_s*sin(clr_h), 2); 

 /* From Tommy Szalapski 
    http://www.experts-exchange.com/Programming/Algorithms/Q_27381845.html
  
  distance[i] = pow(array[i].v - color.v, 2)
  + pow(array[i].s*cos(array[i].h) - color.s*cos(color.h), 2)
  + pow(array[i].s*sin(array[i].h) - color.s*sin(color.h), 2) 
  
  */ 
 
 /*
  Other algoritm, not used.
 distance[i] = abs(array[i].h - color.h)
 + abs(array[i].s - color.s)
 + abs(array[i].v - color.v))
 */
 
 return result;
 
}

@end


//From: http://stackoverflow.com/questions/3805177/how-to-convert-hex-rgb-color-codes-to-uicolor
//      Dave DeLong

void SKScanHexColor(NSString * hexString, float * red, float * green, float * blue, float * alpha) {
 NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
 if([cleanString length] == 3) {
  cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                 [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                 [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                 [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
 }
 if([cleanString length] == 6) {
  cleanString = [cleanString stringByAppendingString:@"ff"];
 }
 
 unsigned int baseValue;
 [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
 
 if (red) { *red = ((baseValue >> 24) & 0xFF)/255.0f; }
 if (green) { *green = ((baseValue >> 16) & 0xFF)/255.0f; }
 if (blue) { *blue = ((baseValue >> 8) & 0xFF)/255.0f; }
 if (alpha) { *alpha = ((baseValue >> 0) & 0xFF)/255.0f; }
}
