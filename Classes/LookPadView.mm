//
//  LookPadView.m
//  AlephOne
//
//  Created by Dusti Wenz on 10/9/16.
//

#import "LookPadView.h"
#import "AlephOneHelper.h"
#import "GameViewController.h"
extern "C" {
//Still needed for iOS 6-19-24?#include "SDL2/SDL_keyboard_c.h"
#include "SDL2/SDL_keyboard.h"
#include "SDL2/SDL_stdinc.h"
//Still needed for iOS 6-19-24?#include "SDL_mouse_c.h"
#include "SDL2/SDL_mouse.h"
#include "SDL2/SDL_events.h"
}
#include "cseries.h"
#include <string.h>
#include <stdlib.h>

#include "map.h"
#include "interface.h"
#include "shell.h"
#include "preferences.h"
#include "mouse.h"
#include "player.h"
#include "key_definitions.h"
#include "tags.h"

@implementation LookPadView

@synthesize rotationRate;
@synthesize lastGyroUpdate;
@synthesize specialGyroModeActive;

- (void)setup {
	
	motionManager = [[CMMotionManager alloc] init];
	
  // Kill a warning
	//Still needed for iOS 6-19-24?(void)all_key_definitions;

  // Initialization code
	primaryFireKey = findKeyCodeInPrefs(_left_trigger_state);
	secondaryFireKey = findKeyCodeInPrefs(_right_trigger_state);
	nextWeaponKey = findKeyCodeInPrefs(_cycle_weapons_forward);
	previousWeaponKey = findKeyCodeInPrefs(_cycle_weapons_backward);

	//Still needed for iOS 6-19-24?SDL_MouseInit();
  [self unPauseGyro];
	specialGyroModeActive = 0;
	[self startGyro];
}

- (void)handleTouch:(CGPoint)currentPoint {
	double height = [self bounds].size.height;
	double width = [self bounds].size.width;

  double dx, dy;
	dx = currentPoint.x;
	dy = currentPoint.y;
	
  [self unPauseGyro];
  
	if (/*currentPoint.y < height * (1.0/3.0) && */currentPoint.x < width * (2.0/3.0)) {
		setKey(primaryFireKey, 1);
	} else {
		setKey(primaryFireKey, 0);
	}
	
	if (/*currentPoint.y < height * (1.0/3.0) && */currentPoint.x > width * (1.0/3.0)) {
    setKey(secondaryFireKey, 1);
	} else {
    setKey(secondaryFireKey, 0);
	}
	
	if ( !specialGyroModeActive && [[NSUserDefaults standardUserDefaults] boolForKey:kTiltTurning] ) {
		[self resetGyro];
		specialGyroModeActive = 1;
	}
  
  //If the make the transition from on button to off in the lower half of the control, switch weapons.
  /*if (currentPoint.y > height/2 && currentPoint.x < 0 && lastMovedPoint.x >= 0) {
    setKey(previousWeaponKey, 1);
    [self performSelector:@selector(previousWeaponKeyUp) withObject:nil afterDelay:0.1];
  }
  if (currentPoint.y > height/2 && currentPoint.x > width && lastMovedPoint.x <= width) {
    setKey(nextWeaponKey, 1);
    [self performSelector:@selector(nextWeaponKeyUp) withObject:nil afterDelay:0.1];
  }*/
	
}

- (void) nextWeaponKeyUp {
  setKey(nextWeaponKey, 0);
}
- (void) previousWeaponKeyUp {
    setKey(previousWeaponKey, 0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	for ( UITouch *touch in [event touchesForView:self] ) {
    lastMovedPoint=[touch locationInView:self];
		[self handleTouch:[touch locationInView:self]];
		break;
	}

	
}

- (void) stopGyro {
	[motionManager stopGyroUpdates];
	gyroActive = 0;
}

- (void) resetGyro {
	gyroDeltaX = 0;
	gyroDeltaY = 0;
	gyroDeltaZ = 0;
	[self setLastGyroUpdate:[NSDate date]];
}

- (void) startGyro {

	[self resetGyro];
	gyroActive = 1;
	
    //Raw gyro data sucks on older devices because there is too much drift.
	/*[motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyro, NSError *error)
						 {
							 
							 [(id) self setRotationRate:gyro.rotationRate];
							 [self performSelectorOnMainThread:@selector(handleGyro) withObject:nil waitUntilDone:NO];
						 }];*/
  
  [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error)
   {
     [(id) self setRotationRate:motion.rotationRate];
     [self performSelectorOnMainThread:@selector(handleGyro) withObject:nil waitUntilDone:NO];
   }];
}

- (void)pauseGyro {
  gyroPaused=1;
}
- (void)unPauseGyro {
  gyroPaused=0;
}

- (void)handleGyro {

  
  if ([[GameViewController sharedInstance] mode] != GameMode) {
    [self resetGyro]; //If we are not in a game, keep the gyro clear.
    return;
  }
  
  if(gyroPaused)
    return;
  
	double elapsedtime = 0.0 - [lastGyroUpdate timeIntervalSinceNow];
	[self setLastGyroUpdate:[NSDate date]];
	double tiltFactor = 300; //Arbitrary number multiplied by the amount of rotation used for aiming/look.
	double turnFactor = 900; //Arbitrary number multiplied by the amount of rotation used for tilt turning.
	
	
  double cutoff = 2 * elapsedtime; //Drift/noise filter. Gyro movements below this threshold will be ignored.

	
		//How much we rotated on this call. Small rotations don't count.
	double rotatedX = abs(rotationRate.x) < cutoff ? 0.0 : rotationRate.x * elapsedtime;
	double rotatedY = abs(rotationRate.y) < cutoff ? 0.0 : rotationRate.y * elapsedtime;
	double rotatedZ = abs(rotationRate.z) < cutoff ? 0.0 : rotationRate.z * elapsedtime;
  
  //Invert X and Y if device is upside down (Home button is on left).
  //Note that we need the interface orientation, NOT the device orientation.
  UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
  if (orientation == UIInterfaceOrientationLandscapeLeft)  {
    rotatedX *= -1.0;
    rotatedY *= -1.0;
  }
  
	//Apply comfortable rotation rate adjustment.
	gyroDeltaX = rotatedX  * tiltFactor;
	gyroDeltaY = rotatedY  * tiltFactor;
	gyroDeltaZ = rotatedZ  * turnFactor;
	
	//If specialGyroModeActive is set, then we only look when turning in the direction we've already moved from zero.
	//If specialGyroModeActive is not set, just look normally using the gyro.

	double mouseMovementX = gyroDeltaX;
	gyroDeltaX -= (double)mouseMovementX;
	
	double mouseMovementY = gyroDeltaY;
	gyroDeltaY -= (double)mouseMovementY;
	
  if( ![[NSUserDefaults standardUserDefaults] boolForKey:kGyroAiming] ) {
    mouseMovementX = 0;
    mouseMovementY = 0;
  }
  
	double mouseMovementZ = 0; //This is actually going to become X movement below.
	if (specialGyroModeActive ){
		mouseMovementZ = gyroDeltaZ;
		gyroDeltaZ -= (double)mouseMovementZ;
	}

  moveMouseRelative(0 - (mouseMovementX + mouseMovementZ), mouseMovementY);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	const Uint8 *key_map = SDL_GetKeyboardState ( NULL );
	
  setKey(primaryFireKey, 0);
  setKey(secondaryFireKey, 0);

	specialGyroModeActive = 0;
	return;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"Touches moved on look pad" );
  for ( UITouch *touch in [event touchesForView:self] ) {
		
    [self handleTouch:[touch locationInView:self]];
    break;
  }
}

- (void)dealloc {
	[super dealloc];
}


@end
