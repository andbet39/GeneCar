//
//  TestScene.h
//  GeneCar
//
//  Created by Andrea Terzani on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLES-Render.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "car.h"
#import "Track.h"
#import "GeneticLab.h"
#import "HUDLayer.h"
#import "GeneticConfig.h"
#import "GameManager.h"
#import "PlayableCar.h"
#import "HudRaceScene.h"
#import "RaceManager.h"
#import "SoundEngine.h"


@interface RaceScene : CCLayer
{
	b2World* world;
    
    b2Body *cancelloBody;
    
    GLESDebugDraw *m_debugDraw;

    PlayableCar * mycar;
    Track *myTrack;
    GeneticLab *myLab;
    
    RaceManager *myRaceManager;
    HudRaceScene *myHud;
    
    
    float preStartTime;
    bool cancelloUP;
    
    b2Vec2 pos;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;
-(void) resetCar;

@end
