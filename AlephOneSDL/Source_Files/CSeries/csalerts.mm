/*

	Copyright (C) 2010 and beyond by Gregory Smith
	and the "Aleph One" developers.
 
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	This license is contained in the file "COPYING",
	which is included with this source code; it is available online at
	http://www.gnu.org/licenses/gpl.html

*/

#ifdef __APPLE__
		#include "TargetConditionals.h"
		#ifdef TARGET_OS_IOS
			#import <UIKit/UIKit.h>
		#else
			#import <Cocoa/Cocoa.h>
		#endif
#endif
#include "cstypes.h"
#include "csalerts.h"

void system_alert_user(const char* message, short severity)
{
#ifdef TARGET_OS_IOS
	//NOT IMPLEMENTED!
#else
	NSAlert *alert = [NSAlert new];
	if (severity == infoError) 
	{
		[alert setMessageText: @"Warning"];
		[alert setAlertStyle: NSWarningAlertStyle];
	}
	else
	{
		[alert setMessageText: @"Error"];
		[alert setAlertStyle: NSCriticalAlertStyle];
	}
	[alert setInformativeText: [NSString stringWithUTF8String: message]];
	[alert runModal];
	[alert release];
#endif
}

bool system_alert_choose_scenario(char *chosen_dir)
{
#ifdef TARGET_OS_IOS
	//NOT IMPLEMENTED!
	return 0;
#else
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:NO];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO];
	[panel setTitle:@"Choose Scenario"];
	[panel setMessage:@"Select a scenario to play:"];
	[panel setPrompt:@"Choose"];
	
	if (!chosen_dir)
		return false;
	
	if ([panel runModal] != NSFileHandlingPanelOKButton)
		return false;
	
	return [[[panel URL] path] getCString:chosen_dir maxLength:256 encoding:NSUTF8StringEncoding];
#endif
}

void system_launch_url_in_browser(const char *url)
{
#ifdef TARGET_OS_IOS
	//NOT IMPLEMENTED!
#else
	NSURL *urlref = [NSURL URLWithString:[NSString stringWithUTF8String:url]];
	[[NSWorkspace sharedWorkspace] openURL:urlref];
#endif
}
