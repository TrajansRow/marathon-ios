//
//  MovePadView.m
//  AlephOne
//
//  Created by Daniel Blezek on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MovePadView.h"
#import "GameViewController.h"
extern "C" {  
//Still needed for iOS 6-19-24?#include "SDL2/SDL_keyboard_c.h"
#include "SDL2/SDL_keyboard.h"
#include "SDL2/SDL_stdinc.h"
//Still needed for iOS 6-19-24?#include "SDL2/SDL_mouse_c.h"
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

#include "AlephOneHelper.h"

@implementation MovePadView
@synthesize forwardKey;
@synthesize dPadView, knobView, dPadSwimmingView;

- (void)setup {
	
	
	//DCW
	feedbackSecondary = [[UIImpactFeedbackGenerator alloc] init];
	[feedbackSecondary initWithStyle:UIImpactFeedbackStyleHeavy];
  originalFrame=CGRectMake(0, 0, 0, 0);

  [dPadSwimmingView setHidden:YES];
  
  // Kill a warning
	//Still needed for iOS 6-19-24?(void)all_key_definitions;

  // Initialization code
  //moveCenterPoint = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 );
  moveCenterPoint = CGPointMake(dPadView.frame.origin.x + dPadView.bounds.size.width / 2.0, dPadView.frame.origin.y + dPadView.bounds.size.height / 2.0 );
  //moveRadius = ( moveCenterPoint.x + moveCenterPoint.y ) / 2.0;
  moveRadius = dPadView.bounds.size.width / 2.0; //DCW?
  moveRadius2 = moveRadius * moveRadius;
  runRadius = moveRadius / 2.0;
  deadSpaceRadius = moveRadius / 5.0;

	forwardKey = findKeyCodeInPrefs(_moving_forward);
	backwardKey = findKeyCodeInPrefs(_moving_backward);
	leftKey = findKeyCodeInPrefs(_sidestepping_left);
	rightKey = findKeyCodeInPrefs(_sidestepping_right);
	runKey = findKeyCodeInPrefs(_run_dont_walk);
	secondaryFireKey = findKeyCodeInPrefs(_right_trigger_state);
	actionKey = findKeyCodeInPrefs(_action_trigger_state);
}

	//DCW
- (void) actionKeyUp {
	if(actionKey){
		setKey(actionKey, 0);
	}
}

	//DCW added withNormalizedForce input with handleTouch. withNormalizedForce must be 0-1.
- (void)handleTouch:(CGPoint)currentPoint { [self handleTouch: currentPoint withNormalizedForce: 0.0]; }
- (void)handleTouch:(CGPoint)currentPoint withNormalizedForce:(double)force{
  const Uint8 *key_map = SDL_GetKeyboardState ( NULL );
  
    //Move our desired knob location based on movement delta.
    //We will limit the knob location to stay within our run limit.
    //The reason for doing this is to provide a consistent swipe distance for a "stop/change-direction" operation.
  knobLocation.x += currentPoint.x - lastLocation.x;
  knobLocation.y += currentPoint.y - lastLocation.y;
  
  // Doesn't matter where we are in this control, just find the position relative to the center
  float dx, dy;
  dx = knobLocation.x - moveCenterPoint.x;
  dy = knobLocation.y - moveCenterPoint.y;
  
  // Move the knob...
  float distance2 = dx * dx + dy * dy;
  if ( distance2 > moveRadius2 ) {
    // Limit to the radius
    float tx, ty;
    float length = 1.0 / sqrt ( distance2 );
    tx = dx * length;
    ty = dy * length;
    tx = moveCenterPoint.x + tx * moveRadius;
    ty = moveCenterPoint.y + ty * moveRadius;
    self.knobView.center = CGPointMake(tx, ty);
  } else {
    self.knobView.center = knobLocation;
  }
  // NSLog ( @"Move delta: %f, %f", dx, dy );
  // Do we move left or right?
  
  float fdx = fabs ( dx );
  float fdy = fabs ( dy );
  
  float tightClamp = [[NSUserDefaults standardUserDefaults] boolForKey:kAlwaysRun] && (useForceTouch || !headBelowMedia()); //Whether to clamp the knob close to center or not.
  bool shouldRunIfNeeded = ( fdx > runRadius || fdy > runRadius || tightClamp);
  float runThresholdBufferX=5; //How far we let the knob move into the run delta threshold for strafing.
  float runThresholdBufferY=30; //How far we let the knob move into the run delta threshold for forward/back movement.
  
  // Are we running?
  if ( shouldRunIfNeeded ) {
    setKey(runKey, 1);
    // MLog ( @"Running!" );
		
			//DCW: If we support forcetouch, and the force is low, invert sink/swim because running is also swim.
		if(useForceTouch) {
			if ( force > 0.5 ) {
				SET_FLAG(input_preferences->modifiers,_inputmod_interchange_swim_sink, false);
        shouldBeSwimmingIfSubmerged=YES;
			}
			else {
				SET_FLAG(input_preferences->modifiers,_inputmod_interchange_swim_sink, true);
        shouldBeSwimmingIfSubmerged=NO;
			}
    } else {
       shouldBeSwimmingIfSubmerged=YES;
    }
  } else {
    setKey(runKey, 0);
    
    shouldBeSwimmingIfSubmerged=NO;
    
			//DCW: If we support forcetouch, and it the force is high, we can invert sink/swim so we will swim under pressure.
		if(useForceTouch) {
			if ( force > 0.5 ) {
				SET_FLAG(input_preferences->modifiers,_inputmod_interchange_swim_sink, true);
        shouldBeSwimmingIfSubmerged=YES;
			}
			else {
				SET_FLAG(input_preferences->modifiers,_inputmod_interchange_swim_sink, false);
        shouldBeSwimmingIfSubmerged=NO;
			}
		}
  }
  // Left
  if ( dx < -deadSpaceRadius ) {
    // Just move for now
    // NSLog ( @"Move left" );
    setKey(leftKey, 1);
    
    if (dx < 0.0-deadSpaceRadius-runThresholdBufferX-((!tightClamp)*runRadius)) {
      knobLocation.x=moveCenterPoint.x-deadSpaceRadius-((!tightClamp)*runRadius)-runThresholdBufferX;
    }
  } else {
    setKey(leftKey, 0);
  }
  // Right
  if ( dx > deadSpaceRadius ) {
    // NSLog(@"Move right" );
    setKey(rightKey, 1);
    if (dx > deadSpaceRadius+runThresholdBufferX+((!tightClamp)*runRadius)) {
      knobLocation.x=moveCenterPoint.x+deadSpaceRadius+((!tightClamp)*runRadius)+runThresholdBufferX;
    }
  } else {
    setKey(rightKey, 0);
  }
  
  // Forward, remember that y is increasing up
  if ( dy < -deadSpaceRadius ) {
    // NSLog(@"Move forward");
    setKey(forwardKey, 1);
    
    
    if (dy < 0.0-deadSpaceRadius-runThresholdBufferY-((!tightClamp)*runRadius)) {
      knobLocation.y=moveCenterPoint.y-deadSpaceRadius-((!tightClamp)*runRadius)-runThresholdBufferY;
    }
  } else {
    setKey(forwardKey, 0);
  }
  // Backward
  if ( dy > deadSpaceRadius ) {
    // NSLog(@"Move backward");
    setKey(backwardKey, 1);
    
    if (dy > deadSpaceRadius+runThresholdBufferY+((!tightClamp)*runRadius)) {
      knobLocation.y=moveCenterPoint.y+deadSpaceRadius+((!tightClamp)*runRadius)+runThresholdBufferY;
    }
  } else {
    setKey(backwardKey, 0);
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  useForceTouch = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable; //DCW: force capability must be checked often, because it fails when view is not in the view hierarchy.
  if (originalFrame.size.width == 0) {
    originalFrame=[self frame];
  }
  
  shouldBeSwimmingIfSubmerged=NO;
  [self updateSwimmingIndicatorVisibility];
  
  for ( UITouch *touch in [event touchesForView:self] ) {
    //DCW: I think I'm going to auto-center the control under the touch to prevent immediate movement.
    
    CGRect newFrame=[dPadView frame];
    CGPoint center = CGPointMake(newFrame.size.width/2,newFrame.size.height/2 );
    lastLocation=[touch locationInView:self];
    knobLocation=lastLocation;
    newFrame.origin.x = lastLocation.x-center.x;
    newFrame.origin.y = lastLocation.y-center.y;
    [dPadView setFrame:newFrame];
    [dPadSwimmingView setFrame:newFrame];
    
    moveCenterPoint = CGPointMake(dPadView.frame.origin.x + dPadView.bounds.size.width / 2.0, dPadView.frame.origin.y + dPadView.bounds.size.height / 2.0 );
    //[self handleTouch:[touch locationInView:self]]; //Irrelevant when control is centered.
    break;
  }
  
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // See if there are still touches in the

 // NSLog(@"Touches ended");
  // lift up on all the keys
  setKey(leftKey, 0);
  setKey(rightKey, 0);
  setKey(forwardKey, 0);
  setKey(backwardKey, 0);
  setKey(runKey, 0);

  SET_FLAG(input_preferences->modifiers,_inputmod_interchange_swim_sink, false); //DCW
  shouldBeSwimmingIfSubmerged=NO;
  [self updateSwimmingIndicatorVisibility];
  
	//DCW. Do open/activate key when released
  if( [[NSUserDefaults standardUserDefaults] boolForKey:kDPadAction] || PLAYER_IS_DEAD(local_player)) {
    setKey(actionKey, 1);
    if ([[GameViewController sharedInstance].HUDViewController lookingAtRefuel]){
      [[GameViewController sharedInstance].HUDViewController.lookPadView pauseGyro];
    }
    [self performSelector:@selector(actionKeyUp) withObject:nil afterDelay:0.15];
  }
  
  // Animate the knob returning to home...
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:0.2];
  self.knobView.center = moveCenterPoint;
  [UIView commitAnimations];
  
  //Animate entire control returning to default location.
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:0.1];
  self.frame = originalFrame;
  [UIView commitAnimations];

  return;
  
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  // NSLog(@"Touches moved" );
  for ( UITouch *touch in [event touchesForView:self] ) {
			//DCW: Added force to handleTouch call
    [self handleTouch:[touch locationInView:self] withNormalizedForce:touch.force / touch.maximumPossibleForce ];
    lastLocation=[touch locationInView:self];
    break;
  }
}

- (void)dealloc {
  self.knobView = nil;
    [super dealloc];
}

- (void) updateSwimmingIndicatorVisibility {
  
  if (headBelowMedia()) {
    [dPadSwimmingView setHidden:!shouldBeSwimmingIfSubmerged];
  } else {
    [dPadSwimmingView setHidden:YES];
  }
  
}

@end
