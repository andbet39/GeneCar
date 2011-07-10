//
//  GarageScene.h
//  GeneCar
//
//  Created by Andrea Terzani on 08/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "SlidingMenuGrid.h"
#import "GLES-Render.h"
#import "car.h"
#import "Track.h"
#import "GeneticLab.h"
#import "MenuCar.h"
#import "Garage.h"

@interface GarageScene : CCLayer
{
    
    b2World* world;
    GLESDebugDraw *m_debugDraw;
    b2Body* groundBody;
    
    Garage* mygarage;
    NSMutableArray *menuCars;
    
    
}

+(CCScene *) scene;

-(void)loadGarage;
@end
