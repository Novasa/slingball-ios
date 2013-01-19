//
//  NVES1Renderer.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright Novasa Interactive 2010. All rights reserved.
//

#import "NVRenderer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface NVES1Renderer : NSObject <NVRenderer> {
 @private
	EAGLContext* _context;
	
	GLint _backingWidth;
	GLint _backingHeight;
	
	GLuint _defaultFramebuffer;
    GLuint _colorRenderbuffer;
    GLuint _depthRenderbuffer;
    
#if DEBUG
    float _timeLastFramerateUpdate;
    NSUInteger _renderedFrames;
#endif
}

#if DEBUG
+ (float) debug_framesPerSecond;
#endif

- (void) begin;
- (void) end;

@end
