//
//  SoundManager.m
//  SLQTSOR
//
//  Created by Michael Daley on 22/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "NVAudioCache.h"

#import "SynthesizeSingleton.h"
#import "NVAudioSupport.h"

#pragma mark -
#pragma mark Private interface

@interface NVAudioCache (Private)

// This method is used to initialize OpenAL.  It gets the default device, creates a new context 
// to be used and then preloads the define # sources.  This preloading means we wil be able to play up to
// (max 32) different sounds at the same time
- (BOOL)initOpenAL;

// Used to get the next available OpenAL source.  The returned source is then bound to a sound
// buffer so that the sound can be played.  This method checks each of the available OpenAL 
// soucres which have been generated and returns the first source which is not currently being
// used.  If no sources are found to be free then the first looping source is returned.  If there
// are no looping sources then the first source created is returned
- (NSUInteger)nextAvailableSource;

// Used to set the current state of OpenAL.  When the game is interrupted the OpenAL state is
// stopped and then restarted when the game becomes active again.
- (void)setActivated:(BOOL)aState;

@end


#pragma mark -
#pragma mark Public implementation

@implementation NVAudioCache

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(NVAudioCache, Cache);

@synthesize musicVolume;
@synthesize fxVolume;

#pragma mark -
#pragma mark Interruption listener

// Method which handles an interruption message from the audio session.  It reacts to the
// type of interruption state i.e. beginInterruption or endInterruption
void interruptionListener(void *inClientData, UInt32 inInterruptionState) {
	NVAudioCache *soundManager = [NVAudioCache sharedCache];
    
    if (inInterruptionState == kAudioSessionBeginInterruption) {
        [soundManager setActivated:NO];
	} else if (inInterruptionState == kAudioSessionEndInterruption) {
		OSStatus result = AudioSessionSetActive(true);
		if (result) printf("SOUND: ERROR - Failed setting audio session active %ld", result);
        [soundManager setActivated:YES];
	}
}

#pragma mark -
#pragma mark Dealloc and Init and Shutdown

- (void)dealloc {
	// Loop through the OpenAL sources and delete them
	for(NSNumber *sourceIDVal in soundSources) {
		NSUInteger sourceID = [sourceIDVal unsignedIntValue];
		alDeleteSources(1, &sourceID);
	}
	
	// Loop through the OpenAL buffers and delete 
	NSEnumerator *enumerator = [soundLibrary keyEnumerator];
	id key;
	while ((key = [enumerator nextObject])) {
		NSNumber *bufferIDVal = [soundLibrary objectForKey:key];
		NSUInteger bufferID = [bufferIDVal unsignedIntValue];
		alDeleteBuffers(1, &bufferID);		
	}
    
	// Release the arrays and dictionaries we have been using
	[soundLibrary release];
	[soundSources release];
	[musicLibrary release];
	
	// If background music has been played then release the AVAudioPlayer
	if(musicPlayer)
		[musicPlayer release];
	
	// Disable and then destroy the context
	alcMakeContextCurrent(NULL);
	alcDestroyContext(context);
	
	// Close the device
	alcCloseDevice(device);
	
	[super dealloc];
}


- (id)init {
    self = [super init];
	if(self != nil) {

		// Register to be notified of both the UIApplicationWillResignActive and UIApplicationDidBecomeActive.
		// Set up notifications that will let us know if the application resigns being active or becomes active
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) 
                                                     name:@"UIApplicationWillResignActiveNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) 
                                                     name:@"UIApplicationDidBecomeActiveNotification" object:nil];
		
        // Initialize the array and dictionaries we are going to use
		soundSources = [[NSMutableArray alloc] init];
		soundLibrary = [[NSMutableDictionary alloc] init];
		musicLibrary = [[NSMutableDictionary alloc] init];
		
		// Initialize the audio session and set its audio category to ambient sound.
		OSStatus result = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
		if (result) {
            Debug((@"SOUND: ERROR - Error initializing audio session! %d\n", result));
        } else {
			UInt32 category = kAudioSessionCategory_SoloAmbientSound;
			result = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
			if (result) {
                Debug((@"SOUND: ERROR - Error setting audio session category! %d\n", result));
			} else {
				result = AudioSessionSetActive(true);
				if (result) {
                    Debug((@"SOUND: ERROR - Error setting audio session active! %d\n", result));
                }
			}
		}
		
        // Set up the OpenAL.  If an error occurs then nil will be returned.
		BOOL success = [self initOpenAL];
		if(!success) {
            Debug((@"SOUND: ERROR - Error initializing OpenAL"));
            [self release];
            return nil;
        }
		
		// Set up the listener position
		ALfloat listener_pos[] = {0, 0, 0};
		ALfloat listener_ori[] = {0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
		ALfloat listener_vel[] = {0, 0, 0};
		
		alListenerfv(AL_POSITION, listener_pos);
		alListenerfv(AL_ORIENTATION, listener_ori);
		alListenerfv(AL_VELOCITY, listener_vel);
        
        // Set the default volume for music and sound FX
		musicVolume = 0.5f;
		fxVolume = 0.5f;
	}
    return self;
}

- (void)shutdownSoundManager {
	@synchronized(self) {
		if(sharedCache != nil) {
			[self dealloc];
		}
	}
}

#pragma mark -
#pragma mark Sound management

- (void)loadSoundWithKey:(NSString*)aSoundKey musicFile:(NSString*)aMusicFile {

    // Check to make sure that a sound with the same key does not already exist
    NSNumber *numVal = [soundLibrary objectForKey:aSoundKey];
    
    // If the key is not found log it and finish
    if(numVal != nil) {
        Debug((@"SOUND: WARNING - Sound key '%@' already exists.", aSoundKey));
        return;
    }
    
    NSUInteger bufferID;
	
	// Generate a buffer within OpenAL for this sound
	alGenBuffers(1, &bufferID);
    
    // Set up the variables which are going to be used to hold the format
    // size and frequency of the sound file we are loading
	ALenum  format;
	ALsizei size;
	ALsizei freq;
	ALvoid *data;
	alError = AL_NO_ERROR;
    
	NSBundle *bundle = [NSBundle mainBundle];
	
	// Get the audio data from the file which has been passed in
	NSString *fileName = [[aMusicFile lastPathComponent] stringByDeletingPathExtension];
	NSString *fileType = [aMusicFile pathExtension];
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:fileName ofType:fileType]] retain];
	
	if (fileURL)
	{	
		data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
		CFRelease(fileURL);
		
		if((alError = alGetError()) != AL_NO_ERROR) {
			Debug((@"SOUND: ERROR - Error loading sound: %@ with error %x\n", fileName, alError));
			exit(1);
		}
		
		// Use the static buffer data API
		alBufferData(bufferID, format, data, size, freq);
		
		if((alError = alGetError()) != AL_NO_ERROR) {
			Debug((@"SOUND: ERROR - Error attaching audio to buffer: %x\n", alError));
		}
		
		// Free the memory we used when getting the audio data
		if (data)
			free(data);
	}
	else
	{
		Debug((@"SOUND: ERROR - Could not find file '%@.%@'", fileName, fileType));
	}
	
	// Place the buffer ID into the sound library against |aSoundKey|
	[soundLibrary setObject:[NSNumber numberWithUnsignedInt:bufferID] forKey:aSoundKey];
    Debug((@"SOUND: INFO - Loaded sound with key '%@' into buffer '%d'", aSoundKey, bufferID));
}

- (void)removeSoundWithKey:(NSString*)aSoundKey {
 
	// Reset errors in OpenAL
	alError = alGetError();
	alError = AL_NO_ERROR;

    // Find the buffer which has been linked to the sound key provided
    NSNumber *numVal = [soundLibrary objectForKey:aSoundKey];
    
    // If the key is not found log it and finish
    if(numVal == nil) {
        Debug((@"SOUND: WARNING - No sound with key '%@' was found so cannot be removed", aSoundKey));
        return;
    }
    
    // Get the buffer number from
    NSUInteger bufferID = [numVal unsignedIntValue];
	NSInteger bufferForSource;
	NSInteger sourceState;
	for(NSNumber *sourceID in soundSources) {

		NSUInteger currentSourceID = [sourceID unsignedIntValue];
		
		// Grab the current state of the source and also the buffer attached to it
		alGetSourcei(currentSourceID, AL_SOURCE_STATE, &sourceState);
		alGetSourcei(currentSourceID, AL_BUFFER, &bufferForSource);

		// If this source is not playing then unbind it.  If it is playing and the buffer it
		// is playing is the one we are removing, then also unbind that source from this buffer
		if(sourceState != AL_PLAYING || (sourceState == AL_PLAYING && bufferForSource == bufferID)) {
			alSourceStop(currentSourceID);
			alSourcei(currentSourceID, AL_BUFFER, 0);
		}
	} 
    
	// Delete the buffer
	alDeleteBuffers(1, &bufferID);
	
	// Check for any errors
	if((alError = alGetError()) != AL_NO_ERROR) {
		Debug((@"SOUND: ERROR - Could not delete buffer %d with error %x", bufferID, alError));
		exit(1);
	}
	
	// Remove the soundkey from the soundLibrary
    [soundLibrary removeObjectForKey:aSoundKey];

    Debug((@"SOUND: INFO - Removed sound with key '%@'", aSoundKey));
}


- (void)loadBackgroundMusicWithKey:(NSString*)aMusicKey musicFile:(NSString*)aMusicFile {
	
	// Get the filename and type from the music file name passed in
	NSString *fileName = [[aMusicFile lastPathComponent] stringByDeletingPathExtension];
	NSString *fileType = [aMusicFile pathExtension];
	
    // Check to make sure that a sound with the same key does not already exist
    NSString *path = [musicLibrary objectForKey:aMusicKey];
    
    // If the key is found log it and finish
    if(path != nil) {
        Debug((@"SOUND: WARNING - Music with the key '%@' already exists.", aMusicKey));
        return;
    }
    
	path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
	[musicLibrary setObject:path forKey:aMusicKey];
    Debug((@"SOUND: INFO - Loaded background music with key '%@'", aMusicKey));
}

- (void)removeBackgroundMusicWithKey:(NSString*)aMusicKey {
    NSString *path = [musicLibrary objectForKey:aMusicKey];
    if(path == NULL) {
        Debug((@"SOUND: WARNING - No music found with key '%@' was found so cannot be removed", aMusicKey));
        return;
    }
    [musicLibrary removeObjectForKey:aMusicKey];
    Debug((@"SOUND: INFO - Removed music with key '%@'", aMusicKey));
}

#pragma mark -
#pragma mark Sound control

- (NSUInteger)playSoundWithKey:(NSString*)aSoundKey gain:(ALfloat)aGain pitch:(ALfloat)aPitch location:(CGPoint)aLocation shouldLoop:(BOOL)aLoop sourceID:(NSUInteger)aSourceID {
	
	alError = alGetError(); // clear the error code
	
	// Find the buffer linked to the key which has been passed in
	NSNumber *numVal = [soundLibrary objectForKey:aSoundKey];
	if(numVal == nil) return 0;
	NSUInteger bufferID = [numVal unsignedIntValue];
	
	// Find an available source if -1 has been passed in as the sourceID.  If the sourceID is
    // not -1 i.e. a source ID has been passed in then check to make sure that source is not playing
    // and if not play the identified buffer ID within the provided source
    NSUInteger sourceID;
    if(aSourceID == -1) {
        sourceID = [self nextAvailableSource];
    } else {
        NSInteger sourceState;
        alGetSourcei(aSourceID, AL_SOURCE_STATE, &sourceState);
        if(sourceState == AL_PLAYING)
            return 0;
        sourceID = aSourceID;
    }
	
	// Make sure that the source is clean by resetting the buffer assigned to the source
	// to 0
	alSourcei(sourceID, AL_BUFFER, 0);
    
	// Attach the buffer we have looked up to the source we have just found
	alSourcei(sourceID, AL_BUFFER, bufferID);
	
	// Set the pitch and gain of the source
	alSourcef(sourceID, AL_PITCH, aPitch);
	alSourcef(sourceID, AL_GAIN, aGain * fxVolume);
	
	// Set the looping value
	if(aLoop) {
		alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	} else {
		alSourcei(sourceID, AL_LOOPING, AL_FALSE);
	}
   
	// Set the source location
	alSource3f(sourceID, AL_POSITION, aLocation.x, aLocation.y, 0.0f);
	
	// Now play the sound
	alSourcePlay(sourceID);
    alError = alGetError();

    // Check to see if there were any errors
	alError = alGetError();
	if(alError != 0) {
		Debug((@"SOUND: ERROR - %d", alError));
		return 0;
	}
    
	// Return the source ID so that loops can be stopped etc
	return sourceID;
}


- (void)stopSoundWithKey:(NSString*)theSoundKey {
	// TODO: complete this method
}


- (void)playMusicWithKey:(NSString*)aMusicKey timesToRepeat:(NSUInteger)aRepeatCount {
	
	NSError *error;
	
	NSString *path = [musicLibrary objectForKey:aMusicKey];
	
	if(!path) {
		Debug((@"SOUND: ERROR - The music key '%@' could not be found", aMusicKey));
		return;
	}
	
	if(musicPlayer)
		[musicPlayer release];
	
	// Initialize the AVAudioPlayer using the path that we have retrieved from the music library dictionary
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	
	// If the backgroundMusicPlayer object is nil then there was an error
	if(!musicPlayer) {
		NSLog(@"ERROR - SoundManager: Could not play music for key '%d'", error);
		return;
	}		
	
	// Set the number of times this music should repeat.  -1 means never stop until its asked to stop
	[musicPlayer setNumberOfLoops:aRepeatCount];
	
	// Set the volume of the music
	[musicPlayer setVolume:musicVolume];
	
	// Play the music
	[musicPlayer play];
}


- (void)stopMusic {
	[musicPlayer stop];
}


- (void)pauseMusic {
	if(musicPlayer)
		[musicPlayer pause];
}

- (void)resumeMusic {
	if (musicPlayer) {
		[musicPlayer play];
	}
}

#pragma mark -
#pragma mark SoundManager settings

- (void)setMusicVolume:(ALfloat)aVolume {

	// Set the volume iVar
	musicVolume = aVolume;

	// Check to make sure that the audio player exists and if so set its volume
	if(musicPlayer) {
		[musicPlayer setVolume:musicVolume];
	
	}
}


- (void)setFxVolume:(ALfloat)aVolume {
	fxVolume = aVolume;
}


- (void)setListenerPosition:(CGPoint)aPosition {
	listenerPosition = aPosition;
	alListener3f(AL_POSITION, aPosition.x, aPosition.y, 0.0f);
}


- (void)setOrientation:(CGPoint)aPosition {
    ALfloat orientation[] = {aPosition.x, aPosition.y, 0.0f, 0.0f, 0.0f, 1.0f};
    alListenerfv(AL_ORIENTATION, orientation);
}

@end


#pragma mark -
#pragma mark Private implementation

@implementation NVAudioCache (Private)

// Define the number of sources which will be created.  iPhone can have a max of 32
#define MAX_OPENAL_SOURCES 16

- (BOOL)initOpenAL {
    Debug((@"SOUND: INFO - Initializing sound manager"));
	
    // Get the device we are going to use for sound.  Using NULL gets the default device
	device = alcOpenDevice(NULL);
	
	// If a device has been found we then need to create a context, make it current and then
	// preload the OpenAL Sources
	if(device) {
		// Use the device we have now got to create a context in which to play our sounds
		context = alcCreateContext(device, NULL);
        
		// Make the context we have just created into the active context
		alcMakeContextCurrent(context);
        
        // Set the distance model to be used
        alDistanceModel(AL_LINEAR_DISTANCE_CLAMPED);
        
		// Pre-create 32 sound sources which can be dynamically allocated to buffers (sounds)
		NSUInteger sourceID;
		for(int index = 0; index < MAX_OPENAL_SOURCES; index++) {
			// Generate an OpenAL source
			alGenSources(1, &sourceID);
            
            // Configure the generated source so that sounds fade as the player moves
            // away from them
            alSourcef(sourceID, AL_REFERENCE_DISTANCE, 25.0f);
            alSourcef(sourceID, AL_MAX_DISTANCE, 150.0f);
            alSourcef(sourceID, AL_ROLLOFF_FACTOR, 6.0f);
            
			// Add the generated sourceID to our array of sound sources
			[soundSources addObject:[NSNumber numberWithUnsignedInt:sourceID]];
		}
        
        Debug((@"SOUND: INFO - Finished initializing the sound manager"));
		// Return YES as we have successfully initialized OpenAL
		return YES;
	}

	// We were unable to obtain a device for playing sound so tell the user and return NO.
    Debug((@"SOUND: ERROR - Unable to allocate a device for sound."));
    
	return NO;
}


- (NSUInteger)nextAvailableSource {
	
	// Holder for the current state of the current source
	NSInteger sourceState;
	
	// Find a source which is not being used at the moment
	for(NSNumber *sourceNumber in soundSources) {
		alGetSourcei([sourceNumber unsignedIntValue], AL_SOURCE_STATE, &sourceState);
		// If this source is not playing then return it
		if(sourceState != AL_PLAYING) return [sourceNumber unsignedIntValue];
	}
	
	// If all the sources are being used we look for the first non looping source
	// and use the source associated with that
	NSInteger looping;
	for(NSNumber *sourceNumber in soundSources) {
		alGetSourcei([sourceNumber unsignedIntValue], AL_LOOPING, &looping);
		if(!looping) {
			// We have found a none looping source so return this source and stop checking
			NSUInteger sourceID = [sourceNumber unsignedIntValue];
			alSourceStop(sourceID);
			return sourceID;
		}
	}
	
	// If there are no looping sources to be found then just use the first source and use that
	NSUInteger sourceID = [[soundSources objectAtIndex:0] unsignedIntegerValue];
	alSourceStop(sourceID);
	return sourceID;
}

#pragma mark -
#pragma mark Interruption handling

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self setActivated:NO];
}


- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self setActivated:YES];
}


- (void)setActivated:(BOOL)aState {
    
    OSStatus result;
    
    if(aState) {
        Debug((@"SOUND: INFO - OpenAL Active"));
        
        // Set the AudioSession AudioCategory to AmbientSound
        UInt32 category = kAudioSessionCategory_SoloAmbientSound;
        result = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        if(result) {
            Debug((@"SOUND: ERROR - Unable to set the audio session category"));
            return;
        }
        
        // Set the audio session state to true and report any errors
        result = AudioSessionSetActive(true);
		if (result) {
            Debug((@"SOUND: ERROR - Unable to set the audio session state to YES with error %d.", result));
            return;
        }
        
        // As we are finishing the interruption we need to bind back to our context.
        alcMakeContextCurrent(context);
    } else {
        Debug((@"SOUND: INFO - OpenAL Inactive"));
        
        // As we are being interrupted we set the current context to NULL.  If this sound manager is to be
        // compaitble with firmware prior to 3.0 then the context would need to also be destroyed and
        // then re-created when the interruption ended.
        alcMakeContextCurrent(NULL);
    }
}

@end

