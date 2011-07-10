//
//  Track.m
//  GeneCar
//
//  Created by Andrea Terzani on 29/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Track.h"
#import "cocos2d.h"

#define PTM_RATIO 32
#define LENGHT 50
#define SEG_LENGHT 5

@implementation Track

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(void)generaSavedBox : (b2World *)world
{
    float track_data[61]={2.678646,1.263653,0.681356,1.903954,1.776394,3.907021,0.470990,1.360077,2.919796,2.942992,1.637262,1.210257,2.742758,2.292620,3.802434,2.404684,1.245418,1.684128,1.513848,3.659125,3.711491,1.014721,3.257064,1.165604,3.323402,1.163363,1.339856,2.265011,0.114007,1.675083,2.419302,0.145610,0.387978,3.097635,1.328881,1.477847,3.489499,3.298249,0.269095,2.588415,1.740906,1.587320,3.770866,0.277965,1.862542,1.605137,1.953124,2.557082,2.957582,3.339946,3.846536,0.462308,0.920894,1.641378,2.478498,2.754299,3.937238,0.046623,0.037060,1.553602,1.089946,
    };
    
    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape groundBox;		
    //groundBox.SetAsEdge(b2Vec2(0,1), b2Vec2(15,1));
    b2Vec2 vert[4]={
        b2Vec2(0.0,0.8),
        b2Vec2(15.0,0.8),
        b2Vec2(15.0,1.0),
        b2Vec2(0.0,1.0)
    
    };
    groundBox.Set(vert,4);
    
    b2FixtureDef groundFixtureDef;
    
    groundFixtureDef.friction=0.5f;
    groundFixtureDef.restitution=0.0f;
    groundFixtureDef.shape=&groundBox;
    
    groundBody->CreateFixture(&groundFixtureDef);
    NSString* trk=@"track_data[]={";
    
    float nextH;
    float H=1;
    float x=15;
    
    for(int i=0;i<60;i++){
        nextH=track_data[i];
        
        
        
        b2Vec2 vert[4]={
            b2Vec2(x,H-0.2),
            b2Vec2(x+SEG_LENGHT,nextH-0.2),
            b2Vec2(x+SEG_LENGHT,nextH),
            b2Vec2(x,H)
            
        };
        groundBox.Set(vert,4);
        
        //groundBox.SetAsEdge(b2Vec2(x,H), b2Vec2(x+8,nextH));
        
        //groundBox.SetAsBox(x,H,b2Vec2(x,H),atan(x/H));
        
        groundFixtureDef.shape=&groundBox;
        
        groundBody->CreateFixture(&groundFixtureDef);
        H=nextH;
        x+=SEG_LENGHT;
        
        
    }
    NSLog(trk);
    
}

- (void) draw
{

    const b2Transform& xfb=groundBody->GetTransform();
    
    for (b2Fixture* f = groundBody->GetFixtureList(); f; f = f->GetNext())
    {
        
        b2PolygonShape* poly = (b2PolygonShape*)f->GetShape();
        int32 vertexCount = poly->m_vertexCount;
        
        b2Vec2 vertices[4];
        CGPoint v[4];
        
        for (int32 i = 0; i < vertexCount; ++i)
        {
            vertices[i] = b2Mul(xfb, poly->m_vertices[i]);
            v[i].x=vertices[i].x*PTM_RATIO;
            v[i].y=vertices[i].y*PTM_RATIO;
        }
        glColor4f(0.2,0.2,0.2, 1.0);
        
        
        glLineWidth(2.0f);
        ccDrawPoly(v,vertexCount,NO);
        ccDrawFillPoly(v,vertexCount,YES,YES);
    }


}

@end
