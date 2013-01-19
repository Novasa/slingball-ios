//
//  NVRenderer.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 1/31/10.
//  Copyright Novasa Interactive 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@protocol NVRenderer <NSObject>
@required
- (void) begin;
- (void) end;

- (BOOL) resizeFromLayer: (CAEAGLLayer*) layer;

- (EAGLContext*) context;

@end
