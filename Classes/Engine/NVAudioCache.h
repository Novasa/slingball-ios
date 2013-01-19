//
//  SoundManager.h
//  SLQTSOR
//
//  Created by Michael Daley on 22/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

// SoundManager provides a basic wrapper for OpenAL and AVAudioPlayer.  It is a singleton
// class that allows sound clips to be loaded and cached with a key and then played back
// using that key.  It also allows for music tracks to be played, stopped and paused
//
@interface NVAudioCache : NSObject {
	ALCcontext *context;				// Context in which all sounds will be played
	ALCdevice *device;					// Reference to the device to use when playing sounds
	NSMutableArray *soundSources;		// Mutable array of all sound sources
	NSMutableDictionary *soundLibrary;	// Dictionary of all sounds loaded and their keys
	NSMutableDictionary *musicLibrary;	// Dictionary of all music/ambient sounds loaded and their keys
	AVAudioPlayer *musicPlayer;			// Instance of AVAudio player that is used to play background/ambient sounds
	ALfloat musicVolume;				// Volume of music/ambient sounds
	ALfloat fxVolume;					// Volume of OpenGL sound effects
	CGPoint listenerPosition;			// Location of the OpenAL Listener
    ALenum alError;						// Any OpenAL errors that are rasied
}

@property (nonatomic, assign) ALfloat musicVolume;
@property (nonatomic, assign) ALfloat fxVolume;

// Returns as instance of the SoundManager class.  If an instance has already been created
// then this instance is returned, otherwise a new instance is created and returned.
+ (NVAudioCache*) sharedCache;

// Designated initializer.
- (id)init;

// Plays the sound which is found with |aSoundKey| using the provided |aGain| and |aPitch|.
// |aLocation| is used to set the location of the sound source in relation to the listener
// and |aLoop| specifies if the sound should be continuously looped or not.
- (NSUInteger)playSoundWithKey:(NSString*)aSoundKey gain:(ALfloat)aGain pitch:(ALfloat)aPitch 
                       location:(CGPoint)aLocation shouldLoop:(BOOL)aLoop sourceID:(NSUInteger)aSourceID;

// Loads a sound with the supplied key, filename, file extension and frequency.  Frequency
// could be worked out from the file but this implementation takes it as an argument. If no
// sound is found with a matching key then nothing happens.
- (void)loadSoundWithKey:(NSString*)aSoundKey musicFile:(NSString*)aMusicFile;

// Removes the sound with the supplied key from the sound library.  This deletes the buffer that was created
// to hold the sound
- (void)removeSoundWithKey:(NSString*)aSoundKey;

// Plays the music with the supplied key.  If no music is found then nothing happens.
// |aRepeatCount| specifies the number of times the music should loop.
- (void)playMusicWithKey:(NSString*)aMusicKey timesToRepeat:(NSUInteger)aRepeatCount;

// Loads the path of a music files into a dictionary with the a key of |aMusicKey|
- (void)loadBackgroundMusicWithKey:(NSString*)aMusicKey musicFile:(NSString*)aMusicFile;

// Removes the path to the music file with the matching key from the music library array.
- (void)removeBackgroundMusicWithKey:(NSString*)aMusicKey;

// Stops any currently playing music.
- (void)stopMusic;

// Pauses any currently playing music.
- (void)pauseMusic;

// Resumes music that has been paused
- (void)resumeMusic;

// Shutsdown the SoundManager class and deallocates resources which have been assigned.
- (void)shutdownSoundManager;

#pragma mark -
#pragma mark SoundManager settings

// Set the volume for music which is played.
- (void)setMusicVolume:(ALfloat)aVolume;

// Sets the location of the OpenAL listener.
- (void)setListenerPosition:(CGPoint)aPosition;

// Sets the orientation of the listener.  This is used to make sure that sound
// is played correctly based on the direction the player is moving in
- (void)setOrientation:(CGPoint)aPosition;

// Sets the volume for all sounds which are played.  This acts as a global FX volume for
// all sounds.
- (void)setFxVolume:(ALfloat)aVolume;

@end
