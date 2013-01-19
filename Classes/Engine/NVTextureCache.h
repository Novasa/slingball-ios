//
//  NVTextureCache.h
//  slingball
//
//  Created by Jacob Hansen on 2/16/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES1/gl.h>

@interface NVTextureCache : NSObject {
 @private
	NSMutableDictionary* _cache;
}

+ (NVTextureCache*) sharedCache;

- (GLuint) setTextureFromImageNamed: (NSString*) name;
- (void) flush;
- (void) freeTextureFromName: (NSString*) name;

@end
