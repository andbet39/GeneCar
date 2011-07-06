//
//  MenuLayer.h
//  GeneCar
//
//  Created by Andrea Terzani on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "car.h"
#import "Track.h"
#import "GeneticLab.h"
#import "HUDLayer.h"
#import "GeneticConfig.h"
#import "GameManager.h"
#import "MenuCar.h"


@interface MenuLayer : CCLayer
{

    b2World* world;
    GLESDebugDraw *m_debugDraw;
    b2Body* groundBody;

    MenuCar *mycar;
    GeneticLab *myLab;
    
    CCLabelTTF *simFPSLabel;
    int simFPS;


}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
