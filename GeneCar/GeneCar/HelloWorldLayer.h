//
//  HelloWorldLayer.h
//  GeneCar
//
//  Created by Andrea Terzani on 29/06/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "car.h"
#import "Track.h"
#import "GeneticLab.h"
#import "HUDLayer.h"
#import "GeneticConfig.h"
#import "GameManager.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    NSMutableArray * cars;
    car * mycar;
    Track *myTrack;
    
    CCLabelTTF *score_Label;
    GeneticLab *myLab;
    
    float tempo_ferma;
    float last_x;
    
    float curr_car_score;
    float curr_car_time;
    
    
    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
