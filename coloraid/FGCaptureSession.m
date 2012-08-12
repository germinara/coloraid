//
//  FGCaptureSession.m
//  coloraid
//
//  Created by francesco on 7/31/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//

#import "FGCaptureSession.h"

@implementation FGCaptureSession

@synthesize captureSession;
@synthesize previewLayer;
@synthesize videoInput;

- (id)init {
	if ((self = [super init])) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
	}
	return self;
}

- (void)addVideoPreviewLayer {
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
 
}


-(void) torchModeOn{
 [videoDevice lockForConfiguration:nil];

  videoDevice.torchMode = AVCaptureTorchModeOn;
}

-(void) torchModeOff{
 [videoDevice lockForConfiguration:nil];
 videoDevice.torchMode = AVCaptureTorchModeOff;
}

- (void)addVideoInput {
 videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];	
	if (videoDevice) {
		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		if (!error) {
			if ([[self captureSession] canAddInput:videoIn]){
				[[self captureSession] addInput:videoIn];
    videoInput = videoIn;
			}else
				NSLog(@"Impossibile aggiungere video input");		
		}
		else
			NSLog(@"Impossibile creare video input");
	}
	else
		NSLog(@"Impossibile create dispositivo per la cattura video");
}

#pragma mark Camera Properties (da esempio Apple AVCAM)
// Perform an auto focus at the specified point. The focus mode will automatically change to locked once the auto focus is complete.
- (void) autoFocusAtPoint:(CGPoint)point
{
 AVCaptureDevice *device = [[self videoInput] device];
 if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
  NSError *error;
  if ([device lockForConfiguration:&error]) {
   [device setFocusPointOfInterest:point];
   [device setFocusMode:AVCaptureFocusModeAutoFocus];
   [device unlockForConfiguration];
  }
 }
}

// Switch to continuous auto focus mode at the specified point
- (void) continuousFocusAtPoint:(CGPoint)point
{
 AVCaptureDevice *device = [[self videoInput] device];
	
 if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			[device setFocusPointOfInterest:point];
			[device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
			[device unlockForConfiguration];
		}
	}
}

//
- (void)dealloc {
 
	[[self captureSession] stopRunning];
  previewLayer = nil;
	 captureSession = nil;
}


@end
