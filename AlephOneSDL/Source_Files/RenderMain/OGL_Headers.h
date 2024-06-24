#ifndef _OGL_HEADERS_
#define _OGL_HEADERS_

/*

	Copyright (C) 2009 by Gregory Smith
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

	Uniform header for all Aleph One OpenGL users
*/

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#ifdef HAVE_OPENGL

#ifdef __WIN32__
#include <glad/glad.h>
#else

#ifdef __APPLE__
#ifndef GL_GLEXT_PROTOTYPES
#define GL_GLEXT_PROTOTYPES 1
#endif

#include "SDL2/SDL_opengl.h"

	//DCW
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES3/gl.h>
typedef double GLdouble; //DCW Not defined in GLES
typedef double GLclampd;  //DCW Not defined in GLES
#include "SDL2/SDL_opengl_glext.h" //DCW
#include "SDL2/SDL_opengles.h"
#endif

#ifndef __APPLE__
#include <SDL2/SDL_opengles2.h>
#endif

#endif

#endif

#endif
