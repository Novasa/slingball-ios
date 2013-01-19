//
//  NVTouchBuffer.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 12/10/09.
//  Copyright 2009 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    float x, y;
    BOOL pressed;
    int taps;
} NVTouchState;

#if DEBUG
static inline void NVTouchStatePrint(NVTouchState state) {
    NSLog(@"%f, %f - Pressed: %@", state.x, state.y, state.pressed ? @"YES" : @"NO");
}
#endif

static inline BOOL NVTouchStateIsEmpty(NVTouchState state) {
    return state.x < 0.01f && state.y < 0.01f && state.pressed == NO;
}

static inline NVTouchState NVTouchStateMake(float x, float y, BOOL pressed, int taps) {
    NVTouchState state;
    
    state.x = x;
    state.y = y;
    state.pressed = pressed;
    state.taps = taps;
    
    return state;
}

@interface NVTouchBuffer : NSObject {
@private
    UITouch* _touchBuffered;
    
    BOOL _shouldFlushState;
    BOOL _isPlayingFrame;
    BOOL _stateHasBeenModifiedDuringPreviousFrame;
    BOOL _stateHasBeenAvailableForAtleastOneFrame;

    NVTouchState _state;
}

+ (NVTouchBuffer*) sharedBuffer;

- (void) begin;
- (void) end;

- (NVTouchState) state;

- (void)touchesBegan:(NSSet *)touches;
- (void)touchesMoved:(NSSet *)touches;
- (void)touchesEnded:(NSSet *)touches;

@end
