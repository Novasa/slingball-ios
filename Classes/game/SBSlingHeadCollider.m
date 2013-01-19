//
//  SBSlingCollider.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBSlingHeadCollider.h"

@implementation SBSlingHeadCollider

- (float) radius {
    return _body.scaleHead;
}

- (kmVec3*) position {
    NVSpringParticle* head = [_body head];
    
    if (head != NULL) {
        return &head->position;
    }
    
    return NULL;
}

- (kmVec3*) velocity {
    NVSpringParticle* head = [_body head];
    
    if (head != NULL) {
        return &[_body head]->velocity;
    }
    
    return NULL;
}

@end
