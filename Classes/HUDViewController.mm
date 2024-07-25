//
//  HUDViewController.m
//  AlephOne
//
//  Created by Daniel Blezek on 7/19/11.
//  Copyright 2011 SDG Productions. All rights reserved.
//

#import "HUDViewController.h"

#import "AlephOneAppDelegate.h"
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

@implementation HUDViewController
@synthesize primaryFireKey, secondaryFireKey, lookingAtRefuel, lookPadView, netStats;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
			forwardKey = findKeyCodeInPrefs(_moving_forward);
			backwardKey = findKeyCodeInPrefs(_moving_backward);
			leftKey = findKeyCodeInPrefs(_sidestepping_left);
			rightKey = findKeyCodeInPrefs(_sidestepping_right);
			runKey = findKeyCodeInPrefs(_run_dont_walk);
			primaryFireKey = findKeyCodeInPrefs(_left_trigger_state);
			secondaryFireKey = findKeyCodeInPrefs(_right_trigger_state);
			mapKey = findKeyCodeInPrefs(_toggle_map);
			actionKey	= findKeyCodeInPrefs(_action_trigger_state);
			nextWeaponKey = findKeyCodeInPrefs(_cycle_weapons_forward);
			previousWeaponKey = findKeyCodeInPrefs(_cycle_weapons_backward);
			lookUpKey = findKeyCodeInPrefs(_looking_up);
			lookDownKey = findKeyCodeInPrefs(_looking_down);
			lookLeftKey = findKeyCodeInPrefs(_looking_left);
			lookRightKey = findKeyCodeInPrefs(_looking_right);
			consoleKey = findKeyCodeInPrefs(_key_activate_console);
    }
    return self;
}

// Noops
- (void)dimActionKey {}
- (void)lightActionKeyWithTarget:(short)target_type objectIndex:(short)object_index {}
- (void)updateSwimmingIndicator {}
- (void)updateEscapeButtonVisibility {}

- (void)mouseDeltaX:(int*)dx deltaY:(int*)dy {
  *dx = 0; *dy = 0;
}

- (IBAction)stopMoving:(id)sender {
  [self forwardUp:nil];
  [self backwardUp:nil];
  [self leftUp:nil];
  [self rightUp:nil];
}
- (IBAction)stopLooking:(id)sender {
  [self lookUpUp:nil];
  [self lookDownUp:nil];
  [self lookLeftUp:nil];
  [self lookRightUp:nil];
}
- (IBAction)primaryFireDown:(id)sender {
  setKey(primaryFireKey, 1);
}
- (IBAction)primaryFireUp:(id)sender {
  setKey(primaryFireKey, 0);

}
- (IBAction)secondaryFireDown:(id)sender {
  setKey(secondaryFireKey, 1);
}
- (IBAction)secondaryFireUp:(id)sender {
  setKey(secondaryFireKey, 0);
}
- (IBAction)nextWeaponDown:(id)sender {
  setKey(nextWeaponKey, 1);
}
- (IBAction)nextWeaponUp:(id)sender {
  setKey(nextWeaponKey, 0);
}
- (IBAction)doNextWeapon:(id)sender{
  [self nextWeaponDown:self];
  [self performSelector:@selector(nextWeaponUp:) withObject:self afterDelay:0.10];
}
- (IBAction)previousWeaponDown:(id)sender {
  setKey(previousWeaponKey, 1);
}
- (IBAction)previousWeaponUp:(id)sender {
  setKey(previousWeaponKey, 0);
}
- (IBAction)doPreviousWeapon:(id)sender{
  [self previousWeaponDown:self];
  [self performSelector:@selector(previousWeaponUp:) withObject:self afterDelay:0.10];
}
- (IBAction)inventoryDown:(id)sender {
  setKey(inventoryKey, 1);
}
- (IBAction)inventoryUp:(id)sender {
  setKey(inventoryKey, 0);
}
- (IBAction)doAction:(id)sender {
    //Pause gyro if in refuel.
  if ([[GameViewController sharedInstance].HUDViewController lookingAtRefuel]){
    [[GameViewController sharedInstance].HUDViewController.lookPadView pauseGyro];
    
    [self performSelector:@selector(actionDown:) withObject:self afterDelay:0.05];
  } else {
    [self actionDown:self];
  }
  [self performSelector:@selector(actionUp:) withObject:self afterDelay:0.15];
}
- (IBAction)actionDown:(id)sender {
  setKey(actionKey, 1);
}
- (IBAction)actionUp:(id)sender {
  setKey(actionKey, 0);
}
- (IBAction)forwardDown:(id)sender {
  setKey(forwardKey, 1);
}
- (IBAction)forwardUp:(id)sender {
  setKey(forwardKey, 0);
}
- (IBAction)backwardDown:(id)sender {
  setKey(backwardKey, 1);
}
- (IBAction)backwardUp:(id)sender {
  setKey(backwardKey, 0);
}
- (IBAction)leftDown:(id)sender {
  setKey(leftKey, 1);
}
- (IBAction)leftUp:(id)sender {
  setKey(leftKey, 0);
}
- (IBAction)rightDown:(id)sender {
  setKey(rightKey, 1);
}
- (IBAction)rightUp:(id)sender {
  setKey(rightKey, 0);
}
- (IBAction)runDown:(id)sender {
  setKey(runKey, 1);
}
- (IBAction)runUp:(id)sender {
  setKey(runKey, 0);
}
- (IBAction)mapDown:(id)sender {
  setKey(mapKey, 1);
}
- (IBAction)mapUp:(id)sender {
  setKey(mapKey, 0);
}

- (IBAction)doMap:(id)sender{
  [self mapDown:self];
  [self performSelector:@selector(mapUp:) withObject:self afterDelay:0.10];
}

- (IBAction)consoleDown:(id)sender {
  //setKey(consoleKey, 1);
}
- (IBAction)consoleUp:(id)sender{
  //setKey(consoleKey, 0);
  
  SDL_Event enter, unenter;
  enter.type = SDL_KEYDOWN;
  SDL_utf8strlcpy(enter.text.text, "\\", SDL_arraysize(enter.text.text));
  enter.key.keysym.sym=SDLK_BACKSLASH;
  SDL_PushEvent(&enter);
  unenter.type = SDL_KEYUP;
  SDL_utf8strlcpy(unenter.text.text, "\\", SDL_arraysize(unenter.text.text));
  unenter.key.keysym.sym=SDLK_BACKSLASH;
  SDL_PushEvent(&unenter);

}

- (IBAction)escapeDown:(id)sender {
	setKey(SDL_SCANCODE_ESCAPE, 1);
}
- (IBAction)escapeUp:(id)sender{
  setKey(SDL_SCANCODE_ESCAPE, 0);
}

- (IBAction)netStatsDown:(id)sender {
  SDL_Event stats, unstats;
  stats.type = SDL_KEYDOWN;
  SDL_utf8strlcpy(stats.text.text, "1", SDL_arraysize(stats.text.text));
  stats.key.keysym.sym=SDLK_1;
  SDL_PushEvent(&stats);
}
- (IBAction)netStatsUp:(id)sender{
  SDL_Event stats, unstats;
  unstats.type = SDL_KEYUP;
  SDL_utf8strlcpy(unstats.text.text, "1", SDL_arraysize(unstats.text.text));
  unstats.key.keysym.sym=SDLK_1;
  SDL_PushEvent(&unstats);
}

- (IBAction)doConsole:(id)sender{
  [self consoleDown:self];
  [self performSelector:@selector(consoleUp:) withObject:self afterDelay:0.10];
}

- (IBAction)doEscape:(id)sender{
  [self escapeDown:self];
  [self performSelector:@selector(escapeUp:) withObject:self afterDelay:0.10];
}

- (IBAction)doNetStats:(id)sender{
  [self netStatsDown:self];
  [self performSelector:@selector(netStatsUp:) withObject:self afterDelay:0.10];
}

// Looking
- (IBAction)lookUpDown:(id)sender {
  setKey(lookUpKey, 1);
}
- (IBAction)lookUpUp:(id)sender {
  setKey(lookUpKey, 0);
}
- (IBAction)lookDownDown:(id)sender {
  setKey(lookDownKey, 1);
}
- (IBAction)lookDownUp:(id)sender {
  setKey(lookDownKey, 0);
}
- (IBAction)lookLeftDown:(id)sender {
  setKey(lookLeftKey, 1);
}
- (IBAction)lookLeftUp:(id)sender {
  setKey(lookLeftKey, 0);
}
- (IBAction)lookRightDown:(id)sender {
  setKey(lookRightKey, 1);
}
- (IBAction)lookRightUp:(id)sender {
  setKey(lookRightKey, 0);
}

- (void)dimActionKey:(short)actionType {}
- (void)lightActionKey:(short)actionType {}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [netStats setHidden: ![[AlephOneAppDelegate sharedAppDelegate] gameIsNetworked]];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
