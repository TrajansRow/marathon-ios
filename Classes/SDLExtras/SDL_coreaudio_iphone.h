/*
    SDL - Simple DirectMedia Layer
    Copyright (C) 1997-2010 Sam Lantinga

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

    Sam Lantinga
    slouken@libsdl.org
*/
#include "SDL_config.h"

#ifndef _SDL_coreaudio_h
#define _SDL_coreaudio_h

#include "SDL_sysaudio.h"

/* Hidden "this" pointer for the audio functions */
#define _THIS	SDL_AudioDevice *this

#define USE_AUDIOQUEUE 1

#if defined ( USE_AUDIOQUEUE )

#include <AudioToolbox/AudioToolbox.h>

#define kNumberBuffers 3

typedef struct SDL_PrivateAudioData {
  
  AudioStreamBasicDescription   mDataFormat;                    // 2
  
  AudioQueueRef                 mQueue;                         // 3
  
  AudioQueueBufferRef           mBuffers[kNumberBuffers];       // 4
  
  AudioFileID                   mAudioFile;                     // 5
  
  /* UInt32                        bufferByteSize;                 // 6 */
  
  SInt64                        mCurrentPacket;                 // 7
  
  UInt32                        mNumPacketsToRead;              // 8
  
  AudioStreamPacketDescription  *mPacketDescs;                  // 9
  
  bool                          mIsRunning;                     // 10
  AudioUnit audioUnit;
  int audioUnitOpened;
 
  void *buffer;
  UInt32 bufferOffset;
  UInt32 bufferSize;   
} SDL_PrivateAudioData;

#else
struct SDL_PrivateAudioData
{
  AudioUnit audioUnit;
  int audioUnitOpened;
  void *buffer;
  UInt32 bufferOffset;
  UInt32 bufferSize;
  //  AudioDeviceID deviceID;
};

#endif

#endif /* _SDL_coreaudio_h */
/* vi: set ts=4 sw=4 expandtab: */
