//
//  JoyPad.m
//  AlephOne
//
//  Created by Daniel Blezek on 6/28/11.
//  Copyright 2011 SDG Productions. All rights reserved.
//

#import "JoyPad.h"
#import "JoypadXIBConfigure.h"
extern "C" { 
#include "SDL_keyboard_c.h"
#include "SDL_keyboard.h"
#include "SDL_stdinc.h"
#include "SDL_mouse_c.h"
#include "SDL_mouse.h"
#include "SDL_events.h"
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

#import "AlephOneHelper.h"

static int counter = 0;
@implementation JoyPad
@synthesize findingDevice;
@synthesize connectedWithDevice;

-(id)init {

  self = [super init];
  
  if (self != nil) {
    buttonMap = [[NSArray arrayWithObjects:@"kJoyInputDpad1",
                  @"kJoyInputDpad2",
                  @"kJoyInputAnalogStick1",
                  @"kJoyInputAnalogStick2",
                  @"kJoyInputAccelerometer",
                  @"kJoyInputWheel",
                  @"kJoyInputAButton",
                  @"kJoyInputBButton",
                  @"kJoyInputCButton",
                  @"kJoyInputXButton",
                  @"kJoyInputYButton",
                  @"kJoyInputZButton",
                  @"kJoyInputSelectButton",
                  @"kJoyInputStartButton",
                  @"kJoyInputLButton",
                  @"kJoyInputRButton",
                  nil] retain];
    joypadManager = [[JoypadManager alloc] init];
    [joypadManager setDelegate:self];
    
    // Create custom layout.
    JoypadXIBConfigure* config = [[JoypadXIBConfigure alloc] init];

    JoypadControllerLayout *customLayout = [config configureLayout:@"DualAnalogSticks"];
    [joypadManager useCustomLayout:customLayout];
    [customLayout release];
    [config release];
    
		forwardKey = findKeyCodeInPrefs(_moving_forward);
		backwardKey = findKeyCodeInPrefs(_moving_backward);
		leftKey = findKeyCodeInPrefs(_sidestepping_left);
		rightKey = findKeyCodeInPrefs(_sidestepping_right);
		runKey = findKeyCodeInPrefs(_run_dont_walk);
		primaryFire = findKeyCodeInPrefs(_left_trigger_state);
		secondaryFire = findKeyCodeInPrefs(_right_trigger_state);
		mapKey = findKeyCodeInPrefs(_toggle_map);
		actionKey	= findKeyCodeInPrefs(_action_trigger_state);
		nextWeapon = findKeyCodeInPrefs(_cycle_weapons_forward);
		previousWeapon = findKeyCodeInPrefs(_cycle_weapons_backward);
		
    findingDevice = NO;
    connectedWithDevice = NO;
  }
  return self;
}

-(void)startFindingDevices {
  // Start finding devices running Joypad.
  [joypadManager startFindingDevices];
  findingDevice = YES;
}

-(void)stopFindingDevices {
  [joypadManager stopFindingDevices];
  findingDevice = NO;
}

-(void)joypadManager:(JoypadManager *)manager didFindDevice:(JoypadDevice *)device previouslyConnected:(BOOL)prev
{
  NSLog(@"Found a device running Joypad!  Stopping the search and connecting to it.");
  [manager stopFindingDevices];
  [manager connectToDevice:device asPlayer:1];
  findingDevice = NO;
  connectedWithDevice = YES;
}

-(void)joypadManager:(JoypadManager *)manager didLoseDevice:(JoypadDevice *)device
{
  NSLog(@"Lost a device");
  connectedWithDevice = NO;
}

-(void)joypadManager:(JoypadManager *)manager deviceDidConnect:(JoypadDevice *)device player:(unsigned int)player
{
  NSLog(@"Device connected as player: %i!", player);
  [device setDelegate:self];
  connectedWithDevice = YES;
}

-(void)joypadManager:(JoypadManager *)manager deviceDidDisconnect:(JoypadDevice *)device player:(unsigned int)player
{
  NSLog(@"Player %i disconnected.", player);
  if ( player == 1 ) {
    connectedWithDevice = NO;
  }
}

-(void)setButtonState:(JoyInputIdentifier)button toState:(int)state {
  //Uint8 *key_map = SDL_GetKeyboardState ( NULL );
  if ( state ) {
    NSLog(@"Button %@ is down", [buttonMap objectAtIndex:button]);
  } else {
    NSLog(@"Button %@ is up", [buttonMap objectAtIndex:button]);    
  }
  switch (button) {
    case kJoyInputAButton:
      setKe[primaryFire] = state;
      break;
    case kJoyInputBButton:
      fake_key_map[secondaryFire] = state;
      break;
    case kJoyInputXButton:
      fake_key_map[mapKey] = state;
      break;
    case kJoyInputYButton:
      fake_key_map[actionKey] = state;
      break;
    case kJoyInputRButton:
      fake_key_map[nextWeapon] = state;
      break;
    case kJoyInputLButton:
      fake_key_map[previousWeapon] = state;
      break;
    case kJoyInputStartButton:
      // Pause...
      break;
    default:
      break;
  }
}

-(void)setButtonsToState:(int)state {
  [self setButtonState:kJoyInputAButton toState:state];
  [self setButtonState:kJoyInputBButton toState:state];
  [self setButtonState:kJoyInputXButton toState:state];
  [self setButtonState:kJoyInputYButton toState:state];
  [self setButtonState:kJoyInputRButton toState:state];
  [self setButtonState:kJoyInputLButton toState:state];
  [self setButtonState:kJoyInputStartButton toState:state];
}


-(void)joypadDevice:(JoypadDevice *)device buttonDown:(JoyInputIdentifier)button {
  [self setButtonState:button toState:1];
}

-(void)joypadDevice:(JoypadDevice *)device buttonUp:(JoyInputIdentifier)button
{
  [self setButtonState:button toState:0];
}

-(void)joypadDevice:(JoypadDevice *)device analogStick:(JoyInputIdentifier)stick didMove:(JoypadStickPosition)newPosition
{
  NSLog(@"Analog stick distance: %f, angle (rad): %f", newPosition.distance, newPosition.angle);
}


-(void)joypadDevice:(JoypadDevice *)device dPad:(JoyInputIdentifier)dpad buttonUp:(JoyDpadButton)dpadButton
{
  NSLog(@"Dpad %@ button %@ is up!", [buttonMap objectAtIndex:dpad], [buttonMap objectAtIndex:dpadButton] );
}

-(void)joypadDevice:(JoypadDevice *)device dPad:(JoyInputIdentifier)dpad buttonDown:(JoyDpadButton)dpadButton
{
  NSLog(@"Dpad %@ button %@ is down!", [buttonMap objectAtIndex:dpad], [buttonMap objectAtIndex:dpadButton] );
}

-(void)joypadDevice:(JoypadDevice *)device didAccelerate:(JoypadAcceleration)accel {
}

@end
