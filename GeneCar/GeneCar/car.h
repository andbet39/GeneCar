//
//  car.h
//  GeneCar
//
//  Created by Andrea Terzani on 29/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"
#import "Cromosome.h"

#import "GeneticConfig.h"


@interface car : CCSprite
{

    Cromosome *cromosome;
    
    b2Vec2 body_vectors[VERT_NUM];
    b2Body *body;
    b2Body *ruota0;
    b2Body *ruota1;
    b2Body *asse0;
    b2Body *asse1;
    
    b2PrismaticJoint *spring0;
    b2PrismaticJoint *spring1;
    b2RevoluteJoint *motor0;
    b2RevoluteJoint *motor1;
    
    b2Vec2 position;
    
    float raggio0;
    float raggio1;
    
}

@property(assign,readwrite)Cromosome *cromosome;

-(void) generaRandom : (b2World *) world;
-(void) generaFromCromosome : (Cromosome*)c world:(b2World *) world;
-(void) setInitPosition:(b2Vec2)pos;



- (void) destroy : (b2World *) world;
-(b2Vec2) getPosition;

- (void) draw;
-(void) update;

@end
