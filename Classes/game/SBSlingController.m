//
//  SBSlingController.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/1/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingController.h"

#import "NVCameraController.h"

#import "SBCollisionParticlesController.h"
#import "SBBallController.h"
#import "SBInstructionsController.h"

#import "SBGroups.h"

static UITouch* TouchPlayerOne;
static UITouch* TouchPlayerTwo;

@implementation SBSlingController

@synthesize isDraggingTail = _isDraggingTail;
@dynamic acceptsInput;

- (BOOL) acceptsInput {
    return _acceptsInput;
}

- (void) setAcceptsInput: (BOOL) acceptsInput {
    if (!acceptsInput) {
        // cancel any potentially tracked touch
        _touch = nil;
    }
    
    if (_acceptsInput != acceptsInput) {
        _acceptsInput = acceptsInput;
    }
}

- (id) init {
    if (self = [super init]) {
        _recordedPositionCount = 0;
        _timeIntervalBetweenRecordingPosition = FIXED_TIME_STEP;//1.0f / 30.0f;//1.0f / 10.0f;
        _timeIntervalBetweenRecordingUpdate = _timeIntervalBetweenRecordingPosition;
        _timeSinceLastPositionRecording = 0;
        _timeSinceLastRecordingUpdate = 0;
        
        _acceptsInput = YES;
    }
    return self;
}

- (void) startRecordingPositions {
    _isRecordingPositions = YES;
    _recordedPositionCount = 0;
}

- (void) stopRecordingPositions {
    _isRecordingPositions = NO;
    
    Debug((@"Recorded positions: %u", _recordedPositionCount));
}

- (void) playRecording {
    _isPlayingRecording = YES;
    _currentRecordedPosition = 0;
}

- (void) stopPlayingRecording {
    _isPlayingRecording = NO;
}

- (void) start {
    [super start];
    
    _collisionController.delegate = self;
    
    if ([self.group caseInsensitiveCompare: kGroupPlayerOne] == NSOrderedSame) {
        _isControllingPlayerOne = YES;
    }
}

- (void) emitParticlesAtPosition: (kmVec3) position {
    SBCollisionParticlesController* particlesController = [self.database getComponentOfType: [SBCollisionParticlesController class] fromGroup: @"collision_particles"];
    NVTransformable* particlesTransform = [self.database getComponentOfType: [NVTransformable class] fromGroup: @"collision_particles"];
    
    particlesTransform.position = position;
    
    [particlesController reset];
    
    particlesController.isEnabled = YES;
}

- (void) step: (float) t delta: (float) dt { 
    /*
    BOOL shouldApplyIcyFriction = NO;
    
    if (shouldApplyIcyFriction) {
        float friction = 0.98f;
        
        // ice it up!
        friction *= 1.15f;
        
        BOOL shouldApplyVelocityClamping = YES;
        
        float maxParticleVelocityMagnitude = 0.5f;
        
        for (int i = 0; i < _body.particleCount; i++) {
            NVSpringParticle* particle = [_body particleAtIndex: i];
            
            kmVec3Scale(&particle->velocity, &particle->velocity, friction);
            
            if (shouldApplyVelocityClamping) {
                float particleVelocityMagnitude = kmVec3LengthSq(&[_body head]->velocity);
                
                if (particleVelocityMagnitude > maxParticleVelocityMagnitude) {
                    float scale = maxParticleVelocityMagnitude / particleVelocityMagnitude;
                    
                    kmVec3Scale(&particle->velocity, &particle->velocity, scale);
                }
            }
            
            particle->position.z = 0;
        }
    }
    */
    [_collisionController resolve];
    
    if (_isPlayingRecording) {
        _timeSinceLastRecordingUpdate += dt;
        
        if (_timeSinceLastRecordingUpdate >= _timeIntervalBetweenRecordingUpdate) {
            _currentRecordedPosition++;
            
            if (_currentRecordedPosition > _recordedPositionCount) {
                _currentRecordedPosition = 0;
            }
        }
        
        kmVec3 recordedPosition = _recordedPositions[_currentRecordedPosition];
        
        NVSpringParticleAnchor* anchor = [_body anchor];
        
        anchor->position.x = recordedPosition.x;
        anchor->position.y = recordedPosition.y;
        anchor->position.z = recordedPosition.z;
    } else {
        if (_isRecordingPositions) {
            _timeSinceLastPositionRecording += dt;
            
            if (_timeSinceLastPositionRecording >= _timeIntervalBetweenRecordingPosition) {
                _timeSinceLastPositionRecording = 0;
                
                kmVec3 recordedPosition;
                kmVec3Assign(&recordedPosition, &[_body anchor]->position);
                
                _recordedPositionCount++;
                
                if (_recordedPositionCount > kMaxRecordedPositions) {
                    _recordedPositionCount = kMaxRecordedPositions; 
                    
                    for (int i = 1; i < kMaxRecordedPositions; i++) {
                        _recordedPositions[i - 1] = _recordedPositions[i];
                    }
                }
                
                _recordedPositions[_recordedPositionCount - 1] = recordedPosition;
            }
        }
    }
}

- (kmVec3) intersectionForTouchState: (NVTouchState) touchState {
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    NVRay ray = [cam rayFromScreenLocation: CGPointMake(touchState.x, touchState.y)];
    
    NVPlane plane = NVPlaneMake(0, 0, 0, 
                                0, 0, 1);
    
    kmVec3 intersection;
    ray_plane_intersection(&intersection, &ray, &plane);
    
    return intersection;
}

- (void) touchesBegan: (NSSet*) touches {
    NVSpringParticleAnchor* anchor = [_body anchor];
    
    if (anchor == NULL) {
        return;
    }
    
    if (_isPlayingRecording) {
        return;
    }
    
    if (!_acceptsInput) {
        return;
    }
    
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInView: touch.view];
        
        NVTouchState touchState = NVTouchStateMake(location.x, location.y, YES, touch.tapCount);
        
        kmVec3 intersection = [self intersectionForTouchState: touchState];
        
        float acceptableRadius = _body.scaleTail + 0.65f;
        
        BOOL touchIsWithinTailHitbox = 
            fabs(anchor->position.x - intersection.x) < acceptableRadius &&
            fabs(anchor->position.y - intersection.y) < acceptableRadius &&
            fabs(anchor->position.z - intersection.z) < acceptableRadius;
        
        if (touchIsWithinTailHitbox) {
            float distance = kmVec3DistanceSq(&anchor->position, &intersection);
            
            if (distance < acceptableRadius) {
                if ((!_isControllingPlayerOne && TouchPlayerOne == touch) ||
                    (_isControllingPlayerOne && TouchPlayerTwo == touch)) {
                    continue;
                }
                
                _touch = touch;
                
                if (_isControllingPlayerOne) {
                    TouchPlayerOne = touch;
                } else {
                    TouchPlayerTwo = touch;
                }
                
                _isDraggingTail = YES;
                
                NSString* playerInstructionsGroup = [NSString stringWithFormat: @"%@_instructions", self.group];
                
                SBInstructionsController* playerInstructions = [self.database getComponentOfType: [SBInstructionsController class] fromGroup: playerInstructionsGroup];
                
                [playerInstructions fadeOut];
                
                //[self startRecordingPositions];
            }
            
            break;
        }
    }
}

- (void) touchesMoved: (NSSet*) touches {
    if (_touch == nil) {
        return;
    }
    
    if ([touches containsObject: _touch]) {
        if (_isDraggingTail) {
            CGPoint previousLocation = [_touch previousLocationInView: _touch.view];
            CGPoint location = [_touch locationInView: _touch.view];
            
            if (previousLocation.x != location.x || previousLocation.y != location.y) {            
                NVTouchState touchState = NVTouchStateMake(location.x, location.y, YES, _touch.tapCount);
                
                kmVec3 intersection = [self intersectionForTouchState: touchState];
                
                float r = _body.scaleTail;
                
                float d = _playingFieldController.width / 2;
                float w = _playingFieldController.height / 2;
                
                kmVec3 min;
                kmVec3 max;
                
                if (_isControllingPlayerOne) {
                    kmVec3Fill(&min, -d, -w, 0);
                    kmVec3Fill(&max, d, 0, 0);                    
                } else {
                    kmVec3Fill(&min, -d, 0, 0);
                    kmVec3Fill(&max, d, w, 0);
                }
/*                
                kmVec3Fill(&min, -d, -w, 0);
                kmVec3Fill(&max, d, w, 0);
  */              
                NVAABB bounds = {
                    min, max
                };
                
                SBCollisionWall result = [SBCollisionController innerWallCollisionForSphereWithCenter: &intersection 
                                                                                            andRadius: r 
                                                                                    againstBoundaries: bounds];
                
                if ((result & SBCollisionWallLeft) != 0) {
                    intersection.x = min.x + r;
                } else if ((result & SBCollisionWallRight) != 0) {
                    intersection.x = max.x - r;
                } 
                
                if ((result & SBCollisionWallDown) != 0) {
                    intersection.y = min.y + r;
                } else if ((result & SBCollisionWallUp) != 0) {
                    intersection.y = max.y - r;
                }
                
                NVSpringParticleAnchor* anchor = [_body anchor];
                
                anchor->position.x = intersection.x;
                anchor->position.y = intersection.y;
                anchor->position.z = intersection.z;
            }
        }
    }
}

- (void) touchesEnded: (NSSet*) touches {
    if (_touch == nil) {
        return;
    }
    
    if ([touches containsObject: _touch]) {
        if (_isDraggingTail) {
            _isDraggingTail = NO;
            
            _touch = nil;
            
            if (_isControllingPlayerOne) {
                TouchPlayerOne = nil;
            } else {
                TouchPlayerTwo = nil;
            }
            /*
            // TEMPORARY FOR RECORDING HOW-TO
            [self stopRecordingPositions];
            
            [_body restoreInitialState];
            
            SBBallController* ball = [self.database getComponentOfType: [SBBallController class] fromGroup: @"ball"];
            
            [ball reset];
            
            printf("kmVec3 howToRecording[] = {\n");
            for (NSUInteger i = 0; i < _recordedPositionCount; i++) {
                kmVec3 recordedPosition = _recordedPositions[i];
                
                printf("    { %f, %f, %f },\n", recordedPosition.x, recordedPosition.y, recordedPosition.z);
            }
            printf("};\n");
            */
        }
    }
}

- (void) collisionController: (SBCollisionController*) controller detectedCollisionAtContactPoint: (kmVec3) contactPoint {
    [self emitParticlesAtPosition: contactPoint];
}

- (void) collisionController: (SBCollisionController*) controller detectedCollisionBetweenCollidable: (SBCollidable*) collidableA andCollidable: (SBCollidable*) collidableB atContactPoint: (kmVec3) contactPoint {
    [self emitParticlesAtPosition: contactPoint];
}

@end
