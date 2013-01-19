//
//  SBSlingController.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVTouchBuffer.h"

#import "NVSchedulable.h"
#import "NVTransformable.h"
#import "NVTouchable.h"

#import "SBSlingBody.h"
#import "SBSlingCollisionController.h"
#import "SBCollisionControllerDelegate.h"

#import "SBPlayingFieldController.h"

#define kMaxRecordedPositions 512

@interface SBSlingController : NVSchedulable <SBCollisionControllerDelegate, NVTouchable> {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBSlingBody, _body);
    REQUIRES(SBSlingCollisionController, _collisionController);

    REQUIRES_FROM_GROUP(SBPlayingFieldController, _playingFieldController, playing_field);
    
    BOOL _isDraggingTail;
    BOOL _isControllingPlayerOne;
    
    UITouch* _touch;
    
    float _timeIntervalBetweenRecordingPosition;
    float _timeSinceLastPositionRecording;
    BOOL _isRecordingPositions;
    
    float _timeIntervalBetweenRecordingUpdate;
    float _timeSinceLastRecordingUpdate;
    NSUInteger _currentRecordedPosition;
    BOOL _isPlayingRecording;
    
    NSUInteger _recordedPositionCount;
    
    kmVec3 _recordedPositions[kMaxRecordedPositions];
    
    BOOL _acceptsInput;
}

@property(nonatomic, readonly) BOOL isDraggingTail;

@property(nonatomic, readwrite, assign) BOOL acceptsInput;

- (void) startRecordingPositions;
- (void) stopRecordingPositions;
- (void) playRecording;
- (void) stopPlayingRecording;

@end
