/*
 *  NV.h
 *  slingball
 *
 *  Created by Jacob Hauberg Hansen on 11/17/09.
 *  Copyright 2009 Novasa Interactive. All rights reserved.
 *
 */

#import <mach/mach.h>
#import <mach/mach_time.h>

#import <OpenGLES/ES1/gl.h>

#import <stdlib.h>

#import "math/vec3.h"
#import "math/vec4.h"
#import "math/mat3.h"
#import "math/mat4.h"
#import "math/quaternion.h"

#import "NVCommon.h"

#define DISPLAY_REFRESH_RATE_INTERVAL 2
#define DISPLAY_REFRESH_RATE (DISPLAY_REFRESH_RATE_INTERVAL == 1 ? (1.0f / 60.0f) : (1.0f / 30.0f))
#define FIXED_TIME_STEP (1.0f / 60.0f)

#define REQUIRES(type,name) type * name;BOOL __requires_##name;
// NOTE: 
// If using remote dependencies, be aware that they will be injected during init, thus requiring the dependencies to be existing already.
// Also, the group names must not contain spaces or any weird characters (since it becomes part of the compiled code).
#define REQUIRES_FROM_GROUP(type,name,grp) type * name;BOOL __requires_##name##_from_group_##grp;

#ifdef DEBUG
    #define Debug(x) NSLog x
    #define Trace(s, ...) NSLog( @"%@ <%p %@:(%d)> %@", NSStringFromSelector(_cmd), self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else 
    #define Debug(x)
#endif

extern float GLOBAL_TIME_SCALE;

static inline float current_time(void) {
	static double conversion = 0.0;

	if (conversion == 0.0) {
		mach_timebase_info_data_t info = { 0, 0 };
		kern_return_t error = mach_timebase_info(&info);
		
		if (!error) {
			conversion = 1e-9 * (double)info.numer / (double)info.denom;
		}
	}
	
	return conversion * (float)mach_absolute_time();
}
