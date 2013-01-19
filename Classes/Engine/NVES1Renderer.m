//
//  NVES1Renderer.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright Novasa Interactive 2010. All rights reserved.
//

#import "NVES1Renderer.h"

@implementation NVES1Renderer

#if DEBUG
static float FramesPerSecond = 0.0f;

+ (float) debug_framesPerSecond {
    return FramesPerSecond;
}
#endif

- (id) init {
	if (self = [super init]) {
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!_context || ![EAGLContext setCurrentContext: _context]) {
            [self release];
            
            return nil;
        }
		
		glGenFramebuffersOES(1, &_defaultFramebuffer);
		glGenRenderbuffersOES(1, &_colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _colorRenderbuffer);
        
        glGenRenderbuffersOES(1, &_depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, 
                                     GL_DEPTH_ATTACHMENT_OES, 
                                     GL_RENDERBUFFER_OES, 
                                     _depthRenderbuffer);

        glEnable(GL_NORMALIZE);
        
#if DEBUG
        _timeLastFramerateUpdate = current_time();
#endif
	}
	
	return self;
}

- (void) begin {
    [EAGLContext setCurrentContext: _context];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFramebuffer);
    glViewport(0, 0, _backingWidth, _backingHeight);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

- (void) end {
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER_OES];
    
#if DEBUG
    _renderedFrames++;
    
    float now = current_time();
    float timeSinceLastFramerateUpdate = now - _timeLastFramerateUpdate;
    
    if (timeSinceLastFramerateUpdate >= 1.0f) {
        FramesPerSecond = _renderedFrames / 1.0f;
        
        _renderedFrames = 0;
        _timeLastFramerateUpdate = now;
    }
#endif
}

- (BOOL) resizeFromLayer: (CAEAGLLayer*) layer {
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable: layer];
    
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderbuffer);
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, 
                             GL_DEPTH_COMPONENT16_OES, 
                             _backingWidth, _backingHeight);
    
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        
        return NO;
    }
    
    return YES;
}

- (EAGLContext*) context {
    return _context;
}

- (void) dealloc {
	if (_defaultFramebuffer) {
		glDeleteFramebuffersOES(1, &_defaultFramebuffer);
		_defaultFramebuffer = 0;
	}
    
	if (_colorRenderbuffer) {
		glDeleteRenderbuffersOES(1, &_colorRenderbuffer);
		_colorRenderbuffer = 0;
	}
	
    if (_depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
        _depthRenderbuffer = 0;
    }
    
	if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext: nil];
    }
	
    if (_context != nil) {
        [_context release];
        _context = nil;
    }
	
	[super dealloc];
}

@end
