//
//  SBFloatingGoalText.m
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/28/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import "SBFloatingText.h"
#import "SBRenderStates.h"

#import "NVCameraController.h"

#import "text-goal.h"
#import "text-own_goal.h"
#import "text-you_win.h"

@implementation SBFloatingText

- (id) init {
    if (self = [super init]) {
        self.layer = 1;
        self.isOpaque = YES;
        self.state = (unsigned int)(void*)state_floating_text;
    }
    return self;
}

- (void) render {
    if (!_controller.isEnabled) {
        return;
    }
    
    NVCamera* cam = [[NVCameraController sharedController] camera];
    
    kmMat4 view = cam.view;
    kmMat4 world = _transform.world;
    
    kmMat4 modelview;
    kmMat4Multiply(&modelview, &view, &world);
    
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(cam.projection.mat);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(modelview.mat);
    
    glColor4f(1, 1, 1, _controller.alpha);
    
    GLsizei vertexCount = 0;

    switch (_controller.text) {
        case SBFloatingTextElementGoal: {
            glVertexPointer(3, GL_FLOAT, sizeof(NVNormalVertex), &TextGoalVertexData[0].vertex);
            glNormalPointer(GL_FLOAT, sizeof(NVNormalVertex), &TextGoalVertexData[0].normal);
            
            vertexCount = kTextGoalNumberOfVertices;            
        } break;
            
        case SBFloatingTextElementOwnGoal: {
            glVertexPointer(3, GL_FLOAT, sizeof(NVNormalVertex), &TextOwnGoalVertexData[0].vertex);
            glNormalPointer(GL_FLOAT, sizeof(NVNormalVertex), &TextOwnGoalVertexData[0].normal);        
            
            vertexCount = kTextOwnGoalNumberOfVertices;           
        } break;
            
        case SBFloatingTextElementYouWin: {
            glVertexPointer(3, GL_FLOAT, sizeof(NVNormalVertex), &TextYouWinVertexData[0].vertex);
            glNormalPointer(GL_FLOAT, sizeof(NVNormalVertex), &TextYouWinVertexData[0].normal);        
            
            vertexCount = kTextYouWinNumberOfVertices;           
        } break;
            
        default: break;
    }
    
    glDrawArrays(GL_TRIANGLES, 0, vertexCount);
}

@end
