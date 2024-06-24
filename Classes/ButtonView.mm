//
//  ButtonView.mm
//  AlephOne
//
//  Created by Daniel Blezek on 8/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButtonView.h"
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

@implementation ButtonView

- (void)setup:(SDL_Keycode)k {
  key = k;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for ( UITouch *touch in [event touchesForView:self] ) {
    setKey(key, 1);
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {  
  for ( UITouch *touch in [event touchesForView:self] ) {
    // NSLog(@"Touch ended in fire button");
    setKey(key, 0);
    
  }
  return;
  
}


- (void)dealloc {
  // Kill a warning
	//Still needed for iOS 6-19-24?(void)all_key_definitions;
  [super dealloc];
}


@end
