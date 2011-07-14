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

@synthesize finishLane_x,gold_time,silver_time,bronze_time,name;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(id)initFromPlist:(NSString *)plistFile world:(b2World *)world
{
    
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:plistFile];
        
        NSDictionary* plistDictionary = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
        
        
        NSString *SvgPath=(NSString*)[plistDictionary objectForKey:@"track_svg_path"];
        
        NSString *finishLane=(NSString*) [plistDictionary objectForKey:@"finish_lane_x"];
        finishLane_x= [finishLane floatValue];
        
        
        
        NSString *s_gold_time=(NSString*)[plistDictionary objectForKey:@"gold_time"];
        NSString *s_silver_time=(NSString*)[plistDictionary objectForKey:@"silver_time"];
        NSString *s_bronze_time=(NSString*)[plistDictionary objectForKey:@"bronze_time"];
        
        gold_time=[s_gold_time floatValue];
        silver_time=[s_silver_time floatValue];
        bronze_time=[s_bronze_time floatValue];
        
        NSString *s_trasf_x=(NSString*)[plistDictionary objectForKey:@"trasf_x"];
        NSString *s_trasf_y=(NSString*)[plistDictionary objectForKey:@"trasf_y"];
        
        
        trasf_x=[s_trasf_x floatValue];
        trasf_y=[s_trasf_y floatValue];
        NSMutableArray * str_points = [self svgToCGPointArray:SvgPath];
        
        // Define the ground body.
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0, 0); // bottom-left corner
        
        groundBody = world->CreateBody(&groundBodyDef);
        
        b2PolygonShape groundBox;		
        b2FixtureDef groundFixtureDef;
        
        groundFixtureDef.friction=0.5f;
        groundFixtureDef.restitution=0.0f;
        groundFixtureDef.shape=&groundBox;
        
        groundBody->CreateFixture(&groundFixtureDef);
        
        float nextH;
        float H=1;
        float x=15;
        float nextX;
        
        
        for(int i=0;i<[str_points count]-1;i++){
            
            
            CGPoint p=CGPointFromString([str_points objectAtIndex:i]);
            CGPoint p1=CGPointFromString([str_points objectAtIndex:i+1]);
            
            
            
            H=(320-p.y)/PTM_RATIO;
            nextH=(320-p1.y)/PTM_RATIO;
            x=(p.x)/PTM_RATIO;
            nextX=(p1.x)/PTM_RATIO;
            
            if(nextX>x){
                
                b2Vec2 vert[4]={
                    b2Vec2(x,H-0.2),
                    b2Vec2(nextX,nextH-0.2),
                    b2Vec2(nextX,nextH),
                    b2Vec2(x,H)
                    
                };
                groundBox.Set(vert,4);
                
                
                groundFixtureDef.shape=&groundBox;
                
                groundBody->CreateFixture(&groundFixtureDef);
                
            }
            
        }
    }
    
    return self;
    
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
        //ccDrawPoly(v,vertexCount,NO);
        ccDrawFillPoly(v,vertexCount,YES,YES);
    }
    
    
}

-(NSMutableArray*) svgToCGPointArray : (NSString*) path
{
    
    NSArray * cmd= [path componentsSeparatedByString:@" "];
    int curr_command=0;//0 = moveTo 1= MoveTo 2= lineTo 3=LineTo
    
    NSMutableArray *result=[[NSMutableArray alloc]init ];
    
    
    int currentx=0+trasf_x;
    int currenty=-732+trasf_y;
    
    for(NSString *c_str in cmd){
        
        if([c_str isEqual:@"m"]){
            
            curr_command=0;
            
        }else{
            if([c_str isEqual:@"l"]){
                
                curr_command=2;
                
            }else{
                if([c_str isEqual:@"L"]){
                    
                    curr_command=3;
                    
                }else{
                    if([c_str isEqual:@"M"]){
                        
                        curr_command=1;
                        
                    }
                    else
                    {
                        
                        NSArray *coord=[c_str componentsSeparatedByString:@","];
                        NSString *s_X=[coord objectAtIndex:0];
                        NSString *s_Y=[coord objectAtIndex:1];
                        
                        
                        if(curr_command==0){
                            CGPoint p =ccp( (currentx+[s_X floatValue]),currenty+[s_Y floatValue]);
                            currentx+=[s_X floatValue];
                            currenty+=[s_Y floatValue];
                            NSString * cgstr=NSStringFromCGPoint(p);
                            [result addObject:cgstr];
                            
                        }
                        if(curr_command==1){
                            CGPoint p =ccp( ([s_X floatValue]),[s_Y floatValue]);
                            currentx=[s_X floatValue];
                            currenty=[s_Y floatValue];
                            NSString * cgstr=NSStringFromCGPoint(p);
                            [result addObject:cgstr];
                            
                        }
                        if(curr_command==2){
                            CGPoint p =ccp( (currentx+[s_X floatValue]),currenty+[s_Y floatValue]);
                            currentx+=[s_X floatValue];
                            currenty+=[s_Y floatValue];
                            NSString * cgstr=NSStringFromCGPoint(p);
                            [result addObject:cgstr];
                            
                        }
                        if(curr_command==3){
                            CGPoint p =ccp( ([s_X floatValue]),[s_Y floatValue]);
                            currentx=[s_X floatValue];
                            currenty=[s_Y floatValue];
                            NSString * cgstr=NSStringFromCGPoint(p);
                            [result addObject:cgstr];
                            
                        }
                        
                    }}}}
        
        
        
    }
    
    
    return result;
    
    
}

@end
