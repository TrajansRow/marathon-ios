/*
 *  AlephOneShell.cpp
 *  AlephOne
 *
 *  Created by Daniel Blezek on 9/1/10.
 *  Copyright 2010 SDG Productions. All rights reserved.
 *
 */

#include "AlephOneShell.h"


#include "cseries.h"

#include "map.h"
#include "monsters.h"
#include "player.h"
#include "render.h"
#include "shell.h"
#include "interface.h"
#include "SoundManager.h"
#include "fades.h"
#include "screen.h"
#include "Music.h"
#include "images.h"
#include "vbl.h"
#include "preferences.h"
#include "tags.h" /* for scenario file type.. */
//Still needed for iOS 6-19-24?#include "network_sound.h"
#include "mouse.h"
#include "screen_drawing.h"
#include "computer_interface.h"
#include "game_wad.h" /* yuck... */
#include "game_window.h" /* for draw_interface() */
#include "extensions.h"
#include "items.h"
#include "interface_menus.h"
#include "weapons.h"
#ifdef HAVE_LUA
#include "lua_script.h"
#endif

#include "Crosshairs.h"
#include "OGL_Render.h"
#include "FileHandler.h"
#include "Plugins.h"

#include "mytm.h"       // mytm_initialize(), for platform-specific shell_*.h

#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include <sstream>
#include <boost/lexical_cast.hpp>

#include "resource_manager.h"
#include "sdl_dialogs.h"
#include "sdl_fonts.h"
#include "sdl_widgets.h"

#include "TextStrings.h"

#ifdef HAVE_CONFIG_H
#include "confpaths.h"
#endif

#include <ctime>
#include <exception>
#include <algorithm>
#include <vector>

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_OPENGL
#include "OGL_Headers.h"
#endif

#ifdef HAVE_SDL_NET_H
#include <SDL_net.h>
#endif

#ifdef HAVE_PNG
#include "IMG_savepng.h"
#endif

#ifdef HAVE_SDL_IMAGE
#include "SDL2/SDL_image.h"
#if defined(__WIN32__)
#include "alephone32.xpm"
#elif !(defined(__APPLE__) && defined(__MACH__)) && !defined(__MACOS__)
#include "alephone.xpm"
#endif
#endif

#ifdef __WIN32__
#include <windows.h>
#endif

#include "alephversion.h"

#include "Logging.h"
#include "network.h"
#include "Console.h"

extern void process_event(const SDL_Event &event);
extern void execute_timer_tasks(uint32 time);


void initialize_application(void);
void AlephOneInitialize() {
  initialize_application();
}

static uint32 lastTimeThroughLoop = 0;

// Unlike the original, we just want to run one pass through.  Leave the scheduling to
// CADisplayLink
const uint32 TICKS_BETWEEN_EVENT_POLL = 167; // 6 Hz
void AlephOneMainLoop()
{
  uint32 last_event_poll = 0;
  short game_state;
  
	uint32 cur_time = machine_tick_count();
	bool yield_time = false;
	bool poll_event = false;

	switch (game_state) {
		case _game_in_progress:
		case _change_level:
			if ((get_fps_target() == 0 && get_keyboard_controller_status()) || Console::instance()->input_active() || cur_time - last_event_poll >= TICKS_BETWEEN_EVENT_POLL) {
				poll_event = true;
				last_event_poll = cur_time;
			} else {
				SDL_PumpEvents ();	// This ensures a responsive keyboard control
			}
			break;

		case _display_intro_screens:
		case _display_main_menu:
		case _display_chapter_heading:
		case _display_prologue:
		case _display_epilogue:
		case _begin_display_of_epilogue:
		case _display_credits:
		case _display_intro_screens_for_demo:
		case _display_quit_screens:
		case _displaying_network_game_dialogs:
			yield_time = interface_fade_finished();
			poll_event = true;
			break;

		case _close_game:
		case _switch_demo:
		case _revert_game:
			yield_time = poll_event = true;
			break;
	}

	if (poll_event) {
		global_idle_proc();

		SDL_Event event;
		if (yield_time)
		{
			// The game is not in a "hot" state, yield time to other
			// processes but only try for a maximum of 30ms
	/*		if (SDL_WaitEventTimeout(&event, 30))
			{
				process_event(event);
			} This SDL_WaitEventTimeout() is causing slow framerates on Release builds on iOS. Not sure why yet. */
			//TODO: Figure this out
		}

		while (SDL_PollEvent(&event))
		{
			process_event(event);
		}

#ifdef HAVE_STEAM
		while (auto steam_event = STEAMSHIM_pump()) {
			switch (steam_event->type) {
				case SHIMEVENT_ISOVERLAYACTIVATED:
					if (steam_event->okay && get_game_state() == _game_in_progress && !game_is_networked)
					{
						pause_game();
					}
					break;

				default:
					break;
			}
		}
#endif
	}

	execute_timer_tasks(machine_tick_count());
	idle_game_state(machine_tick_count());

	auto fps_target = get_fps_target();
	if (!get_keyboard_controller_status())
	{
		fps_target = 30;
	}

	if (game_state == _game_in_progress && fps_target != 0)
	{
		int elapsed_machine_ticks = machine_tick_count() - cur_time;
		int desired_elapsed_machine_ticks = MACHINE_TICKS_PER_SECOND / fps_target;

		if (desired_elapsed_machine_ticks - elapsed_machine_ticks > desired_elapsed_machine_ticks / 3)
		{
			sleep_for_machine_ticks(1);
		}
	}
	else if (game_state != _game_in_progress)
	{
		static auto last_redraw = 0;
		if (machine_tick_count() > last_redraw + TICKS_PER_SECOND / 30)
		{
			update_game_window();
			last_redraw = machine_tick_count();
		}
	}

}

