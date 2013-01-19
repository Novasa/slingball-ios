//
//  SBScoreBoard.h
//  slingball
//
//  Created by Jacob Hauberg Hansen on 2/4/10.
//  Copyright 2010 Novasa Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NVTransformable.h"
#import "NVRenderable.h"

#import "SBPlayingFieldController.h"
#import "SBScoreBoardController.h"

@interface SBScoreBoard : NVRenderable {
 @private
    REQUIRES(NVTransformable, _transform);
    REQUIRES(SBScoreBoardController, _controller);
    
    REQUIRES_FROM_GROUP(SBPlayingFieldController, _playingFieldController, playing_field);
    
    NVVertex* _vertices;
}

@end
