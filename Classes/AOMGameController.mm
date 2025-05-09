//
//  AOMGameController.mm
//  AlephOne
//
//  Created by Dustin Wenz on 4/16/19.
//  Copyright © 2019 SDG Productions. All rights reserved.
//

#import "AOMGameController.h"
#import "GameViewController.h"
#import "GameController/GCExtendedGamepad.h"
#import "GameController/GCControllerButtonInput.h"
#import "GameController/GCControllerDirectionPad.h"
#import "GameController/GCControllerAxisInput.h"

extern "C" {
//Still needed for iOS 6-19-24?#include "SDL2/SDL_keyboard_c.h"
#include "SDL2/SDL_keyboard.h"
#include "SDL2/SDL_stdinc.h"
//Still needed for iOS 6-19-24?#include "SDL2/SDL_mouse_c.h"
#include "SDL2/SDL_mouse.h"
#include "SDL2/SDL_events.h"
}

#include "player.h"
#include "key_definitions.h"
#include "preferences.h"

#include "AlephOneHelper.h"

@implementation AOMGameController

@synthesize mainController;
@synthesize nextWeapon;
@synthesize previousWeapon;
@synthesize mapKey;
@synthesize runKey;
@synthesize actionKey;
@synthesize primaryFire;
@synthesize secondaryFire;
@synthesize moveForward;
@synthesize moveBack;
@synthesize moveLeft;
@synthesize moveRight;

@synthesize rightXAxis;
@synthesize rightYAxis;
@synthesize leftXAxis;
@synthesize lefttYAxis;

-(id)init {
  self = [super init];

  
  [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
  
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerConnected:) name:GCControllerDidConnectNotification object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerDisconnected:) name:GCControllerDidDisconnectNotification object:nil];
  
  return self;
}
- (void)controllerConnected:(NSNotification *)notification {

	[self setupControllerKeys];
	
  GCController *newController = (GCController *)notification.object;
  
  NSLog(@"Controller Connected: %@", newController.vendorName);
  
  [self setMainController: newController];  
  [self.mainController setControllerPausedHandler: ^(GCController *controller) {
    //Note: don't let the AO SDL joystick event handler initialize, otherwise it will override this callback.
    
    if( !getLocalPlayer() ){
      return;
    }
        
    [[GameViewController sharedInstance] togglePause:self];
  } ];
  
  [self handleControllerInput];
}

- (void)setupControllerKeys {
	moveForward = findKeyCodeInPrefs(_moving_forward);
	moveBack = findKeyCodeInPrefs(_moving_backward);
	moveLeft = findKeyCodeInPrefs(_sidestepping_left);
	moveRight = findKeyCodeInPrefs(_sidestepping_right);
	runKey = findKeyCodeInPrefs(_run_dont_walk);
	primaryFire = findKeyCodeInPrefs(_left_trigger_state);
	secondaryFire = findKeyCodeInPrefs(_right_trigger_state);
	mapKey = findKeyCodeInPrefs(_toggle_map);
	actionKey	= findKeyCodeInPrefs(_action_trigger_state);
	nextWeapon = findKeyCodeInPrefs(_cycle_weapons_forward);
	previousWeapon = findKeyCodeInPrefs(_cycle_weapons_backward);
}

	
- (void)controllerDisconnected:(NSNotification *)notification {
  GCController *controller = (GCController *)notification.object;
  
  NSLog(@"Controller Disconnected: %@", controller.vendorName);

  self.mainController = nil;
}
- (void)handleControllerState {
  if (self.mainController == nil) {
    return;
  }
}

- (void)handleControllerInput {
    
  // register block for input change detection
  
  GCExtendedGamepad *profile = self.mainController.extendedGamepad;
	
  profile.valueChangedHandler = ^(GCExtendedGamepad *gamepad, GCControllerElement *element)
  
  {
    
    NSString *message = @"";
    
    GCControllerDirectionPad *lookThumbstick = gamepad.rightThumbstick;
    GCControllerDirectionPad *moveThumbstick = gamepad.leftThumbstick;

    if( shouldswapJoysticks() ){
      lookThumbstick = gamepad.leftThumbstick;
      moveThumbstick = gamepad.rightThumbstick;
    }
    		
    //Triggers. Only activate if this is a current element, so we don't interfere with smart trigger.
    if ( gamepad.rightTrigger == element ) {
      setKey(primaryFire, gamepad.rightTrigger.isPressed);
    }
    if (gamepad.leftTrigger == element) {
      setKey(secondaryFire, gamepad.leftTrigger.isPressed);
    }
    
    if (gamepad.rightShoulder == element) {
      setSmartFirePrimary(gamepad.rightShoulder.isPressed);
    }
    
    // XYAB buttons
    setKey(actionKey, gamepad.buttonA.isPressed);
      //Pause gyro if in refuel.
    if (gamepad.buttonA.isPressed && [[GameViewController sharedInstance].HUDViewController lookingAtRefuel]){
      [[GameViewController sharedInstance].HUDViewController.lookPadView pauseGyro];
    }
    setKey(nextWeapon, gamepad.buttonB.isPressed);
    setKey(previousWeapon, gamepad.buttonY.isPressed);
    setKey(mapKey, gamepad.buttonX.isPressed);
    
    
      //Always run above media. Never check headBelowMedia or set preferences if no game is active, otherwise it will crash!
    setKey(runKey, 1);
    if ([[GameViewController sharedInstance] mode] == GameMode) {
      if(headBelowMedia()){
        SET_FLAG(input_preferences->modifiers,_inputmod_interchange_swim_sink, true);
      } else {
        SET_FLAG(input_preferences->modifiers,_inputmod_interchange_swim_sink, false);
      }
    }

		// d-pad
    float moveStickToDirectionThreshold=0.2;
    if (gamepad.dpad == element || moveThumbstick == element ) {
      setKey(moveLeft,    gamepad.dpad.left.isPressed  || moveThumbstick.xAxis.value < (0-moveStickToDirectionThreshold));
      setKey(moveRight,   gamepad.dpad.right.isPressed || moveThumbstick.xAxis.value > moveStickToDirectionThreshold );
      setKey(moveBack,    gamepad.dpad.down.isPressed  || moveThumbstick.yAxis.value < (0-moveStickToDirectionThreshold) );
      setKey(moveForward, gamepad.dpad.up.isPressed    || moveThumbstick.yAxis.value > moveStickToDirectionThreshold );
    
    }
    
    if ([[GameViewController sharedInstance] mode] == GameMode) {
      //
      if( playerInTerminal() || !getLocalPlayer() ) {
        setKey(SDL_SCANCODE_ESCAPE, gamepad.leftShoulder.isPressed);
      } else {
        setKey(SDL_SCANCODE_ESCAPE, 0); //We don't want to get stuck in escape!
        setKey(runKey, !(gamepad.leftShoulder.isPressed));
      }
    }
    
    
    //Look stick
    float rX = lookThumbstick.xAxis.value;
    float rY = lookThumbstick.yAxis.value;
    float arbitraryConstant=14; 

    rightXAxis = rX * arbitraryConstant;
    rightYAxis = 0.0 - rY * arbitraryConstant;
    

    //NSLog(@"Controller thing: %@", message);

   // [[self mainController]  setControllerPausedHandler: ^(GCController *controller) {
   //   NSLog(@"Controller PAUSE!");
   // } ];
    
  };
    
}

@end
