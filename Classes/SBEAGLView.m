//
//  SBEAGLView.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright Novasa Interactive 2010. All rights reserved.
//

#import "SBEAGLView.h"

#import "NVES1Renderer.h"

#import "NVGame.h"
#import "NVTouchBuffer.h"

#ifdef DEBUG
    #import "NVDebug.h"
    #import "NVTextureCache.h"
#endif

@implementation SBEAGLView

@synthesize animating = _isAnimating;
@dynamic animationFrameInterval;

+ (Class) layerClass {
    return [CAEAGLLayer class];
}

- (id) initWithCoder:(NSCoder*)coder {    
    if ((self = [super initWithCoder: coder])) {
        CAEAGLLayer* eaglLayer = (CAEAGLLayer*)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool: FALSE], kEAGLDrawablePropertyRetainedBacking, 
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, 
                                        nil];
		
        _renderer = [[NVES1Renderer alloc] init];
        
        if (!_renderer) {
            [self release];
            
            return nil;
        }

		_isAnimating = NO;
		_isDisplayLinkSupported = NO;
        
        _displayLink = nil;
        
		_animationFrameInterval = DISPLAY_REFRESH_RATE_INTERVAL;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30100
        _isDisplayLinkSupported = YES;
#elif TARGET_IPHONE_SIMULATOR
        _isDisplayLinkSupported = YES;
#endif

        _touchService = [[NVTouchService alloc] init];
        
        [[NVGame sharedGame].database subscribeService: _touchService];
 
        Debug((@"Rates:"));
        Debug((@"-----------------"));
        Debug((@"Display @ %f", DISPLAY_REFRESH_RATE));
        Debug((@"Logic   @ %f", FIXED_TIME_STEP));
        Debug((@"-----------------\n\n"));
 
#ifdef DEBUG
        _debugging = [[NVDebugService alloc] init];
        
        NVDebugShowFPS* showFPS = [[NVDebugShowFPS alloc] init];
        [[[NVGame sharedGame] database] bindComponent: showFPS toGroup: @"debug"];
        [showFPS release];
        
        [[NVGame sharedGame].database subscribeService: _debugging];
        [[NVGame sharedGame].database debugPrintServicesPretty];
#endif

        [[NVGame sharedGame] loadSceneFromFileNamed: @"Global" async: NO];
        [[NVGame sharedGame] loadSceneFromFileNamed: @"Splash" async: NO];
    }
	
    return self;
}

- (void) drawView: (id) sender {
    [[NVTouchBuffer sharedBuffer] begin];
    
    [[NVGame sharedGame].scheduling tick];
    [[NVGame sharedGame].transformation resolve];

    @synchronized([_renderer context]) {
        [_renderer begin];
        
        [[NVGame sharedGame].rendering render];
        
        [_renderer end];
    }
    
    [[NVTouchBuffer sharedBuffer] end];
    
#ifdef DEBUG
    [_debugging tick];
#endif
}

- (void) layoutSubviews {
	[_renderer resizeFromLayer: (CAEAGLLayer*) self.layer];
    
    [self drawView: nil];
}

- (NSInteger) animationFrameInterval {
	return _animationFrameInterval;
}

- (void) setAnimationFrameInterval: (NSInteger) frameInterval {
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1) {
		_animationFrameInterval = frameInterval;
		
		if (_isAnimating) {
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) startAnimation {
	if (!_isAnimating) {
		if (_isDisplayLinkSupported) {
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.
            
			_displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget: self 
                                                                            selector: @selector(drawView:)];
            
			[_displayLink setFrameInterval: _animationFrameInterval];
			[_displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
		}
        
		_isAnimating = YES;
	}
}

- (void) stopAnimation {
	if (_isAnimating) {
		if (_isDisplayLinkSupported && _displayLink != nil) {
			[_displayLink invalidate];
			_displayLink = nil;
		}
		
		_isAnimating = NO;
	}
}

- (void) touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event {
    [_touchService touchesBegan: touches];
    
    [[NVTouchBuffer sharedBuffer] touchesBegan: touches];
}

- (void) touchesMoved: (NSSet*) touches withEvent: (UIEvent*) event {
    [_touchService touchesMoved: touches];
    
    [[NVTouchBuffer sharedBuffer] touchesMoved: touches];
}

- (void) touchesEnded: (NSSet*) touches withEvent: (UIEvent*) event {
    [_touchService touchesEnded: touches];
    
    [[NVTouchBuffer sharedBuffer] touchesEnded: touches];
}

- (void) dealloc {
    [_renderer release];
    
#ifdef DEBUG
    [_debugging release];
#endif
    
    [_touchService release];
	
    [super dealloc];
}

@end
