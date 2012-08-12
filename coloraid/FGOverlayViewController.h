//
//  FGOverlayViewController.h
//  coloraid
//
//  Created by francesco on 7/31/12.
//  Copyright (c) 2012 Softech di Germinara Francesco - www.germinara.it info@germinara.it. All rights reserved.
//  Rilevazione del colore
//  Cattura del frame della video camera, estrazione di un area 64x64 pixel dove è stato fatto 'Tap', calcolo della media dei valori
//  conversione da RGB a HSV, calcolo della distanza del colore medio rilevaro nella tabella di lookup dei colori supportati
//  visualizzazione immagine con codice codifica colorADD(c) MIGUEL NEIVA e emissione del suono con frequenza indicata da
//  Harbisson's Pure Sonochromatic Scales.

//  Problemi riscontrati: individuazione dei colori non sempre corretta
//                        frequenze audio di poco diverse tra loro, difficilmente distinguibili
//                        grafica simboli colorADD di qualità scadente, richiesto ad autore immagini in originali, non mi ha ca....to :-))
//
//  Sviluppi futuri:      Database con tabella colori di individuazione su DB
//                        Possibilità di salvare un nuovo colore nella tabella di lookup, da cattura immagine, utilizzando il valore medio
//                        ottenuto e associando quindi immagine grafica da far comparire e frequenza del suono che si vuole impostare
//                        Modifica dei valori di frequenza e dell'immagine dalla schemata dettagli colori.
//
// Francesco Germinara - info@germinara.it www.germinara.it
//

#import "FGAppDelegate.h"
#import <UIKit/UIKit.h>
#import "FGCaptureSession.h"
#import "FGHSV.h"
#import <AudioUnit/AudioUnit.h>


@interface FGOverlayViewController : UIViewController <UIGestureRecognizerDelegate>{

 FGAppDelegate* theAppDelegate; //Delegato applicazione
 NSMutableArray *markerViews; //Elenco punti in cui utente effettua tap (non usato al momento, un tap elimina l'altro)
 
 
AudioComponentInstance toneUnit; //Generatore di tono
 
//Dati gestiti per generatore tono
@public
	double frequency;
	double sampleRate;
	double theta;
 
}

@property (nonatomic) FGCaptureSession *captureManager; //Gestione camera

@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput; //Immagine catturata dalla videocamera
@property (nonatomic) IBOutlet UIView *areaToScan; //Area utilizzata per vedere inquadratura videocamera
@property (nonatomic) IBOutlet UIView *areaInfo;//Area utilizzata per visualizzare info sui dati catturati/risultato
@property (nonatomic) IBOutlet UIImageView *imageCaptured; //Immagine catturata dalla videocamera su cui effettuare l'elaborazione
@property (nonatomic) IBOutlet UIImageView *imageCode;//Immagine che visualizza il codice colore colorAdd del colore individuato


@property (nonatomic) IBOutlet UIView *hsvViewMx; //Valore Medio calcolato dell'area toccata da utente (Tap) nell'acquisizione dati
@property (nonatomic) IBOutlet UIView *hsvViewFound; //Valore colore trovato nell'elenco dei colori della tabella di lookup
@property (nonatomic) IBOutlet UILabel *colorName; //Nome trovato

@property (nonatomic) IBOutlet UILabel *descrCaptured; //Testo statico
@property (nonatomic) IBOutlet UILabel *descrMedia; //Testo statico
@property (nonatomic) IBOutlet UILabel *descrFound; //Testo statico


+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count; //Ricavo informazioni sui pixel che compongono l'immagine
- (int) colorDistanceforHSVColorHue:(float) h saturation:(float)s value:(float)v; //Calcolo distanza ed individuazione del colore più prossimo a quello specificato
- (void)stop; //Stop generazione nota

@end
