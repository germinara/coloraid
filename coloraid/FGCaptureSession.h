//
//  FGCaptureSession.h
//  coloraid
//
//  Created by francesco on 7/31/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//  Funzioni di base per la gestione della videocamera posteriore iphone

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface FGCaptureSession : NSObject{
 AVCaptureDevice *videoDevice;
}

@property  AVCaptureVideoPreviewLayer *previewLayer;
@property  AVCaptureSession *captureSession;
@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;
- (void) torchModeOn;
- (void) torchModeOff;
- (void) autoFocusAtPoint:(CGPoint)point;
- (void) continuousFocusAtPoint:(CGPoint)point;


@end
