//
//  TestScene.m
//  GeneCar
//
//  Created by Andrea Terzani on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RaceScene.h"
#import "MenuLayer.h"

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
    kTagHudLayer = 2,
    
    kTagParallaxNode=1 
};

@implementation RaceScene



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	RaceScene *layer = [RaceScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    HudRaceScene *myHud2 = [HudRaceScene node];

    myHud2 = [HudRaceScene sharedHudRaceScene];
    [scene addChild:myHud2 z:1];
	
	// return the scene
	return scene;
}

- (id)init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = FALSE;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -GRAVITY);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
        
        
        GameManager * GM=[GameManager sharedGameManager];

        if(GM.selected_track!=NULL){
            
            NSString * strplist=[NSString stringWithFormat:@"%@.plist",GM.selected_track];
            
            myTrack=[[Track alloc]initFromPlist:strplist world:world];
        }else
        {
            myTrack=[[Track alloc]initFromPlist:@"superJump.plist" world:world];

        
        }
        
        myRaceManager = [RaceManager sharedRaceManager];
        myHud = [HudRaceScene sharedHudRaceScene];

        [myRaceManager loadTrackData:myTrack];
        [myRaceManager setEnded:FALSE];
        [myRaceManager setLoaded:FALSE];
        [myRaceManager setStarted:FALSE];
        
        [myRaceManager setRaceTime:0.0];
        
        
        Cromosome *c=[GM cachedCromo];
        
        mycar=[[PlayableCar alloc]init];
        
        [mycar generaFromCromosome:c world:world];

        [self initBackground];
        
        
        
        preStartTime=0;
        [self creaCancello];
        cancelloUP=TRUE;
        
        [myRaceManager setLoaded:TRUE];
        
    
        
        
        [self schedule:@selector(raceUpdate:) interval:0.1];
		[self schedule: @selector(tick:)];
        
    }
	return self;
}


-(void) draw
{
	    

    [mycar draw];
    [myTrack draw];
    
	
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x+100, winSize.width / 2-100);
    // int y = MAX(position.y, winSize.height / 2);
    int y=winSize.height/2;
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;
    
}
-(void) raceUpdate: (ccTime) dt{


    [myHud setTime:myRaceManager.raceTime]; 

    
    if([myHud reset]){
        [self resetCar];
    }
    if([myHud Gomain]){
        [self goMainMenu];
    }
    
   
    if([myRaceManager loaded] && ![myRaceManager started]){
        
        preStartTime+=dt;
        
    }
    
    if([myRaceManager started]&& ![myRaceManager ended]){
        
        myRaceManager.raceTime+=dt;
        
    }
    
    
    if (preStartTime>5.0 && [myRaceManager started]==FALSE && cancelloUP) {
        preStartTime=0;
        [self rimuoviCancello];
        [myRaceManager setStarted:TRUE];
    }
    
    if(pos.x*PTM_RATIO > [myRaceManager finishLane_x] && [myRaceManager started]){
        
        [myRaceManager setEnded:TRUE];
        [myRaceManager setStarted:FALSE];
        
    }


}

-(void) tick: (ccTime) dt
{
    int32 velocityIterations = V_ITERATION;
	int32 positionIterations = P_ITERATION;
    
    
    if(myHud.freno_btn.active==TRUE){
        [mycar frena];
        
    }else{
        if(myHud.acceleratore_btn.active==TRUE){
    
        [mycar accelera];
        
        }
    }
    
        
        world->Step(dt, velocityIterations, positionIterations);
    [mycar update];

    pos=[mycar getPosition];
    [self setViewpointCenter:ccp((pos.x*PTM_RATIO),pos.y*PTM_RATIO)];
     
}

-(void) resetCar
{
    

    
        NSLog(@"resetCar");
        
        GameManager * GM=[GameManager sharedGameManager];

    
        Cromosome *c=[GM cachedCromo];

        
        [mycar destroy:world];
        
        mycar = [[PlayableCar alloc]init];
        
        [mycar generaFromCromosome:c world:world];
        [GM setCurrentCromo:c];
        [myHud setReset:FALSE];
    
        
    }
   
-(void) goMainMenu
{
    
    NSLog(@"GoMainMenu");
    [myHud setGomain:FALSE];
    
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[MenuLayer scene]]];

    
}






-(void) initBackground
{
    
    
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    
     
     CCParallaxNode *parallaxNode=[CCParallaxNode node];
     
     [self addChild:parallaxNode z:-10 tag:kTagParallaxNode];
     
     CCSprite *cielo = [CCSprite spriteWithFile:@"cielo.png" rect:CGRectMake(0, 0, 1024*2, 512)];
     [cielo.texture setTexParameters:&params];
     
     [parallaxNode addChild:cielo z:0 parallaxRatio:ccp(0.01,1.0) positionOffset:CGPointMake(512,256)];
     
     
     CCSprite *nuvole = [CCSprite spriteWithFile:@"nuvole.png" rect:CGRectMake(0, 0, 1024*2, 512)];
     [nuvole.texture setTexParameters:&params];
     nuvole.position=ccp(240,0);
     
     [parallaxNode addChild:nuvole z:1 parallaxRatio:ccp(0.05,1.0) positionOffset:CGPointMake(512,256)];
     
     
     CCSprite *montagne = [CCSprite spriteWithFile:@"montagne.png" rect:CGRectMake(0, 0, 1024*7, 512)];
     [montagne.texture setTexParameters:&params];
     
     [parallaxNode addChild:montagne z:2 parallaxRatio:ccp(0.2,1.0) positionOffset:CGPointMake(512,256)];
     
     CCSprite *alberi = [CCSprite spriteWithFile:@"alberi.png" rect:CGRectMake(0, 0, 1024*35, 512)];
     [alberi.texture setTexParameters:&params];
     alberi.position=ccp(240,0);
     
     [parallaxNode addChild:alberi z:3 parallaxRatio:ccp(0.7,1.0) positionOffset:CGPointMake(512,256)];
     
     
     CCSprite *strada = [CCSprite spriteWithFile:@"strada.png" rect:CGRectMake(0, 0, 1024*40, 512)];
     [strada.texture setTexParameters:&params];
     strada.position=ccp(240,0);
     
     [parallaxNode addChild:strada z:4 parallaxRatio:ccp(1.0,1.0) positionOffset:CGPointMake(512,256)];
     
     
     
}

-(void)creaCancello{
    
    // Define the ground body.
    b2BodyDef cancelloBodyDef;
    cancelloBodyDef.position.Set(13, 0); // bottom-left corner
    
    cancelloBody = world->CreateBody(&cancelloBodyDef);
    
    b2PolygonShape cancelloBox;		
    b2FixtureDef cancelloFixtureDef;
    
    cancelloBox.SetAsBox(0.2, 3.0);
    
    cancelloFixtureDef.friction=0.5f;
    cancelloFixtureDef.restitution=0.0f;
    cancelloFixtureDef.shape=&cancelloBox;
    
    
    cancelloBody->CreateFixture(&cancelloFixtureDef);





}
-(void)rimuoviCancello{
    
    cancelloUP=FALSE;
    world->DestroyBody(cancelloBody);
      
    
    
    
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [mycar dealloc];
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
