//
//  FGOverlayViewController.m
//  coloraid
//
//  Created by francesco on 7/31/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//

#import "FGOverlayViewController.h"
#import "MGTouchView.h"
#import <QuartzCore/QuartzCore.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/CGImageProperties.h>

#import <AudioToolbox/AudioToolbox.h>

#import "UIImage+RoundedResize.h"


/////////////////////
//Generazione Toni
/////////////////////

OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList 			*ioData)

{
	// Fixed amplitude is good enough for our purposes
	const double amplitude = 0.25;
 
	// Get the tone parameters out of the view controller
	FGOverlayViewController *viewController =
 (__bridge FGOverlayViewController *)inRefCon;
	double theta = viewController->theta;
	double theta_increment = 2.0 * M_PI * viewController->frequency / viewController->sampleRate;
 
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++)
	{
		buffer[frame] = sin(theta) * amplitude;
		
		theta += theta_increment;
		if (theta > 2.0 * M_PI)
		{
			theta -= 2.0 * M_PI;
		}
	}
	
	// Store the theta back in the view controller
	//viewController->theta = theta;
 
	return noErr;
}

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	FGOverlayViewController *viewController =
 (__bridge FGOverlayViewController *)inClientData;
	
	[viewController stop];
}

///////////////////////
//Generazione Toni End
///////////////////////
 

@interface FGOverlayViewController ()

@end

@implementation FGOverlayViewController


@synthesize captureManager;

@synthesize stillImageOutput;
@synthesize imageCaptured;
@synthesize areaToScan;
@synthesize imageCode;

@synthesize hsvViewMx;
@synthesize hsvViewFound;
@synthesize colorName;


@synthesize descrCaptured;
@synthesize descrMedia;
@synthesize descrFound;

@synthesize areaInfo;


///////////////////////
//Gestione Toni 
///////////////////////
- (void)createToneUnit
{
	// Configure the search parameters to find the default playback output unit
	// (called the kAudioUnitSubType_RemoteIO on iOS but
	// kAudioUnitSubType_DefaultOutput on Mac OS X)
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
	NSAssert1(toneUnit, @"Error creating unit: %d", err);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(toneUnit,
                            kAudioUnitProperty_SetRenderCallback,
                            kAudioUnitScope_Input,
                            0,
                            &input,
                            sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %d", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
 kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (toneUnit,
                             kAudioUnitProperty_StreamFormat,
                             kAudioUnitScope_Input,
                             0,
                             &streamFormat,
                             sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %d", err);
}

- (void)togglePlay
{
	if (toneUnit)
	{
		AudioOutputUnitStop(toneUnit);
		AudioUnitUninitialize(toneUnit);
		AudioComponentInstanceDispose(toneUnit);
		toneUnit = nil;
	}
	else
	{
		[self createToneUnit];
		
		// Stop changing parameters on the unit
		OSErr err = AudioUnitInitialize(toneUnit);
		NSAssert1(err == noErr, @"Error initializing unit: %d", err);
		
		// Start playback
		err = AudioOutputUnitStart(toneUnit);
		NSAssert1(err == noErr, @"Error starting unit: %d", err);
	}
}

- (void)stop
{
	if (toneUnit)
	{
		[self togglePlay];
	}
}

-(void)initAudioSession{
	sampleRate = 44100;
 frequency=400; 
 
	OSStatus result = AudioSessionInitialize(NULL, NULL, ToneInterruptionListener, (__bridge void *)(self));
	if (result == kAudioSessionNoError)
	{
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
	}
	AudioSessionSetActive(true);
}



- (void)viewDidUnload {
	AudioSessionSetActive(false);
}


///////////////////////
//Gestione Toni End
///////////////////////


- (void)viewDidLoad {
 
 [super viewDidLoad];
 
 //Nascondo la prima volta i dati output dell'elaborazione
 descrCaptured.hidden=true;
 descrMedia.hidden=true;
 descrFound.hidden=true;
 areaInfo.hidden=true;
 
 //Imposto delegato
 theAppDelegate =[[UIApplication sharedApplication] delegate];
 
 //Inizializzo generatore Note
 [self initAudioSession];
 
 //Elenco dei punti toccati
 markerViews = [[NSMutableArray alloc] init];
 
  //Configuro videocamera
	[self setCaptureManager:[[FGCaptureSession alloc] init]];
	[[self captureManager] addVideoInput];
	[[self captureManager] addVideoPreviewLayer];
 
  
	CGRect layerRect = [[self.areaToScan layer] bounds];
//	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                               CGRectGetMidY(layerRect))];
	[[self.areaToScan layer] addSublayer:[[self captureManager] previewLayer]];
//	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
 
 //Configuro per cattura frame da videocamera
 stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
 NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
 [stillImageOutput setOutputSettings:outputSettings];
 [self.captureManager.captureSession addOutput:stillImageOutput];
 
 //Imposto gesture singolo Tap per catturare frame da videocamera
 UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
 [self.areaToScan addGestureRecognizer:tapRecognizer];
 [tapRecognizer setDelegate:self];
 
 //Imposto autofocus continuo
 [[self captureManager] continuousFocusAtPoint:CGPointMake(.5f, .5f)];
 
 //Attivo videocamera
	[[captureManager captureSession] startRunning];
 
}

//Utente ha fatto Tap su area del video della videocamera
-(void)handleTap:(UIGestureRecognizer*)recognizer {
 
 //Attivo visualizzazioni info utente
 descrCaptured.hidden=false;
 descrMedia.hidden=false;
 descrFound.hidden=false;
 areaInfo.hidden=false;

 //Ricavo punto
 CGPoint tapPoint = [recognizer locationInView:self.areaToScan];

 //Per fuoco sul punto utente: Non usato
 //CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
 [self captureImageWithPointX:tapPoint.x PointY:tapPoint.y];
 
 [self createTouchMarkerAtPointX:tapPoint.x PointY:tapPoint.y];
  
 
/*Per fuoco sul punto utente: Non usato
 if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported]) {
  CGPoint tapPoint = [recognizer locationInView:self.areaToScan];
  CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
  [[self captureManager] autoFocusAtPoint:convertedFocusPoint];
  [self captureImageWithPointX:convertedFocusPoint.x PointY:convertedFocusPoint.y];
 }
 */
}


- (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
}

- (void)dealloc {
  captureManager = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}


// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right. Da Apple esempio (AVCAM)
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
 CGPoint pointOfInterest = CGPointMake(.5f, .5f);
 CGSize frameSize = [[self.areaToScan layer] frame].size;
 
 if ([[[self captureManager] previewLayer] isMirrored]) {
  viewCoordinates.x = frameSize.width - viewCoordinates.x;
 }
 
 if ( [[[[self captureManager] previewLayer] videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
  pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
 } else {
  CGRect cleanAperture;
  for (AVCaptureInputPort *port in [[captureManager videoInput] ports]) {
   if ([port mediaType] == AVMediaTypeVideo) {
    cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
    CGSize apertureSize = cleanAperture.size;
    CGPoint point = viewCoordinates;
    
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    CGFloat xc = .5f;
    CGFloat yc = .5f;
    
    if ( [[[[self captureManager] previewLayer] videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
     if (viewRatio > apertureRatio) {
      CGFloat y2 = frameSize.height;
      CGFloat x2 = frameSize.height * apertureRatio;
      CGFloat x1 = frameSize.width;
      CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
      if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
       xc = point.y / y2;
       yc = 1.f - ((point.x - blackBar) / x2);
      }
     } else {
      CGFloat y2 = frameSize.width / apertureRatio;
      CGFloat y1 = frameSize.height;
      CGFloat x2 = frameSize.width;
      CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
      if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
       xc = ((point.y - blackBar) / y2);
       yc = 1.f - (point.x / x2);
      }
     }
    } else if ([[[[self captureManager] previewLayer] videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
     if (viewRatio > apertureRatio) {
      CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
      xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
      yc = (frameSize.width - point.x) / frameSize.width;
     } else {
      CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
      yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
      xc = point.y / frameSize.height;
     }
    }
    
    pointOfInterest = CGPointMake(xc, yc);
    break;
   }
  }
 }
 
 return pointOfInterest;
}


//Creo e visualizzo marker dove utente ha fatto Tap
- (void) createTouchMarkerAtPointX:(float)xPos PointY:(float)yPos
{
		// Create view for this touch.
 MGTouchView *removeView=(MGTouchView*) [self.areaToScan viewWithTag:999];
 if(removeView != nil){
  [removeView removeFromSuperview];
  [markerViews removeAllObjects];
 }
 
 float viewWidth = 64.0; // reasonable size so that the outer ring is visible around fingertips.
 MGTouchView *view = [[MGTouchView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
 CGPoint pt;
 pt.y=yPos;
 pt.x=xPos;
 view.center= pt;
 view.tag = 999;
 
  view.color = [UIColor whiteColor];

		[markerViews  addObject:view];
 	[self.areaToScan addSubview:view];
 
 	[self.areaToScan setNeedsDisplay];
}



//Catturo immagine al posizione in cui utente ha fatto Tap
-(void) captureImageWithPointX:(int) x PointY:(int)y{
 
 NSLog(@"X: %d Y: %d",x,y);
 
 // Effetto flash della videata per segnalare cattura immagine
 UIView *flashView = [[UIView alloc] initWithFrame:[[[self captureManager] previewLayer] frame]];
 [flashView setBackgroundColor:[UIColor whiteColor]];
 [[[self view] window] addSubview:flashView];
 
 [UIView animateWithDuration:.4f
                  animations:^{
                   [flashView setAlpha:0.f];
                  }
                  completion:^(BOOL finished){
                   [flashView removeFromSuperview];
                  }
  ];
 
	//Cattuto immagine
 AVCaptureConnection *videoConnection = nil;
 for (AVCaptureConnection *connection in stillImageOutput.connections)
 {
  for (AVCaptureInputPort *port in [connection inputPorts])
  {
   if ([[port mediaType] isEqual:AVMediaTypeVideo] )
   {
    videoConnection = connection;
    break;
   }
  }
  if (videoConnection) { break; }
 }
 
 [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
  {
   CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
   if (exifAttachments)
   {
    // Informazioni relative all'immagine catturata (non utilizzate)
    NSLog(@"attachements: %@", exifAttachments);
   }
   else
    NSLog(@"no attachments");
  
   //Ricavo dati e costruisco immagine
   NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
   UIImage *imageTmp = [[UIImage alloc] initWithData:imageData];
   
   //Ritaglio l'area che mi interessa
   CGRect rectClip;
   rectClip = [[[self captureManager] previewLayer] frame];
   UIImage *image = [imageTmp imageByScalingAndCroppingForSize:CGSizeMake(rectClip.size.width, rectClip.size.height)];

   int centerX=x;
   int centerY=y;
   //Lettura dei pixel dell'area 64 x 64, per calcolo valore medio
   NSMutableArray *colors=[[NSMutableArray alloc] initWithCapacity:442];
   int nRows=-32;
   int nMaxRows=32;
   for(;nRows<=nMaxRows;nRows++){
    [colors addObjectsFromArray:[FGOverlayViewController getRGBAsFromImage:image atX:centerX-32 andY:centerY count:65]];
   }
   
   float red=0.0;
   float green=0.0;
   float blue=0.0;
   float alpha=0.0;
   
   float mxred=0.0;
   float mxgreen=0.0;
   float mxblue=0.0;
   
   float mxh=0.0;
   float mxs=0.0;
   float mxv=0.0;
   
   float h=0.0;
   float s=0.0;
   float v=0.0;
   
   //Calcolo media: sia in RGB sia HSV
   for(UIColor *theColor in colors){
    [theColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [theColor getHue:&h saturation:&s brightness:&v alpha:&alpha];
    mxh+=h;
    mxs+=s;
    mxv+=v; 
    
    
    mxred+=red;
    mxgreen+=green;
    mxblue+=blue; 
   }
   
   int nColors =[colors count];
   if (nColors>0) {
    mxh/=nColors;
    mxs/=nColors;
    mxv/=nColors; 
    
    mxred/=nColors;
    mxgreen/=nColors;
    mxblue/=nColors;   
   }
   
 /*
   Debug Info; 
   self.redValue.text=[NSString stringWithFormat:@"%d",(int)(mxred * 255.0)];
   self.greenValue.text=[NSString stringWithFormat:@"%d",(int)(mxgreen * 255.0)];
   self.blueValue.text=[NSString stringWithFormat:@"%d",(int)(mxblue * 255.0)];

   
   self.hValue.text=[NSString stringWithFormat:@"%d",(int)(mxh * 360)];
   self.sValue.text=[NSString stringWithFormat:@"%d",(int)(mxs * 100)];
   self.vValue.text=[NSString stringWithFormat:@"%d",(int)(mxv * 100)];
   
 */

   //Visualizzo colore corrispondente al valore medio HSV calcolato
   self.hsvViewMx.backgroundColor= [UIColor colorWithHue:mxh saturation:mxs brightness:mxv alpha:1.0];
   self.hsvViewFound.backgroundColor= nil;

   //Calcolo indice del colore che approssima il colore specificato in HSV dalla tabella di lookup
   int colorIndex=[self colorDistanceforHSVColorHue:mxh saturation:mxs value:mxv];

   NSLog(@"Index color: %d",colorIndex);
   self.imageCode.image = nil;
   self.colorName.text=@"";

   
   //Se ho trovato un colore nella tabella di lookup
   FGHSV *fgHSV;
   if(colorIndex != -1){
    fgHSV=[theAppDelegate.colorLookUpTable objectAtIndex:colorIndex];

    /*
    Debug Info:
    self.hValue.text=[NSString stringWithFormat:@"%d",(int)(fgHSV.h * 360)];
    self.sValue.text=[NSString stringWithFormat:@"%d",(int)(fgHSV.s * 100)];
    self.vValue.text=[NSString stringWithFormat:@"%d",(int)(fgHSV.v * 100)];
    */
    
    //Assegno il colore trovato per rendere visibile il risultato
    self.hsvViewFound.backgroundColor= [UIColor colorWithHue:fgHSV.h  saturation:fgHSV.s brightness:fgHSV.v alpha:1.0];

    //Imposto i dati ricavati dalla tabella di lookup: frequenza, codice colore colorAdd e nome colore
    frequency=fgHSV.frequency;
    self.imageCode.image = fgHSV.image;
    self.colorName.text=fgHSV.name;

    
   }
   
   //Generazione della nota acustica corrispondente per 1 secondo.
   [self togglePlay];
   [NSTimer scheduledTimerWithTimeInterval:1.0
                                    target:self
                                  selector:@selector(stop)
                                  userInfo:nil
                                   repeats:NO];
 
   //Visualizzo immagine catturata dalla videocamera
   self.imageCaptured.image = image;
  }];
}

//Lettura pixel dal UIImage
+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
 NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
 
 // First get the image into your data buffer
 CGImageRef imageRef = [image CGImage];
 NSUInteger width = CGImageGetWidth(imageRef);
 NSUInteger height = CGImageGetHeight(imageRef);
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
 NSUInteger bytesPerPixel = 4;
 NSUInteger bytesPerRow = bytesPerPixel * width;
 NSUInteger bitsPerComponent = 8;
 CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                              bitsPerComponent, bytesPerRow, colorSpace,
                                              kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
 CGColorSpaceRelease(colorSpace);
 
 CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
 CGContextRelease(context);
 
 // Now your rawData contains the image data in the RGBA8888 pixel format.
 int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
 for (int ii = 0 ; ii < count ; ++ii)
 {
  CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
  CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
  CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
  CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
  byteIndex += 4;
  
  UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
  [result addObject:acolor];
 }
 
 free(rawData);
 
 return result;
}


//Distanza e individuazione del colore nella tabella di lookup
-(int) colorDistanceforHSVColorHue:(float) h saturation:(float)s value:(float)v{
  int nIndex=0;
  int nTableSize=[theAppDelegate.colorLookUpTable count];
  FGHSV* fgHSV;
  double distance=0.0;
  double minDistance=1000.0;
  int nColorIndexFound=-1;
  NSLog(@"\nCerco colore");
  for(nIndex=0; nIndex<nTableSize;nIndex++){
   fgHSV = [theAppDelegate.colorLookUpTable objectAtIndex:nIndex];
   distance=[fgHSV colorDistanceforHSVColorHue:h saturation:s value:v];
   
   NSLog(@"Index: %d fgHSV.h = %f h: %f fgHSV.s = %f s: =%f fgHSV.v = %f v: %f Distance: %f",nIndex,fgHSV.h,h,fgHSV.s,s,fgHSV.v,v,distance);
   
   if(distance <= minDistance){
    minDistance = distance;
    nColorIndexFound=nIndex;
   }
  }
 return nColorIndexFound;
}





@end
