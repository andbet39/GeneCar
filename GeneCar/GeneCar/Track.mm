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


-(void)generaSavedBox2 : (b2World *)world
{
    
    float  track_data_x[100]={15.000000,27.187500,32.500000,39.500000,51.625000,56.625000,61.812500,65.750000,70.437500,73.250000,76.500000,79.437500,82.062500,99.500000,104.500000,120.000000,123.125000,128.375000,130.875000,132.875000,135.000000,137.000000,141.125000,142.062500,156.812500,164.812500,168.000000,170.437500,172.375000,177.750000,189.125000,196.062500,211.812500,219.812500,231.812500,240.812500,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000};
    
    float  track_data_y[100]={1.000000,2.375000,3.250000,3.250000,1.500000,1.500000,2.250000,3.750000,5.937500,1.625000,4.312500,2.000000,3.750000,2.125000,2.125000,1.937500,2.500000,3.750000,5.062500,5.687500,5.500000,2.437500,2.312500,5.000000,2.250000,2.250000,3.812500,2.250000,3.812500,2.250000,3.375000,6.000000,3.125000,3.125000,3.125000,3.125000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000};
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
    float nextX;
    
    
    for(int i=0;i<99;i++){
        
        H=track_data_y[i];
        nextH=track_data_y[i+1];
        x=track_data_x[i];
        nextX=track_data_x[i+1];
        
        if(nextX>x){
            
            b2Vec2 vert[4]={
                b2Vec2(x,H-0.2),
                b2Vec2(nextX,nextH-0.2),
                b2Vec2(nextX,nextH),
                b2Vec2(x,H)
                
            };
            groundBox.Set(vert,4);
            
            //groundBox.SetAsEdge(b2Vec2(x,H), b2Vec2(x+8,nextH));
            
            //groundBox.SetAsBox(x,H,b2Vec2(x,H),atan(x/H));
            
            groundFixtureDef.shape=&groundBox;
            
            groundBody->CreateFixture(&groundFixtureDef);
            
        }
        
    }
    
    NSLog(trk);
    
}


-(id)initFromPlist:(NSString *)plistFile world:(b2World *)world
{
    
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:plistFile];
        
        NSDictionary* plistDictionary = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
        
        
        NSString *SvgPath=(NSString*)[plistDictionary objectForKey:@"track_svg_path"];
        
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



-(void)generaFromSvg:(b2World *)world
{
    
    NSString *SvgPath=@"m 3.7037037,307.03704 403.7037063,0 59.25926,-11.11111 57.4074,-20.37037 38.88889,-20.37037 35.18519,-20.37038 68.51852,61.11112 161.11111,-1.85186 7.40741,-66.66666 70.37037,11.11111 122.22224,25.92592 96.2963,40.74075 18.5185,7.4074 275.9259,0 46.2963,-9.25926 62.963,-24.07407 38.8889,-27.77778 38.8889,-20.37037 48.1481,-7.40741 55.5556,83.33334 48.1481,-66.66667 35.1852,72.22222 70.3704,-62.96296 101.8518,7.40741 151.8519,31.48148 98.1481,22.22222 162.963,-1.85185 192.5926,-1.85185 150,-11.11111 51.8518,-16.66667 35.1852,-27.77778 37.037,-27.77778 20.3704,-20.37037 35.1852,-20.37037 29.6296,-16.66666 61.1111,-5.55556 90.7408,20.37037 37.037,35.18519 50,33.33333 40.7408,18.51852 48.1481,5.55555 42.5926,-7.4074 48.1481,-27.77778 16.6667,-16.66667 44.4445,-3.7037 61.1111,24.07407 29.6296,40.74074 35.1852,18.51852 51.8518,5.55556 42.5926,-5.55556 64.8148,-18.51852 135.1852,-5.55555 390.7408,33.33333 50,-3.7037 79.6296,-9.25926 75.9259,-20.37037 61.1111,-33.33334 70.3704,-46.29629 37.037,-16.66667 48.1482,109.25926 338.8889,-1.85185 22.2222,-87.03704 129.6296,11.11111 100,20.37037 125.926,42.5926 66.6666,31.48148 124.0741,3.7037 111.1111,-16.66667 40.7408,12.96297 81.4814,-35.18519 74.0741,29.62963 83.3333,-44.44444 101.8519,50 55.5556,-35.18519 75.9259,37.03704 1009.2592,-1.85185 74.0741,-20.37037 120.3704,-61.11111 62.9629,-40.74075 48.1482,44.44445 22.2222,57.40741 20.3704,14.81481 81.4815,3.70371 68.5185,-33.33334 37.037,-38.88889 44.4445,27.77778 40.7407,31.48148 61.1111,-3.7037 L 7916.6667,220 7933.3333,195.92593 8050,214.44444 l 138.8889,50 81.4815,48.14815 50,0 159.2592,-1.85185 207.4074,-14.81481 148.1482,-29.62963 50,-22.22223 83.3333,-37.03703 105.5556,-12.96297 142.5926,9.25926 179.6296,40.74074 85.1852,50 138.8889,12.96297 246.2963,1.85185 205.5553,-11.11111 161.111,-38.88889 61.111,-53.7037 31.482,-31.48149 340.741,0 62.963,64.81482 114.814,50 112.963,18.51852 244.445,0 309.259,-5.55556 170.37,-59.25926 94.445,-24.07407 103.704,-20.37037 51.851,61.11111 44.445,-5.55556 37.037,-57.4074 55.556,-18.51852 77.777,105.55555 183.334,29.62963 140.74,-14.81481 259.26,-16.66667 346.296,12.96296 329.63,16.66667 37.037,-27.77778 25.926,25.92593 29.629,-27.77778 27.778,25.92593 38.889,-25.92593 24.074,24.07408 42.592,-24.07408 25.926,24.07408 616.667,-1.85186 112.963,-9.25926 101.852,-33.33333 83.333,-46.2963 57.408,-31.48148 51.851,125.92593 53.704,-31.48148 37.037,31.48148 70.371,-38.88889 59.259,35.18519 55.555,-33.33334 33.334,31.48148 62.963,-38.88889 57.407,35.18519 42.593,-31.48148 70.37,38.88889 431.482,0 92.592,-12.96297 51.852,-14.81481 57.407,-31.48148 27.778,-24.07408 37.037,-12.96296 81.482,0 555.555,-1.85185 83.334,-27.77778 120.37,92.59259 51.852,35.18519 74.074,-62.96296 114.815,55.55555 87.037,7.40741 92.592,-7.40741 55.556,-22.22222 64.815,-38.88889 103.703,-24.07407 138.889,0 90.741,90.74074 333.333,0 38.889,-62.96297 127.778,-38.88888 112.963,9.25925 124.074,44.44445 79.63,33.33333 183.333,0 159.259,18.51852 161.111,1.85185 194.445,-27.77778 96.296,-35.18518 90.741,-40.74074 85.185,98.14815 575.926,-1.85185";
    
    
    NSMutableArray * str_points = [self svgToCGPointArray:SvgPath];
    
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
    /*b2Vec2 vert[4]={
     b2Vec2(0.0,0.8),
     b2Vec2(15.0,0.8),
     b2Vec2(15.0,1.0),
     b2Vec2(0.0,1.0)
     
     };
     groundBox.Set(vert,4);
     */
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

-(NSMutableArray*) svgToCGPointArray : (NSString*) path
{
    
    NSArray * cmd= [path componentsSeparatedByString:@" "];
    int curr_command=0;//0 = moveTo 1= MoveTo 2= lineTo 3=LineTo
    
    NSMutableArray *result=[[NSMutableArray alloc]init ];
    int currentx=0;
    int currenty=0;
    
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
