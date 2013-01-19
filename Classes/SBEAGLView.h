//
//  SBEAGLView.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright Novasa Interactive 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "NVRenderer.h"

#import "NVTouchService.h"

#ifdef DEBUG
    #import "NVDebugService.h"
#endif

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
@interface SBEAGLView : UIView {    
 @private
	id<NVRenderer> _renderer;
	
    // Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	// CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	// The NSTimer class is used only as fallback when running on a pre 3.1 device where CADisplayLink
	// isn't available.
	id _displayLink;
    
	BOOL _isAnimating;
	BOOL _isDisplayLinkSupported;
    
	NSInteger _animationFrameInterval;
        
    NVTouchService* _touchService;

#ifdef DEBUG
    NVDebugService* _debugging;
#endif
}

@property(nonatomic, readonly, getter=isAnimating) BOOL animating;
@property(nonatomic) NSInteger animationFrameInterval;

- (void) startAnimation;
- (void) stopAnimation;

- (void) drawView: (id) sender;

@end

